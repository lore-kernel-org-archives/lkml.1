Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbXKFTuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbXKFTuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXKFTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:50:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36806 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbXKFTuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:50:24 -0500
Date: Tue, 6 Nov 2007 11:46:29 -0800
From: Greg KH <greg@kroah.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded
Message-ID: <20071106194629.GA1691@kroah.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <1194374218.26782.6.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194374218.26782.6.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 10:36:58AM -0800, Badari Pulavarty wrote:
> On Tue, 2007-11-06 at 02:33 -0800, akpm@linux-foundation.org wrote:
> > The mm snapshot broken-out-2007-11-06-02-32.tar.gz has been uploaded to
> > 
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-06-02-32.tar.gz
> > 
> 
> > gregkh-driver-kset-convert-sys-devices-to-use-kset_create.patch
> 
> Above patch renamed devices_subsys to devices_kset to catch all users of
> the variable. Need fixes to vio.
> 
> 
> # make -j8 zImage
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
> <stdin>:1389:2: warning: #warning syscall revokeat not implemented
> <stdin>:1393:2: warning: #warning syscall frevoke not implemented
>   CHK     include/linux/compile.h
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/powerpc/kernel/built-in.o(.toc+0x1548): undefined reference to
> `devices_subsys'
> make: *** [.tmp_vmlinux1] Error 1
> 
> 
> Here is the patch, Is this correct usage ?

Yes, but, what is this file doing mucking around in a "private" variable
to the driver core?  No wonder I never caught this, as it's one
reference away from being declared static.

Please fix this file up properly, like the comment in vio.c shows:
	 * XXX once vio_bus_type.devices is actually used as a kset in
	 * drivers/base/bus.c, this function should be removed in favor of
	 * "device_find(kobj_name, &vio_bus_type)"

The fact that this function works at all is so tenous and scary that I
would never trust it on a running system.  Let alone something so
"enterprise" as a pseries box...

thanks,

greg k-h
