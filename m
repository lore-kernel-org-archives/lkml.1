Return-Path: <linux-kernel-owner+w=401wt.eu-S934065AbYBMRRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbYBMRRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbYBMRRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:17:23 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:16447 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbYBMRRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:17:21 -0500
Date: Wed, 13 Feb 2008 09:16:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Fabio Coatti <cova@ferrara.linux.it>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       len.brown@intel.com
Subject: Re: stuck with 2.6.23.14 on x86_64
Message-Id: <20080213091642.b484a7ba.randy.dunlap@oracle.com>
In-Reply-To: <200802131021.23974.cova@ferrara.linux.it>
References: <200802121503.41328.cova@ferrara.linux.it>
	<200802121847.19991.cova@ferrara.linux.it>
	<200802122155.13959.rjw@sisk.pl>
	<200802131021.23974.cova@ferrara.linux.it>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:21:23 +0100 Fabio Coatti wrote:

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


Yes, this is yet another select problem.  X86_64_NUMA_ACPI
selects ACPI, even though PM is not enabled.  :(

So you have a manual fix:  just enable CONFIG_PM.

Is this specific config important to you?  I.e., do you want/need
NUMA support?  If so, you'll just need to continue enabling CONFIG_PM.

I made a patch that prevents the select problem (see below [now added]).

The "select PCI" in the X86_64_ACPI_NUMA config option is evil.  :(


> Anyway, with .16 and CONFIG_PM set, I get this :
> ===================
> WARNING: vmlinux.o(.text+0x1f6395): Section mismatch: reference 
> to .init.data.14:pxm_to_node_map (between 'pxm_to_node' and 'node_to_pxm')
> WARNING: vmlinux.o(.text+0x1f63a7): Section mismatch: reference 
> to .init.data.14:node_to_pxm_map (between 'node_to_pxm' 
> and '__acpi_map_pxm_to_node')
> WARNING: vmlinux.o(.text+0x1f63b2): Section mismatch: reference 
> to .init.data.14:pxm_to_node_map (between '__acpi_map_pxm_to_node' 
> and 'acpi_get_pxm')
> WARNING: vmlinux.o(.text+0x1f63bc): Section mismatch: reference 
> to .init.data.14:node_to_pxm_map (between '__acpi_map_pxm_to_node' 
> and 'acpi_get_pxm')
> WARNING: vmlinux.o(.text+0x1f6412): Section mismatch: reference 
> to .init.data.14:pxm_to_node_map (between 'acpi_map_pxm_to_node' 
> and 'acpi_get_node')
> WARNING: vmlinux.o(.text+0x1f6458): Section mismatch: reference 
> to .init.data.14:pxm_to_node_map (between 'acpi_map_pxm_to_node' 
> and 'acpi_get_node')
> WARNING: vmlinux.o(.text+0x1f645f): Section mismatch: reference 
> to .init.data.14:node_to_pxm_map (between 'acpi_map_pxm_to_node' 
> and 'acpi_get_node')
> =========================
> 
> Anyway, it booted and so far it runs without "splice" problem, thanks.


---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix a kconfig 'select' problem: X86_64_NUMA_ACPI selects ACPI,
so ACPI could be enabled even when PM is not enabled.
This causes a build failure, so make X86_64_NUMA_ACPI depend on PM.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86_64/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23.16.orig/arch/x86_64/Kconfig
+++ linux-2.6.23.16/arch/x86_64/Kconfig
@@ -367,7 +367,7 @@ config NODES_SHIFT
 
 config X86_64_ACPI_NUMA
        bool "ACPI NUMA detection"
-       depends on NUMA
+       depends on NUMA && PM
        select ACPI 
 	select PCI
        select ACPI_NUMA

