Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZKRBaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZKRBaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbZKRBai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:30:38 -0500
Received: from ozlabs.org ([203.10.76.45]:56450 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568AbZKRBaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:30:35 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adam Litke <agl@us.ibm.com>
Subject: Re: virtio: Add memory statistics reporting to the balloon driver (V2)
Date: Wed, 18 Nov 2009 12:00:39 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: qemu-devel@nongnu.org, Anthony Liguori <aliguori@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1258488996.2820.35.camel@aglitke> <1258490189.2820.37.camel@aglitke>
In-Reply-To: <1258490189.2820.37.camel@aglitke>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181200.39971.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 07:06:29 am Adam Litke wrote:
> virtio: Add memory statistics reporting to the balloon driver (V2)
> 
> Changes since V1:
>  - Use a virtqueue instead of the device config space

Hi Adam,

    If Anthony's happy, I'm happy with this approach.

Couple of minor points:

> +static inline void update_stat(struct virtio_balloon *vb, int idx,
> +				unsigned int tag, unsigned long val)
> +{
> +	BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
> +	vb->stats[idx].tag = tag;
> +	vb->stats[idx].val = cpu_to_le32(val);
> +}

The little-endian conversion of the balloon driver is a historical mistake
(no other driver does this).  Let's not extend it to the stats.

Here you've done one and not the other, which is even worse.  (Sparse would
have found this, I assume).

> +struct virtio_balloon_stat
> +{
> +	__le16 tag;
> +	__le32 val;
> +};

Is 32 bits sufficient?  A big machine might get over 4bn faults, and certainly
4 TB of memory isn't that far away.

Thanks,
Rusty.
