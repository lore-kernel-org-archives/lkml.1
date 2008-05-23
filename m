Return-Path: <linux-kernel-owner+w=401wt.eu-S1759781AbYEWWjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781AbYEWWjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYEWWj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:39:28 -0400
Received: from xenotime.net ([66.160.160.81]:37248 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751196AbYEWWj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:39:26 -0400
Date: Fri, 23 May 2008 15:39:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
 reference to `request_firmware'
Message-Id: <20080523153924.af48e95e.rdunlap@xenotime.net>
In-Reply-To: <1211580030.11477.50.camel@localhost.localdomain>
References: <200805161906.19321.toralf.foerster@gmx.de>
	<1211018673.3603.7.camel@localhost.localdomain>
	<20080517141749.GD3284@cs181133002.pp.htv.fi>
	<1211453544.3956.33.camel@localhost.localdomain>
	<20080523105412.cc13647d.rdunlap@xenotime.net>
	<1211565551.11477.26.camel@localhost.localdomain>
	<20080523110457.de353625.rdunlap@xenotime.net>
	<1211574780.11477.44.camel@localhost.localdomain>
	<20080523144849.3773cac3.rdunlap@xenotime.net>
	<1211580030.11477.50.camel@localhost.localdomain>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 17:00:30 -0500 James Bottomley wrote:

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

Disagree with which part(s)?

>      1. No stubs and simply select FW_LOADER for everything
>      2. Stubs that actually work in all situations.
> 
> My patch does 2.  I can see an argument for 1. but since we have the
> stubs, making them work in all cases seems like the smaller change to
> functionality.

Oh, I'm for the stubs approach.

So with SCSI_SAS_LIBSAS=y and FW_LOADER=m, you would want/expect
request_firmware() to return -EINVAL all of the time?
Hm, I suppose that it has to either do that or select FW_LOADER. ?

---
~Randy
