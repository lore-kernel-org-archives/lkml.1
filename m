Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZKSAgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZKSAgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZKSAgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:36:38 -0500
Received: from ozlabs.org ([203.10.76.45]:42281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241AbZKSAgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:36:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the balloon driver (V2)
Date: Thu, 19 Nov 2009 11:06:38 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Adam Litke <agl@us.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       qemu-devel@nongnu.org, Avi Kivity <avi@redhat.com>
References: <1258488996.2820.35.camel@aglitke> <200911181200.39971.rusty@rustcorp.com.au> <4B040C82.6070901@codemonkey.ws>
In-Reply-To: <4B040C82.6070901@codemonkey.ws>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191106.38976.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 01:32:26 am Anthony Liguori wrote:
> Rusty Russell wrote:
> > The little-endian conversion of the balloon driver is a historical mistake
> > (no other driver does this).  Let's not extend it to the stats.
> 
> I think the mistake is that the other drivers don't do that.
> 
> We cheat in qemu and assume that the guest is always in a fixed 
> endianness but this is not always the case for all architectures.

Perhaps, but it's documented in the spec.  My assertion remains that to do
any virtualization you need to know what the guest endian is anyway, so
endian converts throughout the drivers just add pain for driver authors.

> I think making the interface u64 and byte based would be the best 
> solution.  Making assumptions about page size across guest and host is 
> another thing we should try to avoid.

Yep, just report the raw byte counts as u64.

Cheers,
Rusty.
