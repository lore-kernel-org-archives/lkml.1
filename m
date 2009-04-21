Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZDUHZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZDUHZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZDUHZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:25:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38073 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZDUHZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:25:25 -0400
Date: Tue, 21 Apr 2009 09:25:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] block: enable by default support for large
	devices and files on 32-bit archs
Message-ID: <20090421072524.GX4593@kernel.dk>
References: <200903281916.06905.bzolnier@gmail.com> <200904202252.08619.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904202252.08619.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20 2009, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 28 March 2009 19:16:06 Bartlomiej Zolnierkiewicz wrote:
> > 
> > Enable by default support for large devices and files (CONFIG_LBD):
> > 
> > - With 1TB disks being a commodity hardware it is quite easy to hit 2TB
> >   limitation while building RAIDs etc. and many distros have been using
> >   CONFIG_LBD=y by default already (at least Fedora 10 and openSUSE 11.1).
> > 
> > - This should also prevent a subtle ext4 filesystem compatibility issue:
> >   mke2fs.ext4 defaults to creating filesystems with huge_files feature
> >   enabled and such filesystems cannot be later mounted read-write on
> >   machines with CONFIG_LBD=n (it should be quite easy to hit this issue
> >   when trying to use filesystem created using distro kernel on system
> >   running the self-build kernel, think about USB disk enclosures & co.).
> > 
> > While at it:
> > 
> > - Clarify config option help text w.r.t. mounting ext4 filesystems
> >   (they can be mounted with CONFIG_LBD=n but in the read-only mode).
> > 
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > Unfortunately to also update the existings [def]configs the config option
> > rename would be needed.  Actually, since the performance impact and kernel
> > size increase seem to be minimal (at least on x86-32) maybe we should just
> > go ahead and remove CONFIG_LBD (== always use 64-bit sector_t/blkcnt_t)?
> > 
> > I can make needed changes once there is agreement on preferred approach...
> 
> Jens, any thoughts on this?
> 
> [ Please note that the patch below should be safe for 2.6.30. ]

I'm fine with it, and since nobody has objected since it was posted,
lets just do it. I have added it.

> 
> >  block/Kconfig |   11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > Index: b/block/Kconfig
> > ===================================================================
> > --- a/block/Kconfig
> > +++ b/block/Kconfig
> > @@ -26,6 +26,7 @@ if BLOCK
> >  config LBD
> >  	bool "Support for large block devices and files"
> >  	depends on !64BIT
> > +	default y
> >  	help
> >  	  Enable block devices or files of size 2TB and larger.
> >  
> > @@ -38,11 +39,13 @@ config LBD
> >  
> >  	  The ext4 filesystem requires that this feature be enabled in
> >  	  order to support filesystems that have the huge_file feature
> > -	  enabled.    Otherwise, it will refuse to mount any filesystems
> > -	  that use the huge_file feature, which is enabled by default
> > -	  by mke2fs.ext4.   The GFS2 filesystem also requires this feature.
> > +	  enabled.  Otherwise, it will refuse to mount in the read-write
> > +	  mode any filesystems that use the huge_file feature, which is
> > +	  enabled by default by mke2fs.ext4.
> >  
> > -	  If unsure, say N.
> > +	  The GFS2 filesystem also requires this feature.
> > +
> > +	  If unsure, say Y.
> >  
> >  config BLK_DEV_IO_TRACE
> >  	bool "Support for tracing block io actions"
> > 

-- 
Jens Axboe

