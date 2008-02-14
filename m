Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbYBNFtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbYBNFtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 00:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYBNFsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 00:48:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:49286 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbYBNFst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 00:48:49 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Fabio Coatti <cova@ferrara.linux.it>
Subject: Re: stuck with 2.6.23.14 on x86_64
Date: Thu, 14 Feb 2008 00:48:12 -0500
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
References: <200802121503.41328.cova@ferrara.linux.it> <200802122155.13959.rjw@sisk.pl> <200802131021.23974.cova@ferrara.linux.it>
In-Reply-To: <200802131021.23974.cova@ferrara.linux.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802140048.12258.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 04:21, Fabio Coatti wrote:
> Alle martedì 12 febbraio 2008, Rafael J. Wysocki ha scritto:
> > On Tuesday, 12 of February 2008, Fabio Coatti wrote:
> > > Alle martedì 12 febbraio 2008, Randy Dunlap ha scritto:
> > > > On Tue, 12 Feb 2008 15:03:41 +0100 Fabio Coatti wrote:
> > > > > Hi all,
> > > > > I'm stuck in a weird situation: I'm unable to go beyond 2.6.23.14, so
> > > > > to fix the splice bug I've had to apply by hand the patch. (x86_64)
> > > > >
> > > > > Basically, with 2.6.24.2 (the same with 2.6.24 and .1), tha machine
> > > > > won't boot due to a problem with cciss driver, that prevents to find
> > > > > the / partition. (bug described here: Kernel Bug Tracker Bug 9859
> > > > > http://bugzilla.kernel.org/show_bug.cgi?id=9859 );
> > > > >
> > > > > With kernels 2.6.23, the lastest that I can compile is 2.6.23.14;
> > > > > starting from .15 (and .16) I get this message:
> > > > >
> > > > > ======================
> > > > >   UPD     include/linux/compile.h
> > > > >   CC      init/version.o
> > > > >   LD      init/built-in.o
> > > > >   LD      .tmp_vmlinux1
> > > > > drivers/built-in.o: In function `acpi_init':
> > > > > bus.c:(.init.text+0x1713): undefined reference to `pm_flags'
> > > > > bus.c:(.init.text+0x1756): undefined reference to `pm_flags'
> > > > > ======================
> > > > >
> > > > > All .config are the same, (make oldconfig) beside the obvious
> > > > > differences between .23 and .24
> > > > >
> > > > > Hardware: x86_64 AMD 2216HE
> > > > > SCSI controller: HP Smart Array E200i Controller
> > > > > Compiler: gcc (GCC) 4.1.1
> > > > > binutils: 2.16.1
> > > > >
> > > > > On a x86 machine, Intel(R) Xeon(TM) CPU 3.20GHz
> > > > > with a cciss0: HP Smart Array 6i Controller,
> > > > > the 2.6.24.2 compiles just fine and works, so the cciss problems
> > > > > seems related only to E200i controller.
> > > > >
> > > > > Right now, on AMD64 machines, I'm forced to patch by hand the kernel,
> > > > > that's quite uncomfortable :)
> > > > >
> > > > > Can someone point me in the right direction to get out of this
> > > > > situation? Of course I can provide any further information. (.config
> > > > > not inlcuded now to avoid cluttering  )
> > > > >
> > > > > Thanks for any answer.
> > > >
> > > > a/ send .config file for the build problem above
> > > > b/ How do you download and/or apply 2.6.23.{15,16} ?
> > > > 	Full tarball or base tarball + patches?
> > > > 	If patches, what base tree are they applied to?
> > >
> > > full tarball from kernel.org (.16), tried also applying patches to 2.6.23
> > > vanilla.(.15,.16) Same process leads to successful compilation for .14
> >
> > You're not supposed to have CONFIG_PM unset and CONFIG_ACPI set at the same
> > time.  The oldconfig generation must have gone wrong at one point.
> 
> Maybe it's not supposed to have this situation, but maybe you should tell this 
> to the kernel itself :)
> 
> # zcat /proc/config.gz | egrep "PM|ACPI"
> CONFIG_X86_64_ACPI_NUMA=y
> # CONFIG_PM is not set
> CONFIG_ACPI=y
> # CONFIG_ACPI_PROCFS is not set
> 
> # uname -rv
> 2.6.23.12 #3 SMP Tue Feb 12 11:22:16 CET 2008
> 
> And you can easily get this situation from menuconfig: just fire up make 
> menuconfig without any .config, go to power management options and turn 
> off "Power Management support". exit and look at .config:
> 
> # CONFIG_PM is not set
> CONFIG_SUSPEND_SMP_POSSIBLE=y
> CONFIG_HIBERNATION_SMP_POSSIBLE=y
> CONFIG_ACPI=y
> 
> Maybe if this is not supposed to be the right situation, some dependencies are 
> not respected... (tested on .16)

I think this got fixed in 2.6.24 by the X86_64_ACPI_NUMA dependencies.
(in 2.6.23 it used to select ACPI, in 2.6.24 it depends on ACPI).

So I think in 2.6.24 you should not have this trouble.

thanks,
-Len
