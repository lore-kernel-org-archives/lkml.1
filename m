Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZKSXxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZKSXxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 18:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757889AbZKSXx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 18:53:29 -0500
Received: from ozlabs.org ([203.10.76.45]:32918 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757873AbZKSXx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 18:53:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adam Litke <agl@us.ibm.com>
Subject: Re: virtio: Add memory statistics reporting to the balloon driver (V3)
Date: Fri, 20 Nov 2009 10:23:30 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Anthony Liguori <aliguori@us.ibm.com>, qemu-devel@nongnu.org,
       Avi Kivity <avi@redhat.com>, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1258643169.3464.3.camel@aglitke> <1258643945.3464.5.camel@aglitke>
In-Reply-To: <1258643945.3464.5.camel@aglitke>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911201023.30709.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 01:49:05 am Adam Litke wrote:
> Rusty and Anthony,
> If I've addressed all outstanding issues, please consider this patch for
> inclusion.  Thanks.
> 
> Changes since V2:
>  - Increase stat field size to 64 bits
>  - Report all sizes in kb (not pages)

Hi Adam,

   Looks like we're very close.  A few minor things:

Why k?  Why not just do the simplest possible thing, and just report all
stats as straight numbers, now we have 64 bits.

>  - Drop anon_pages stat and fix endianness conversion

Please drop endianness conversion.

> +struct virtio_balloon_stat
> +{
> +	__le16 tag;
> +	__le64 val;
> +};

Let's not introduce padding as well; __attribute__((packed)) here please.

Thanks,
Rusty.
