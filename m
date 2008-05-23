Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbYEWWLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbYEWWLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760442AbYEWWIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:08:38 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59244 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760168AbYEWWIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:08:36 -0400
Date: Sat, 24 May 2008 01:06:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
	reference to `request_firmware'
Message-ID: <20080523220609.GC4886@cs181133002.pp.htv.fi>
References: <200805161906.19321.toralf.foerster@gmx.de> <1211018673.3603.7.camel@localhost.localdomain> <20080517141749.GD3284@cs181133002.pp.htv.fi> <1211453544.3956.33.camel@localhost.localdomain> <20080523105412.cc13647d.rdunlap@xenotime.net> <1211565551.11477.26.camel@localhost.localdomain> <20080523110457.de353625.rdunlap@xenotime.net> <1211574780.11477.44.camel@localhost.localdomain> <20080523144849.3773cac3.rdunlap@xenotime.net> <1211580030.11477.50.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1211580030.11477.50.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 05:00:30PM -0500, James Bottomley wrote:
> On Fri, 2008-05-23 at 14:48 -0700, Randy Dunlap wrote:
> > On Fri, 23 May 2008 15:33:00 -0500 James Bottomley wrote:
> > 
> > > On Fri, 2008-05-23 at 11:04 -0700, Randy Dunlap wrote:
> > > > On Fri, 23 May 2008 12:59:11 -0500 James Bottomley wrote:
> > > > 
> > > > > On Fri, 2008-05-23 at 10:54 -0700, Randy Dunlap wrote:
> > > > > > On Thu, 22 May 2008 11:52:24 +0100 James Bottomley wrote:
> > > > > > 
> > > > > > > On Sat, 2008-05-17 at 17:17 +0300, Adrian Bunk wrote:
> > > > > > > > On Sat, May 17, 2008 at 11:04:31AM +0100, James Bottomley wrote:
> > > > > > > > > On Fri, 2008-05-16 at 19:06 +0200, Toralf Förster wrote:
> > > > > > > > > > Hello,
> > > > > > > > > > 
> > > > > > > > > > the build (.config attached) failed, make ends with :
> > > > > > > > > > ...
> > > > > > > > > >   UPD     include/linux/compile.h
> > > > > > > > > >   CC      init/version.o
> > > > > > > > > >   LD      init/built-in.o
> > > > > > > > > >   LD      vmlinux
> > > > > > > > > > drivers/built-in.o: In function `sas_request_addr':
> > > > > > > > > > (.text+0x33bab): undefined reference to `request_firmware'
> > > > > > > > > > drivers/built-in.o: In function `sas_request_addr':
> > > > > > > > > > (.text+0x33c3f): undefined reference to `release_firmware'
> > > > > > > > > > make: *** [vmlinux] Error 1
> > > > > > > > > 
> > > > > > > > > There's a slight fault in the stub logic.  It fails for FW_LOADER=m and
> > > > > > > > > the user =y.
> > > > > > > > > 
> > > > > > > > > This should fix it.
> > > > > > > > 
> > > > > > > > An interesting question is whether we actually want to have the stub at 
> > > > > > > > all - the compile errors catched cases where someone forgot to select 
> > > > > > > > FW_LOADER at compile time instead of turning them into possible runtime 
> > > > > > > > problems as will happen after your patch.
> > > > > > > 
> > > > > > > Well, the original intent of the stubs was to have the loader nop if it
> > > > > > > wasn't available.  There was simply one case forgotten (the fact that a
> > > > > > > modular loader isn't usable from built in components).
> > > > > > > 
> > > > > > > > Are there any serious use cases where SCSI_SAS_LIBSAS is used in very 
> > > > > > > > space limited environments and without any other drivers that select 
> > > > > > > > FW_LOADER in the kernel?
> > > > > > > 
> > > > > > > Probably in the future, certainly on embedded OSs used for storage
> > > > > > > devices.  Given the convergence of SAS/SATA chips, it's possible for
> > > > > > > other handhelds, but I'm not convinced of that.
> > > > > > 
> > > > > > Has there been any resolution to this build issue?
> > > > > > 
> > > > > > Do we know what we want?  then maybe a patch can be done...
> > > > > 
> > > > > As long as the patch works, that's what I propose.
> > > > 
> > > > Sorry, I am not understanding what you are saying.
> > > > Please explain.
> > > 
> > > As long as the patch I previously posted on this thread
> > > 
> > > http://marc.info/?l=linux-scsi&m=121101871800303
> > > 
> > > Actually works.  This is the patch I propose to use to fix the issue.
> > 
> > 
> > Thanks for the pointer to the patch.  That does actually build cleanly
> > (but I would say that the patch is incorrect).
> > 
> > The case is (similar to that scsi_dh problem):
> > CONFIG_SCSI_SAS_LIBSAS=y and CONFIG_FW_LOADER=m, so libsas's
> > sas_request_addr() always returns -EINVAL as the value of
> > request_firmware().  Is that what we want/expect for these CONFIGs?
> 
> Actually, I disagree.  There are two choices here
> 
>      1. No stubs and simply select FW_LOADER for everything
>      2. Stubs that actually work in all situations.
> 
> My patch does 2.  I can see an argument for 1. but since we have the
> stubs, making them work in all cases seems like the smaller change to
> functionality.

We could do:
1. stubs that actually work in all situations and
2. enable FW_LOADER uncondictionally unless EMBEDDED=y and
3. remove all "select FW_LOADER"'s

This would:
- remove all problems we currently have in this area and
- make some kconfig stuff easier while
- giving people who really need small kernels more choices than today.

Your patch would be step 1.

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

