Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbXENHMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbXENHMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 03:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXENHMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 03:12:19 -0400
Received: from ozlabs.org ([203.10.76.45]:53974 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbXENHMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 03:12:18 -0400
Subject: Re: [PATCH 2/5] lguest guest feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070513184339.GZ4095@ftp.linux.org.uk>
References: <1178846246.23513.21.camel@localhost.localdomain>
	 <1178846354.23513.23.camel@localhost.localdomain>
	 <1178846490.23513.27.camel@localhost.localdomain>
	 <20070513184339.GZ4095@ftp.linux.org.uk>
Content-Type: text/plain
Date: Mon, 14 May 2007 17:11:49 +1000
Message-Id: <1179126709.23513.194.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 19:43 +0100, Al Viro wrote:
> On Fri, May 11, 2007 at 11:21:30AM +1000, Rusty Russell wrote:
> >  	/* Devices are in page above top of "normal" mem. */
> > -	lguest_devices = ioremap(max_pfn << PAGE_SHIFT, PAGE_SIZE);
> > +	lguest_devices = (__force void*)ioremap(max_pfn<<PAGE_SHIFT,PAGE_SIZE);
> 
> Er...  What's being done here?  What are we mapping and what's going to
> be accessed when we dereference that sucker?

This, too, is now wrapped in lguest_map() in the updated patch.  

Guest virtual device memory can be directly accessed, but Jeff Garzik
and Christoph Hellwig made good points about not encouraging such
abnormal use of ioremap in drivers.

BTW, I've done a new rollup patch of lguest against 2.6.21, if you would
like to review the whole thing.  This version includes the big code
documentation patch not yet in -mm.

	http://lguest.ozlabs.org/lguest-2.6.21-290.patch.gz

Thanks,
Rusty.

