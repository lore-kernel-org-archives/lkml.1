Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYLaK46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYLaK46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 05:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbYLaKwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 05:52:41 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:43075 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbYLaKwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 05:52:17 -0500
Date: Wed, 31 Dec 2008 05:51:51 -0500
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 01/15] ACPI: create kernel/acpi/
In-reply-to: <1230720725-9376-1-git-send-email-lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Message-id: <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.1.28.gc32f76
References: <1230720725-9376-1-git-send-email-lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

All of the Linux ACPI implementation used to live in drivers/acpi.
But most of the code isn't in drivers, and there was constant
confusion about what files are part of ACPICA.
So here we split ACPI code into three pieces.

kernel/acpi/*.c
	These are regular GPL Linux files
	that are statically built into the kernel.

kernel/acpi/acpica/*.c
	These implement the ACPICA Core Interpreter.
	They come from http://acpica.org/ and are
	dual licensed.  Linux shares them with
	other operating systems, such as BSD, and Solaris.

drivers/acpi/*.c
	Also regular GPL Linux files,
	these drivers implement OS policy, for
	there is no OS policy in the two bodies
	of code above.  A typical distro will
	include all of these drivers, for they
	are largely what make ACPI useful.

This change lays the groundwork for moving the
headers so that internal functions remain private.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/Makefile                              |   23 +--------
 drivers/acpi/dispatcher/Makefile                   |    9 ---
 drivers/acpi/events/Makefile                       |    9 ---
 drivers/acpi/executer/Makefile                     |   10 ----
 drivers/acpi/hardware/Makefile                     |    9 ---
 drivers/acpi/namespace/Makefile                    |   12 -----
 drivers/acpi/parser/Makefile                       |    8 ---
 drivers/acpi/resources/Makefile                    |   10 ----
 drivers/acpi/sleep/Makefile                        |    5 --
 drivers/acpi/tables/Makefile                       |    7 ---
 drivers/acpi/utilities/Makefile                    |    9 ---
 kernel/Makefile                                    |    1 +
 kernel/acpi/Makefile                               |   26 ++++++++++
 kernel/acpi/acpica/Makefile                        |   52 ++++++++++++++++++++
 .../dispatcher => kernel/acpi/acpica}/dsfield.c    |    0 
 .../dispatcher => kernel/acpi/acpica}/dsinit.c     |    0 
 .../dispatcher => kernel/acpi/acpica}/dsmethod.c   |    0 
 .../dispatcher => kernel/acpi/acpica}/dsmthdat.c   |    0 
 .../dispatcher => kernel/acpi/acpica}/dsobject.c   |    0 
 .../dispatcher => kernel/acpi/acpica}/dsopcode.c   |    0 
 .../dispatcher => kernel/acpi/acpica}/dsutils.c    |    0 
 .../dispatcher => kernel/acpi/acpica}/dswexec.c    |    0 
 .../dispatcher => kernel/acpi/acpica}/dswload.c    |    0 
 .../dispatcher => kernel/acpi/acpica}/dswscope.c   |    0 
 .../dispatcher => kernel/acpi/acpica}/dswstate.c   |    0 
 .../acpi/events => kernel/acpi/acpica}/evevent.c   |    0 
 .../acpi/events => kernel/acpi/acpica}/evgpe.c     |    0 
 .../acpi/events => kernel/acpi/acpica}/evgpeblk.c  |    0 
 .../acpi/events => kernel/acpi/acpica}/evmisc.c    |    0 
 .../acpi/events => kernel/acpi/acpica}/evregion.c  |    0 
 .../acpi/events => kernel/acpi/acpica}/evrgnini.c  |    0 
 .../acpi/events => kernel/acpi/acpica}/evsci.c     |    0 
 .../acpi/events => kernel/acpi/acpica}/evxface.c   |    0 
 .../acpi/events => kernel/acpi/acpica}/evxfevnt.c  |    0 
 .../acpi/events => kernel/acpi/acpica}/evxfregn.c  |    0 
 .../executer => kernel/acpi/acpica}/exconfig.c     |    0 
 .../executer => kernel/acpi/acpica}/exconvrt.c     |    0 
 .../executer => kernel/acpi/acpica}/excreate.c     |    0 
 .../acpi/executer => kernel/acpi/acpica}/exdump.c  |    0 
 .../acpi/executer => kernel/acpi/acpica}/exfield.c |    0 
 .../acpi/executer => kernel/acpi/acpica}/exfldio.c |    0 
 .../acpi/executer => kernel/acpi/acpica}/exmisc.c  |    0 
 .../acpi/executer => kernel/acpi/acpica}/exmutex.c |    0 
 .../acpi/executer => kernel/acpi/acpica}/exnames.c |    0 
 .../executer => kernel/acpi/acpica}/exoparg1.c     |    0 
 .../executer => kernel/acpi/acpica}/exoparg2.c     |    0 
 .../executer => kernel/acpi/acpica}/exoparg3.c     |    0 
 .../executer => kernel/acpi/acpica}/exoparg6.c     |    0 
 .../acpi/executer => kernel/acpi/acpica}/exprep.c  |    0 
 .../executer => kernel/acpi/acpica}/exregion.c     |    0 
 .../executer => kernel/acpi/acpica}/exresnte.c     |    0 
 .../executer => kernel/acpi/acpica}/exresolv.c     |    0 
 .../acpi/executer => kernel/acpi/acpica}/exresop.c |    0 
 .../acpi/executer => kernel/acpi/acpica}/exstore.c |    0 
 .../executer => kernel/acpi/acpica}/exstoren.c     |    0 
 .../executer => kernel/acpi/acpica}/exstorob.c     |    0 
 .../executer => kernel/acpi/acpica}/exsystem.c     |    0 
 .../acpi/executer => kernel/acpi/acpica}/exutils.c |    0 
 .../acpi/hardware => kernel/acpi/acpica}/hwacpi.c  |    0 
 .../acpi/hardware => kernel/acpi/acpica}/hwgpe.c   |    0 
 .../acpi/hardware => kernel/acpi/acpica}/hwregs.c  |    0 
 .../acpi/hardware => kernel/acpi/acpica}/hwsleep.c |    0 
 .../acpi/hardware => kernel/acpi/acpica}/hwtimer.c |    0 
 .../acpi/hardware => kernel/acpi/acpica}/hwxface.c |    0 
 .../namespace => kernel/acpi/acpica}/nsaccess.c    |    0 
 .../namespace => kernel/acpi/acpica}/nsalloc.c     |    0 
 .../acpi/namespace => kernel/acpi/acpica}/nsdump.c |    0 
 .../namespace => kernel/acpi/acpica}/nsdumpdv.c    |    0 
 .../acpi/namespace => kernel/acpi/acpica}/nseval.c |    0 
 .../acpi/namespace => kernel/acpi/acpica}/nsinit.c |    0 
 .../acpi/namespace => kernel/acpi/acpica}/nsload.c |    0 
 .../namespace => kernel/acpi/acpica}/nsnames.c     |    0 
 .../namespace => kernel/acpi/acpica}/nsobject.c    |    0 
 .../namespace => kernel/acpi/acpica}/nsparse.c     |    0 
 .../namespace => kernel/acpi/acpica}/nspredef.c    |    0 
 .../namespace => kernel/acpi/acpica}/nssearch.c    |    0 
 .../namespace => kernel/acpi/acpica}/nsutils.c     |    0 
 .../acpi/namespace => kernel/acpi/acpica}/nswalk.c |    0 
 .../namespace => kernel/acpi/acpica}/nsxfeval.c    |    0 
 .../namespace => kernel/acpi/acpica}/nsxfname.c    |    0 
 .../namespace => kernel/acpi/acpica}/nsxfobj.c     |    0 
 .../acpi/parser => kernel/acpi/acpica}/psargs.c    |    0 
 .../acpi/parser => kernel/acpi/acpica}/psloop.c    |    0 
 .../acpi/parser => kernel/acpi/acpica}/psopcode.c  |    0 
 .../acpi/parser => kernel/acpi/acpica}/psparse.c   |    0 
 .../acpi/parser => kernel/acpi/acpica}/psscope.c   |    0 
 .../acpi/parser => kernel/acpi/acpica}/pstree.c    |    0 
 .../acpi/parser => kernel/acpi/acpica}/psutils.c   |    0 
 .../acpi/parser => kernel/acpi/acpica}/pswalk.c    |    0 
 .../acpi/parser => kernel/acpi/acpica}/psxface.c   |    0 
 .../acpi/resources => kernel/acpi/acpica}/rsaddr.c |    0 
 .../acpi/resources => kernel/acpi/acpica}/rscalc.c |    0 
 .../resources => kernel/acpi/acpica}/rscreate.c    |    0 
 .../acpi/resources => kernel/acpi/acpica}/rsdump.c |    0 
 .../acpi/resources => kernel/acpi/acpica}/rsinfo.c |    0 
 .../acpi/resources => kernel/acpi/acpica}/rsio.c   |    0 
 .../acpi/resources => kernel/acpi/acpica}/rsirq.c  |    0 
 .../acpi/resources => kernel/acpi/acpica}/rslist.c |    0 
 .../resources => kernel/acpi/acpica}/rsmemory.c    |    0 
 .../acpi/resources => kernel/acpi/acpica}/rsmisc.c |    0 
 .../resources => kernel/acpi/acpica}/rsutils.c     |    0 
 .../resources => kernel/acpi/acpica}/rsxface.c     |    0 
 .../acpi/tables => kernel/acpi/acpica}/tbfadt.c    |    0 
 .../acpi/tables => kernel/acpi/acpica}/tbfind.c    |    0 
 .../acpi/tables => kernel/acpi/acpica}/tbinstal.c  |    0 
 .../acpi/tables => kernel/acpi/acpica}/tbutils.c   |    0 
 .../acpi/tables => kernel/acpi/acpica}/tbxface.c   |    0 
 .../acpi/tables => kernel/acpi/acpica}/tbxfroot.c  |    0 
 .../utilities => kernel/acpi/acpica}/utalloc.c     |    0 
 .../utilities => kernel/acpi/acpica}/utcache.c     |    0 
 .../acpi/utilities => kernel/acpi/acpica}/utcopy.c |    0 
 .../utilities => kernel/acpi/acpica}/utdebug.c     |    0 
 .../utilities => kernel/acpi/acpica}/utdelete.c    |    0 
 .../acpi/utilities => kernel/acpi/acpica}/uteval.c |    0 
 .../utilities => kernel/acpi/acpica}/utglobal.c    |    0 
 .../acpi/utilities => kernel/acpi/acpica}/utinit.c |    0 
 .../acpi/utilities => kernel/acpi/acpica}/utmath.c |    0 
 .../acpi/utilities => kernel/acpi/acpica}/utmisc.c |    0 
 .../utilities => kernel/acpi/acpica}/utmutex.c     |    0 
 .../utilities => kernel/acpi/acpica}/utobject.c    |    0 
 .../utilities => kernel/acpi/acpica}/utresrc.c     |    0 
 .../utilities => kernel/acpi/acpica}/utstate.c     |    0 
 .../utilities => kernel/acpi/acpica}/utxface.c     |    0 
 {drivers => kernel}/acpi/bus.c                     |    0 
 {drivers => kernel}/acpi/glue.c                    |    0 
 {drivers/acpi/sleep => kernel/acpi}/main.c         |    0 
 {drivers => kernel}/acpi/osl.c                     |    0 
 {drivers => kernel}/acpi/pci_bind.c                |    0 
 {drivers => kernel}/acpi/pci_irq.c                 |    0 
 {drivers => kernel}/acpi/pci_link.c                |    0 
 {drivers => kernel}/acpi/pci_root.c                |    0 
 {drivers => kernel}/acpi/power.c                   |    0 
 {drivers/acpi/sleep => kernel/acpi}/proc.c         |    0 
 {drivers => kernel}/acpi/reboot.c                  |    0 
 {drivers => kernel}/acpi/scan.c                    |    0 
 {drivers/acpi/sleep => kernel/acpi}/sleep.h        |    0 
 {drivers => kernel}/acpi/tables.c                  |    0 
 {drivers => kernel}/acpi/utils.c                   |    0 
 {drivers/acpi/sleep => kernel/acpi}/wakeup.c       |    0 
 kernel/acpi/x86/Makefile                           |    5 ++
 {drivers/acpi => kernel/acpi/x86}/blacklist.c      |    0 
 141 files changed, 86 insertions(+), 109 deletions(-)
 delete mode 100644 drivers/acpi/dispatcher/Makefile
 delete mode 100644 drivers/acpi/events/Makefile
 delete mode 100644 drivers/acpi/executer/Makefile
 delete mode 100644 drivers/acpi/hardware/Makefile
 delete mode 100644 drivers/acpi/namespace/Makefile
 delete mode 100644 drivers/acpi/parser/Makefile
 delete mode 100644 drivers/acpi/resources/Makefile
 delete mode 100644 drivers/acpi/sleep/Makefile
 delete mode 100644 drivers/acpi/tables/Makefile
 delete mode 100644 drivers/acpi/utilities/Makefile
 create mode 100644 kernel/acpi/Makefile
 create mode 100644 kernel/acpi/acpica/Makefile
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dsfield.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dsinit.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dsmethod.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dsmthdat.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dsobject.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dsopcode.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dsutils.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dswexec.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dswload.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dswscope.c (100%)
 rename {drivers/acpi/dispatcher => kernel/acpi/acpica}/dswstate.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evevent.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evgpe.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evgpeblk.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evmisc.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evregion.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evrgnini.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evsci.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evxface.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evxfevnt.c (100%)
 rename {drivers/acpi/events => kernel/acpi/acpica}/evxfregn.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exconfig.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exconvrt.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/excreate.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exdump.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exfield.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exfldio.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exmisc.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exmutex.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exnames.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exoparg1.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exoparg2.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exoparg3.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exoparg6.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exprep.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exregion.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exresnte.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exresolv.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exresop.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exstore.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exstoren.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exstorob.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exsystem.c (100%)
 rename {drivers/acpi/executer => kernel/acpi/acpica}/exutils.c (100%)
 rename {drivers/acpi/hardware => kernel/acpi/acpica}/hwacpi.c (100%)
 rename {drivers/acpi/hardware => kernel/acpi/acpica}/hwgpe.c (100%)
 rename {drivers/acpi/hardware => kernel/acpi/acpica}/hwregs.c (100%)
 rename {drivers/acpi/hardware => kernel/acpi/acpica}/hwsleep.c (100%)
 rename {drivers/acpi/hardware => kernel/acpi/acpica}/hwtimer.c (100%)
 rename {drivers/acpi/hardware => kernel/acpi/acpica}/hwxface.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsaccess.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsalloc.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsdump.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsdumpdv.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nseval.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsinit.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsload.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsnames.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsobject.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsparse.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nspredef.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nssearch.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsutils.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nswalk.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsxfeval.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsxfname.c (100%)
 rename {drivers/acpi/namespace => kernel/acpi/acpica}/nsxfobj.c (100%)
 rename {drivers/acpi/parser => kernel/acpi/acpica}/psargs.c (100%)
 rename {drivers/acpi/parser => kernel/acpi/acpica}/psloop.c (100%)
 rename {drivers/acpi/parser => kernel/acpi/acpica}/psopcode.c (100%)
 rename {drivers/acpi/parser => kernel/acpi/acpica}/psparse.c (100%)
 rename {drivers/acpi/parser => kernel/acpi/acpica}/psscope.c (100%)
 rename {drivers/acpi/parser => kernel/acpi/acpica}/pstree.c (100%)
 rename {drivers/acpi/parser => kernel/acpi/acpica}/psutils.c (100%)
 rename {drivers/acpi/parser => kernel/acpi/acpica}/pswalk.c (100%)
 rename {drivers/acpi/parser => kernel/acpi/acpica}/psxface.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rsaddr.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rscalc.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rscreate.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rsdump.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rsinfo.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rsio.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rsirq.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rslist.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rsmemory.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rsmisc.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rsutils.c (100%)
 rename {drivers/acpi/resources => kernel/acpi/acpica}/rsxface.c (100%)
 rename {drivers/acpi/tables => kernel/acpi/acpica}/tbfadt.c (100%)
 rename {drivers/acpi/tables => kernel/acpi/acpica}/tbfind.c (100%)
 rename {drivers/acpi/tables => kernel/acpi/acpica}/tbinstal.c (100%)
 rename {drivers/acpi/tables => kernel/acpi/acpica}/tbutils.c (100%)
 rename {drivers/acpi/tables => kernel/acpi/acpica}/tbxface.c (100%)
 rename {drivers/acpi/tables => kernel/acpi/acpica}/tbxfroot.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utalloc.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utcache.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utcopy.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utdebug.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utdelete.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/uteval.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utglobal.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utinit.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utmath.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utmisc.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utmutex.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utobject.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utresrc.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utstate.c (100%)
 rename {drivers/acpi/utilities => kernel/acpi/acpica}/utxface.c (100%)
 rename {drivers => kernel}/acpi/bus.c (100%)
 rename {drivers => kernel}/acpi/glue.c (100%)
 rename {drivers/acpi/sleep => kernel/acpi}/main.c (100%)
 rename {drivers => kernel}/acpi/osl.c (100%)
 rename {drivers => kernel}/acpi/pci_bind.c (100%)
 rename {drivers => kernel}/acpi/pci_irq.c (100%)
 rename {drivers => kernel}/acpi/pci_link.c (100%)
 rename {drivers => kernel}/acpi/pci_root.c (100%)
 rename {drivers => kernel}/acpi/power.c (100%)
 rename {drivers/acpi/sleep => kernel/acpi}/proc.c (100%)
 rename {drivers => kernel}/acpi/reboot.c (100%)
 rename {drivers => kernel}/acpi/scan.c (100%)
 rename {drivers/acpi/sleep => kernel/acpi}/sleep.h (100%)
 rename {drivers => kernel}/acpi/tables.c (100%)
 rename {drivers => kernel}/acpi/utils.c (100%)
 rename {drivers/acpi/sleep => kernel/acpi}/wakeup.c (100%)
 create mode 100644 kernel/acpi/x86/Makefile
 rename {drivers/acpi => kernel/acpi/x86}/blacklist.c (100%)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 3c0c933..5f4096d 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -1,5 +1,5 @@
 #
-# Makefile for the Linux ACPI interpreter
+# Makefile for the Linux ACPI Drivers
 #
 
 export ACPI_CFLAGS
@@ -13,21 +13,7 @@ endif
 EXTRA_CFLAGS	+= $(ACPI_CFLAGS)
 
 #
-# ACPI Boot-Time Table Parsing
-#
-obj-y				+= tables.o
-obj-$(CONFIG_X86)		+= blacklist.o
-
-#
-# ACPI Core Subsystem (Interpreter)
-#
-obj-y				+= osl.o utils.o reboot.o\
-				   dispatcher/ events/ executer/ hardware/ \
-				   namespace/ parser/ resources/ tables/ \
-				   utilities/
-
-#
-# ACPI Bus and Device Drivers
+# ACPI Device Drivers
 #
 processor-objs	+= processor_core.o processor_throttling.o \
 				processor_idle.o processor_thermal.o
@@ -35,9 +21,6 @@ ifdef CONFIG_CPU_FREQ
 processor-objs	+= processor_perflib.o
 endif
 
-obj-y				+= sleep/
-obj-y				+= bus.o glue.o
-obj-y				+= scan.o
 # Keep EC driver first. Initialization of others depend on it.
 obj-y				+= ec.o
 obj-$(CONFIG_ACPI_AC) 		+= ac.o
@@ -50,12 +33,10 @@ ifdef CONFIG_ACPI_VIDEO
 obj-y				+= video_detect.o
 endif
 
-obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
 obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-$(CONFIG_ACPI_CONTAINER)	+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
-obj-y				+= power.o
 obj-$(CONFIG_ACPI_SYSTEM)	+= system.o event.o
 obj-$(CONFIG_ACPI_DEBUG)	+= debug.o
 obj-$(CONFIG_ACPI_NUMA)		+= numa.o
diff --git a/drivers/acpi/dispatcher/Makefile b/drivers/acpi/dispatcher/Makefile
deleted file mode 100644
index eb7e602..0000000
--- a/drivers/acpi/dispatcher/Makefile
+++ /dev/null
@@ -1,9 +0,0 @@
-#
-# Makefile for all Linux ACPI interpreter subdirectories
-#
-
-obj-y := dsfield.o   dsmthdat.o  dsopcode.o  dswexec.o  dswscope.o \
-	 dsmethod.o  dsobject.o  dsutils.o   dswload.o  dswstate.o \
-	 dsinit.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/events/Makefile b/drivers/acpi/events/Makefile
deleted file mode 100644
index d29f2ee..0000000
--- a/drivers/acpi/events/Makefile
+++ /dev/null
@@ -1,9 +0,0 @@
-#
-# Makefile for all Linux ACPI interpreter subdirectories
-#
-
-obj-y := evevent.o  evregion.o  evsci.o    evxfevnt.o \
-	 evmisc.o   evrgnini.o  evxface.o  evxfregn.o \
-	 evgpe.o    evgpeblk.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/executer/Makefile b/drivers/acpi/executer/Makefile
deleted file mode 100644
index e09998a..0000000
--- a/drivers/acpi/executer/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-#
-# Makefile for all Linux ACPI interpreter subdirectories
-#
-
-obj-y := exconfig.o  exfield.o  exnames.o   exoparg6.o  exresolv.o  exstorob.o\
-	 exconvrt.o  exfldio.o  exoparg1.o  exprep.o    exresop.o   exsystem.o\
-	 excreate.o  exmisc.o   exoparg2.o  exregion.o  exstore.o   exutils.o \
-	 exdump.o    exmutex.o  exoparg3.o  exresnte.o  exstoren.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/hardware/Makefile b/drivers/acpi/hardware/Makefile
deleted file mode 100644
index 238fbe5..0000000
--- a/drivers/acpi/hardware/Makefile
+++ /dev/null
@@ -1,9 +0,0 @@
-#
-# Makefile for all Linux ACPI interpreter subdirectories
-#
-
-obj-y := hwacpi.o  hwgpe.o  hwregs.o  hwsleep.o hwxface.o
-
-obj-$(ACPI_FUTURE_USAGE) += hwtimer.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/namespace/Makefile b/drivers/acpi/namespace/Makefile
deleted file mode 100644
index 371a2da..0000000
--- a/drivers/acpi/namespace/Makefile
+++ /dev/null
@@ -1,12 +0,0 @@
-#
-# Makefile for all Linux ACPI interpreter subdirectories
-#
-
-obj-y := nsaccess.o  nsload.o    nssearch.o  nsxfeval.o \
-	 nsalloc.o   nseval.o    nsnames.o   nsutils.o   nsxfname.o \
-	 nsdump.o    nsinit.o    nsobject.o  nswalk.o    nsxfobj.o  \
-	 nsparse.o   nspredef.o
-
-obj-$(ACPI_FUTURE_USAGE) += nsdumpdv.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/parser/Makefile b/drivers/acpi/parser/Makefile
deleted file mode 100644
index db24ee0..0000000
--- a/drivers/acpi/parser/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-#
-# Makefile for all Linux ACPI interpreter subdirectories
-#
-
-obj-y := psargs.o    psparse.o  psloop.o pstree.o   pswalk.o  \
-	 psopcode.o  psscope.o  psutils.o  psxface.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/resources/Makefile b/drivers/acpi/resources/Makefile
deleted file mode 100644
index 8de4f69..0000000
--- a/drivers/acpi/resources/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-#
-# Makefile for all Linux ACPI interpreter subdirectories
-#
-
-obj-y := rsaddr.o rscreate.o rsinfo.o rsio.o rslist.o rsmisc.o rsxface.o \
-	 rscalc.o  rsirq.o  rsmemory.o  rsutils.o
-
-obj-$(ACPI_FUTURE_USAGE) += rsdump.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/sleep/Makefile b/drivers/acpi/sleep/Makefile
deleted file mode 100644
index f1fb888..0000000
--- a/drivers/acpi/sleep/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-obj-y					:= wakeup.o
-obj-y					+= main.o
-obj-$(CONFIG_ACPI_SLEEP)		+= proc.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/tables/Makefile b/drivers/acpi/tables/Makefile
deleted file mode 100644
index 7385efa..0000000
--- a/drivers/acpi/tables/Makefile
+++ /dev/null
@@ -1,7 +0,0 @@
-#
-# Makefile for all Linux ACPI interpreter subdirectories
-#
-
-obj-y := tbxface.o tbinstal.o tbutils.o tbfind.o tbfadt.o tbxfroot.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/utilities/Makefile b/drivers/acpi/utilities/Makefile
deleted file mode 100644
index 88eff14..0000000
--- a/drivers/acpi/utilities/Makefile
+++ /dev/null
@@ -1,9 +0,0 @@
-#
-# Makefile for all Linux ACPI interpreter subdirectories
-#
-
-obj-y := utalloc.o utdebug.o uteval.o utinit.o utmisc.o utxface.o \
-		utcopy.o utdelete.o utglobal.o utmath.o utobject.o \
-		utstate.o utmutex.o utobject.o utcache.o utresrc.o
-
-EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/kernel/Makefile b/kernel/Makefile
index 19fad00..adc327c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
+obj-$(CONFIG_ACPI) += acpi/
 obj-$(CONFIG_PM) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
diff --git a/kernel/acpi/Makefile b/kernel/acpi/Makefile
new file mode 100644
index 0000000..92a1f94
--- /dev/null
+++ b/kernel/acpi/Makefile
@@ -0,0 +1,26 @@
+#
+# Makefile for the Linux/ACPI
+#
+
+export ACPI_CFLAGS
+
+ACPI_CFLAGS	:= -Os
+
+ifdef CONFIG_ACPI_DEBUG
+  ACPI_CFLAGS	+= -DACPI_DEBUG_OUTPUT
+endif
+
+EXTRA_CFLAGS	+= $(ACPI_CFLAGS)
+
+obj-y				:= tables.o
+obj-$(CONFIG_X86)		+= x86/
+obj-y				+= osl.o utils.o reboot.o
+obj-y				+= bus.o glue.o
+obj-y				+= scan.o
+obj-y				+= pci_root.o pci_link.o pci_irq.o pci_bind.o
+obj-y				+= power.o
+obj-y  				+= wakeup.o
+obj-y  				+= main.o
+obj-$(CONFIG_ACPI_SLEEP)                += proc.o
+
+obj-y				+= acpica/
diff --git a/kernel/acpi/acpica/Makefile b/kernel/acpi/acpica/Makefile
new file mode 100644
index 0000000..8d4e018
--- /dev/null
+++ b/kernel/acpi/acpica/Makefile
@@ -0,0 +1,52 @@
+#
+# Makefile for ACPICA Core interpreter
+#
+
+export ACPI_CFLAGS
+
+ACPI_CFLAGS	:= -Os
+
+ifdef CONFIG_ACPI_DEBUG
+  ACPI_CFLAGS	+= -DACPI_DEBUG_OUTPUT
+endif
+
+EXTRA_CFLAGS	+= $(ACPI_CFLAGS)
+
+
+obj-y := dsfield.o   dsmthdat.o  dsopcode.o  dswexec.o  dswscope.o \
+	 dsmethod.o  dsobject.o  dsutils.o   dswload.o  dswstate.o \
+	 dsinit.o
+
+obj-y += evevent.o  evregion.o  evsci.o    evxfevnt.o \
+	 evmisc.o   evrgnini.o  evxface.o  evxfregn.o \
+	 evgpe.o    evgpeblk.o
+
+obj-y += exconfig.o  exfield.o  exnames.o   exoparg6.o  exresolv.o  exstorob.o\
+	 exconvrt.o  exfldio.o  exoparg1.o  exprep.o    exresop.o   exsystem.o\
+	 excreate.o  exmisc.o   exoparg2.o  exregion.o  exstore.o   exutils.o \
+	 exdump.o    exmutex.o  exoparg3.o  exresnte.o  exstoren.o
+
+obj-y += hwacpi.o  hwgpe.o  hwregs.o  hwsleep.o hwxface.o
+
+obj-$(ACPI_FUTURE_USAGE) += hwtimer.o
+
+obj-y += nsaccess.o  nsload.o    nssearch.o  nsxfeval.o \
+	 nsalloc.o   nseval.o    nsnames.o   nsutils.o   nsxfname.o \
+	 nsdump.o    nsinit.o    nsobject.o  nswalk.o    nsxfobj.o  \
+	 nsparse.o   nspredef.o
+
+obj-$(ACPI_FUTURE_USAGE) += nsdumpdv.o
+
+obj-y += psargs.o    psparse.o  psloop.o pstree.o   pswalk.o  \
+	 psopcode.o  psscope.o  psutils.o  psxface.o
+
+obj-y += rsaddr.o rscreate.o rsinfo.o rsio.o rslist.o rsmisc.o rsxface.o \
+	 rscalc.o  rsirq.o  rsmemory.o  rsutils.o
+
+obj-$(ACPI_FUTURE_USAGE) += rsdump.o
+
+obj-y += tbxface.o tbinstal.o tbutils.o tbfind.o tbfadt.o tbxfroot.o
+
+obj-y += utalloc.o utdebug.o uteval.o utinit.o utmisc.o utxface.o \
+		utcopy.o utdelete.o utglobal.o utmath.o utobject.o \
+		utstate.o utmutex.o utobject.o utcache.o utresrc.o
diff --git a/drivers/acpi/dispatcher/dsfield.c b/kernel/acpi/acpica/dsfield.c
similarity index 100%
rename from drivers/acpi/dispatcher/dsfield.c
rename to kernel/acpi/acpica/dsfield.c
diff --git a/drivers/acpi/dispatcher/dsinit.c b/kernel/acpi/acpica/dsinit.c
similarity index 100%
rename from drivers/acpi/dispatcher/dsinit.c
rename to kernel/acpi/acpica/dsinit.c
diff --git a/drivers/acpi/dispatcher/dsmethod.c b/kernel/acpi/acpica/dsmethod.c
similarity index 100%
rename from drivers/acpi/dispatcher/dsmethod.c
rename to kernel/acpi/acpica/dsmethod.c
diff --git a/drivers/acpi/dispatcher/dsmthdat.c b/kernel/acpi/acpica/dsmthdat.c
similarity index 100%
rename from drivers/acpi/dispatcher/dsmthdat.c
rename to kernel/acpi/acpica/dsmthdat.c
diff --git a/drivers/acpi/dispatcher/dsobject.c b/kernel/acpi/acpica/dsobject.c
similarity index 100%
rename from drivers/acpi/dispatcher/dsobject.c
rename to kernel/acpi/acpica/dsobject.c
diff --git a/drivers/acpi/dispatcher/dsopcode.c b/kernel/acpi/acpica/dsopcode.c
similarity index 100%
rename from drivers/acpi/dispatcher/dsopcode.c
rename to kernel/acpi/acpica/dsopcode.c
diff --git a/drivers/acpi/dispatcher/dsutils.c b/kernel/acpi/acpica/dsutils.c
similarity index 100%
rename from drivers/acpi/dispatcher/dsutils.c
rename to kernel/acpi/acpica/dsutils.c
diff --git a/drivers/acpi/dispatcher/dswexec.c b/kernel/acpi/acpica/dswexec.c
similarity index 100%
rename from drivers/acpi/dispatcher/dswexec.c
rename to kernel/acpi/acpica/dswexec.c
diff --git a/drivers/acpi/dispatcher/dswload.c b/kernel/acpi/acpica/dswload.c
similarity index 100%
rename from drivers/acpi/dispatcher/dswload.c
rename to kernel/acpi/acpica/dswload.c
diff --git a/drivers/acpi/dispatcher/dswscope.c b/kernel/acpi/acpica/dswscope.c
similarity index 100%
rename from drivers/acpi/dispatcher/dswscope.c
rename to kernel/acpi/acpica/dswscope.c
diff --git a/drivers/acpi/dispatcher/dswstate.c b/kernel/acpi/acpica/dswstate.c
similarity index 100%
rename from drivers/acpi/dispatcher/dswstate.c
rename to kernel/acpi/acpica/dswstate.c
diff --git a/drivers/acpi/events/evevent.c b/kernel/acpi/acpica/evevent.c
similarity index 100%
rename from drivers/acpi/events/evevent.c
rename to kernel/acpi/acpica/evevent.c
diff --git a/drivers/acpi/events/evgpe.c b/kernel/acpi/acpica/evgpe.c
similarity index 100%
rename from drivers/acpi/events/evgpe.c
rename to kernel/acpi/acpica/evgpe.c
diff --git a/drivers/acpi/events/evgpeblk.c b/kernel/acpi/acpica/evgpeblk.c
similarity index 100%
rename from drivers/acpi/events/evgpeblk.c
rename to kernel/acpi/acpica/evgpeblk.c
diff --git a/drivers/acpi/events/evmisc.c b/kernel/acpi/acpica/evmisc.c
similarity index 100%
rename from drivers/acpi/events/evmisc.c
rename to kernel/acpi/acpica/evmisc.c
diff --git a/drivers/acpi/events/evregion.c b/kernel/acpi/acpica/evregion.c
similarity index 100%
rename from drivers/acpi/events/evregion.c
rename to kernel/acpi/acpica/evregion.c
diff --git a/drivers/acpi/events/evrgnini.c b/kernel/acpi/acpica/evrgnini.c
similarity index 100%
rename from drivers/acpi/events/evrgnini.c
rename to kernel/acpi/acpica/evrgnini.c
diff --git a/drivers/acpi/events/evsci.c b/kernel/acpi/acpica/evsci.c
similarity index 100%
rename from drivers/acpi/events/evsci.c
rename to kernel/acpi/acpica/evsci.c
diff --git a/drivers/acpi/events/evxface.c b/kernel/acpi/acpica/evxface.c
similarity index 100%
rename from drivers/acpi/events/evxface.c
rename to kernel/acpi/acpica/evxface.c
diff --git a/drivers/acpi/events/evxfevnt.c b/kernel/acpi/acpica/evxfevnt.c
similarity index 100%
rename from drivers/acpi/events/evxfevnt.c
rename to kernel/acpi/acpica/evxfevnt.c
diff --git a/drivers/acpi/events/evxfregn.c b/kernel/acpi/acpica/evxfregn.c
similarity index 100%
rename from drivers/acpi/events/evxfregn.c
rename to kernel/acpi/acpica/evxfregn.c
diff --git a/drivers/acpi/executer/exconfig.c b/kernel/acpi/acpica/exconfig.c
similarity index 100%
rename from drivers/acpi/executer/exconfig.c
rename to kernel/acpi/acpica/exconfig.c
diff --git a/drivers/acpi/executer/exconvrt.c b/kernel/acpi/acpica/exconvrt.c
similarity index 100%
rename from drivers/acpi/executer/exconvrt.c
rename to kernel/acpi/acpica/exconvrt.c
diff --git a/drivers/acpi/executer/excreate.c b/kernel/acpi/acpica/excreate.c
similarity index 100%
rename from drivers/acpi/executer/excreate.c
rename to kernel/acpi/acpica/excreate.c
diff --git a/drivers/acpi/executer/exdump.c b/kernel/acpi/acpica/exdump.c
similarity index 100%
rename from drivers/acpi/executer/exdump.c
rename to kernel/acpi/acpica/exdump.c
diff --git a/drivers/acpi/executer/exfield.c b/kernel/acpi/acpica/exfield.c
similarity index 100%
rename from drivers/acpi/executer/exfield.c
rename to kernel/acpi/acpica/exfield.c
diff --git a/drivers/acpi/executer/exfldio.c b/kernel/acpi/acpica/exfldio.c
similarity index 100%
rename from drivers/acpi/executer/exfldio.c
rename to kernel/acpi/acpica/exfldio.c
diff --git a/drivers/acpi/executer/exmisc.c b/kernel/acpi/acpica/exmisc.c
similarity index 100%
rename from drivers/acpi/executer/exmisc.c
rename to kernel/acpi/acpica/exmisc.c
diff --git a/drivers/acpi/executer/exmutex.c b/kernel/acpi/acpica/exmutex.c
similarity index 100%
rename from drivers/acpi/executer/exmutex.c
rename to kernel/acpi/acpica/exmutex.c
diff --git a/drivers/acpi/executer/exnames.c b/kernel/acpi/acpica/exnames.c
similarity index 100%
rename from drivers/acpi/executer/exnames.c
rename to kernel/acpi/acpica/exnames.c
diff --git a/drivers/acpi/executer/exoparg1.c b/kernel/acpi/acpica/exoparg1.c
similarity index 100%
rename from drivers/acpi/executer/exoparg1.c
rename to kernel/acpi/acpica/exoparg1.c
diff --git a/drivers/acpi/executer/exoparg2.c b/kernel/acpi/acpica/exoparg2.c
similarity index 100%
rename from drivers/acpi/executer/exoparg2.c
rename to kernel/acpi/acpica/exoparg2.c
diff --git a/drivers/acpi/executer/exoparg3.c b/kernel/acpi/acpica/exoparg3.c
similarity index 100%
rename from drivers/acpi/executer/exoparg3.c
rename to kernel/acpi/acpica/exoparg3.c
diff --git a/drivers/acpi/executer/exoparg6.c b/kernel/acpi/acpica/exoparg6.c
similarity index 100%
rename from drivers/acpi/executer/exoparg6.c
rename to kernel/acpi/acpica/exoparg6.c
diff --git a/drivers/acpi/executer/exprep.c b/kernel/acpi/acpica/exprep.c
similarity index 100%
rename from drivers/acpi/executer/exprep.c
rename to kernel/acpi/acpica/exprep.c
diff --git a/drivers/acpi/executer/exregion.c b/kernel/acpi/acpica/exregion.c
similarity index 100%
rename from drivers/acpi/executer/exregion.c
rename to kernel/acpi/acpica/exregion.c
diff --git a/drivers/acpi/executer/exresnte.c b/kernel/acpi/acpica/exresnte.c
similarity index 100%
rename from drivers/acpi/executer/exresnte.c
rename to kernel/acpi/acpica/exresnte.c
diff --git a/drivers/acpi/executer/exresolv.c b/kernel/acpi/acpica/exresolv.c
similarity index 100%
rename from drivers/acpi/executer/exresolv.c
rename to kernel/acpi/acpica/exresolv.c
diff --git a/drivers/acpi/executer/exresop.c b/kernel/acpi/acpica/exresop.c
similarity index 100%
rename from drivers/acpi/executer/exresop.c
rename to kernel/acpi/acpica/exresop.c
diff --git a/drivers/acpi/executer/exstore.c b/kernel/acpi/acpica/exstore.c
similarity index 100%
rename from drivers/acpi/executer/exstore.c
rename to kernel/acpi/acpica/exstore.c
diff --git a/drivers/acpi/executer/exstoren.c b/kernel/acpi/acpica/exstoren.c
similarity index 100%
rename from drivers/acpi/executer/exstoren.c
rename to kernel/acpi/acpica/exstoren.c
diff --git a/drivers/acpi/executer/exstorob.c b/kernel/acpi/acpica/exstorob.c
similarity index 100%
rename from drivers/acpi/executer/exstorob.c
rename to kernel/acpi/acpica/exstorob.c
diff --git a/drivers/acpi/executer/exsystem.c b/kernel/acpi/acpica/exsystem.c
similarity index 100%
rename from drivers/acpi/executer/exsystem.c
rename to kernel/acpi/acpica/exsystem.c
diff --git a/drivers/acpi/executer/exutils.c b/kernel/acpi/acpica/exutils.c
similarity index 100%
rename from drivers/acpi/executer/exutils.c
rename to kernel/acpi/acpica/exutils.c
diff --git a/drivers/acpi/hardware/hwacpi.c b/kernel/acpi/acpica/hwacpi.c
similarity index 100%
rename from drivers/acpi/hardware/hwacpi.c
rename to kernel/acpi/acpica/hwacpi.c
diff --git a/drivers/acpi/hardware/hwgpe.c b/kernel/acpi/acpica/hwgpe.c
similarity index 100%
rename from drivers/acpi/hardware/hwgpe.c
rename to kernel/acpi/acpica/hwgpe.c
diff --git a/drivers/acpi/hardware/hwregs.c b/kernel/acpi/acpica/hwregs.c
similarity index 100%
rename from drivers/acpi/hardware/hwregs.c
rename to kernel/acpi/acpica/hwregs.c
diff --git a/drivers/acpi/hardware/hwsleep.c b/kernel/acpi/acpica/hwsleep.c
similarity index 100%
rename from drivers/acpi/hardware/hwsleep.c
rename to kernel/acpi/acpica/hwsleep.c
diff --git a/drivers/acpi/hardware/hwtimer.c b/kernel/acpi/acpica/hwtimer.c
similarity index 100%
rename from drivers/acpi/hardware/hwtimer.c
rename to kernel/acpi/acpica/hwtimer.c
diff --git a/drivers/acpi/hardware/hwxface.c b/kernel/acpi/acpica/hwxface.c
similarity index 100%
rename from drivers/acpi/hardware/hwxface.c
rename to kernel/acpi/acpica/hwxface.c
diff --git a/drivers/acpi/namespace/nsaccess.c b/kernel/acpi/acpica/nsaccess.c
similarity index 100%
rename from drivers/acpi/namespace/nsaccess.c
rename to kernel/acpi/acpica/nsaccess.c
diff --git a/drivers/acpi/namespace/nsalloc.c b/kernel/acpi/acpica/nsalloc.c
similarity index 100%
rename from drivers/acpi/namespace/nsalloc.c
rename to kernel/acpi/acpica/nsalloc.c
diff --git a/drivers/acpi/namespace/nsdump.c b/kernel/acpi/acpica/nsdump.c
similarity index 100%
rename from drivers/acpi/namespace/nsdump.c
rename to kernel/acpi/acpica/nsdump.c
diff --git a/drivers/acpi/namespace/nsdumpdv.c b/kernel/acpi/acpica/nsdumpdv.c
similarity index 100%
rename from drivers/acpi/namespace/nsdumpdv.c
rename to kernel/acpi/acpica/nsdumpdv.c
diff --git a/drivers/acpi/namespace/nseval.c b/kernel/acpi/acpica/nseval.c
similarity index 100%
rename from drivers/acpi/namespace/nseval.c
rename to kernel/acpi/acpica/nseval.c
diff --git a/drivers/acpi/namespace/nsinit.c b/kernel/acpi/acpica/nsinit.c
similarity index 100%
rename from drivers/acpi/namespace/nsinit.c
rename to kernel/acpi/acpica/nsinit.c
diff --git a/drivers/acpi/namespace/nsload.c b/kernel/acpi/acpica/nsload.c
similarity index 100%
rename from drivers/acpi/namespace/nsload.c
rename to kernel/acpi/acpica/nsload.c
diff --git a/drivers/acpi/namespace/nsnames.c b/kernel/acpi/acpica/nsnames.c
similarity index 100%
rename from drivers/acpi/namespace/nsnames.c
rename to kernel/acpi/acpica/nsnames.c
diff --git a/drivers/acpi/namespace/nsobject.c b/kernel/acpi/acpica/nsobject.c
similarity index 100%
rename from drivers/acpi/namespace/nsobject.c
rename to kernel/acpi/acpica/nsobject.c
diff --git a/drivers/acpi/namespace/nsparse.c b/kernel/acpi/acpica/nsparse.c
similarity index 100%
rename from drivers/acpi/namespace/nsparse.c
rename to kernel/acpi/acpica/nsparse.c
diff --git a/drivers/acpi/namespace/nspredef.c b/kernel/acpi/acpica/nspredef.c
similarity index 100%
rename from drivers/acpi/namespace/nspredef.c
rename to kernel/acpi/acpica/nspredef.c
diff --git a/drivers/acpi/namespace/nssearch.c b/kernel/acpi/acpica/nssearch.c
similarity index 100%
rename from drivers/acpi/namespace/nssearch.c
rename to kernel/acpi/acpica/nssearch.c
diff --git a/drivers/acpi/namespace/nsutils.c b/kernel/acpi/acpica/nsutils.c
similarity index 100%
rename from drivers/acpi/namespace/nsutils.c
rename to kernel/acpi/acpica/nsutils.c
diff --git a/drivers/acpi/namespace/nswalk.c b/kernel/acpi/acpica/nswalk.c
similarity index 100%
rename from drivers/acpi/namespace/nswalk.c
rename to kernel/acpi/acpica/nswalk.c
diff --git a/drivers/acpi/namespace/nsxfeval.c b/kernel/acpi/acpica/nsxfeval.c
similarity index 100%
rename from drivers/acpi/namespace/nsxfeval.c
rename to kernel/acpi/acpica/nsxfeval.c
diff --git a/drivers/acpi/namespace/nsxfname.c b/kernel/acpi/acpica/nsxfname.c
similarity index 100%
rename from drivers/acpi/namespace/nsxfname.c
rename to kernel/acpi/acpica/nsxfname.c
diff --git a/drivers/acpi/namespace/nsxfobj.c b/kernel/acpi/acpica/nsxfobj.c
similarity index 100%
rename from drivers/acpi/namespace/nsxfobj.c
rename to kernel/acpi/acpica/nsxfobj.c
diff --git a/drivers/acpi/parser/psargs.c b/kernel/acpi/acpica/psargs.c
similarity index 100%
rename from drivers/acpi/parser/psargs.c
rename to kernel/acpi/acpica/psargs.c
diff --git a/drivers/acpi/parser/psloop.c b/kernel/acpi/acpica/psloop.c
similarity index 100%
rename from drivers/acpi/parser/psloop.c
rename to kernel/acpi/acpica/psloop.c
diff --git a/drivers/acpi/parser/psopcode.c b/kernel/acpi/acpica/psopcode.c
similarity index 100%
rename from drivers/acpi/parser/psopcode.c
rename to kernel/acpi/acpica/psopcode.c
diff --git a/drivers/acpi/parser/psparse.c b/kernel/acpi/acpica/psparse.c
similarity index 100%
rename from drivers/acpi/parser/psparse.c
rename to kernel/acpi/acpica/psparse.c
diff --git a/drivers/acpi/parser/psscope.c b/kernel/acpi/acpica/psscope.c
similarity index 100%
rename from drivers/acpi/parser/psscope.c
rename to kernel/acpi/acpica/psscope.c
diff --git a/drivers/acpi/parser/pstree.c b/kernel/acpi/acpica/pstree.c
similarity index 100%
rename from drivers/acpi/parser/pstree.c
rename to kernel/acpi/acpica/pstree.c
diff --git a/drivers/acpi/parser/psutils.c b/kernel/acpi/acpica/psutils.c
similarity index 100%
rename from drivers/acpi/parser/psutils.c
rename to kernel/acpi/acpica/psutils.c
diff --git a/drivers/acpi/parser/pswalk.c b/kernel/acpi/acpica/pswalk.c
similarity index 100%
rename from drivers/acpi/parser/pswalk.c
rename to kernel/acpi/acpica/pswalk.c
diff --git a/drivers/acpi/parser/psxface.c b/kernel/acpi/acpica/psxface.c
similarity index 100%
rename from drivers/acpi/parser/psxface.c
rename to kernel/acpi/acpica/psxface.c
diff --git a/drivers/acpi/resources/rsaddr.c b/kernel/acpi/acpica/rsaddr.c
similarity index 100%
rename from drivers/acpi/resources/rsaddr.c
rename to kernel/acpi/acpica/rsaddr.c
diff --git a/drivers/acpi/resources/rscalc.c b/kernel/acpi/acpica/rscalc.c
similarity index 100%
rename from drivers/acpi/resources/rscalc.c
rename to kernel/acpi/acpica/rscalc.c
diff --git a/drivers/acpi/resources/rscreate.c b/kernel/acpi/acpica/rscreate.c
similarity index 100%
rename from drivers/acpi/resources/rscreate.c
rename to kernel/acpi/acpica/rscreate.c
diff --git a/drivers/acpi/resources/rsdump.c b/kernel/acpi/acpica/rsdump.c
similarity index 100%
rename from drivers/acpi/resources/rsdump.c
rename to kernel/acpi/acpica/rsdump.c
diff --git a/drivers/acpi/resources/rsinfo.c b/kernel/acpi/acpica/rsinfo.c
similarity index 100%
rename from drivers/acpi/resources/rsinfo.c
rename to kernel/acpi/acpica/rsinfo.c
diff --git a/drivers/acpi/resources/rsio.c b/kernel/acpi/acpica/rsio.c
similarity index 100%
rename from drivers/acpi/resources/rsio.c
rename to kernel/acpi/acpica/rsio.c
diff --git a/drivers/acpi/resources/rsirq.c b/kernel/acpi/acpica/rsirq.c
similarity index 100%
rename from drivers/acpi/resources/rsirq.c
rename to kernel/acpi/acpica/rsirq.c
diff --git a/drivers/acpi/resources/rslist.c b/kernel/acpi/acpica/rslist.c
similarity index 100%
rename from drivers/acpi/resources/rslist.c
rename to kernel/acpi/acpica/rslist.c
diff --git a/drivers/acpi/resources/rsmemory.c b/kernel/acpi/acpica/rsmemory.c
similarity index 100%
rename from drivers/acpi/resources/rsmemory.c
rename to kernel/acpi/acpica/rsmemory.c
diff --git a/drivers/acpi/resources/rsmisc.c b/kernel/acpi/acpica/rsmisc.c
similarity index 100%
rename from drivers/acpi/resources/rsmisc.c
rename to kernel/acpi/acpica/rsmisc.c
diff --git a/drivers/acpi/resources/rsutils.c b/kernel/acpi/acpica/rsutils.c
similarity index 100%
rename from drivers/acpi/resources/rsutils.c
rename to kernel/acpi/acpica/rsutils.c
diff --git a/drivers/acpi/resources/rsxface.c b/kernel/acpi/acpica/rsxface.c
similarity index 100%
rename from drivers/acpi/resources/rsxface.c
rename to kernel/acpi/acpica/rsxface.c
diff --git a/drivers/acpi/tables/tbfadt.c b/kernel/acpi/acpica/tbfadt.c
similarity index 100%
rename from drivers/acpi/tables/tbfadt.c
rename to kernel/acpi/acpica/tbfadt.c
diff --git a/drivers/acpi/tables/tbfind.c b/kernel/acpi/acpica/tbfind.c
similarity index 100%
rename from drivers/acpi/tables/tbfind.c
rename to kernel/acpi/acpica/tbfind.c
diff --git a/drivers/acpi/tables/tbinstal.c b/kernel/acpi/acpica/tbinstal.c
similarity index 100%
rename from drivers/acpi/tables/tbinstal.c
rename to kernel/acpi/acpica/tbinstal.c
diff --git a/drivers/acpi/tables/tbutils.c b/kernel/acpi/acpica/tbutils.c
similarity index 100%
rename from drivers/acpi/tables/tbutils.c
rename to kernel/acpi/acpica/tbutils.c
diff --git a/drivers/acpi/tables/tbxface.c b/kernel/acpi/acpica/tbxface.c
similarity index 100%
rename from drivers/acpi/tables/tbxface.c
rename to kernel/acpi/acpica/tbxface.c
diff --git a/drivers/acpi/tables/tbxfroot.c b/kernel/acpi/acpica/tbxfroot.c
similarity index 100%
rename from drivers/acpi/tables/tbxfroot.c
rename to kernel/acpi/acpica/tbxfroot.c
diff --git a/drivers/acpi/utilities/utalloc.c b/kernel/acpi/acpica/utalloc.c
similarity index 100%
rename from drivers/acpi/utilities/utalloc.c
rename to kernel/acpi/acpica/utalloc.c
diff --git a/drivers/acpi/utilities/utcache.c b/kernel/acpi/acpica/utcache.c
similarity index 100%
rename from drivers/acpi/utilities/utcache.c
rename to kernel/acpi/acpica/utcache.c
diff --git a/drivers/acpi/utilities/utcopy.c b/kernel/acpi/acpica/utcopy.c
similarity index 100%
rename from drivers/acpi/utilities/utcopy.c
rename to kernel/acpi/acpica/utcopy.c
diff --git a/drivers/acpi/utilities/utdebug.c b/kernel/acpi/acpica/utdebug.c
similarity index 100%
rename from drivers/acpi/utilities/utdebug.c
rename to kernel/acpi/acpica/utdebug.c
diff --git a/drivers/acpi/utilities/utdelete.c b/kernel/acpi/acpica/utdelete.c
similarity index 100%
rename from drivers/acpi/utilities/utdelete.c
rename to kernel/acpi/acpica/utdelete.c
diff --git a/drivers/acpi/utilities/uteval.c b/kernel/acpi/acpica/uteval.c
similarity index 100%
rename from drivers/acpi/utilities/uteval.c
rename to kernel/acpi/acpica/uteval.c
diff --git a/drivers/acpi/utilities/utglobal.c b/kernel/acpi/acpica/utglobal.c
similarity index 100%
rename from drivers/acpi/utilities/utglobal.c
rename to kernel/acpi/acpica/utglobal.c
diff --git a/drivers/acpi/utilities/utinit.c b/kernel/acpi/acpica/utinit.c
similarity index 100%
rename from drivers/acpi/utilities/utinit.c
rename to kernel/acpi/acpica/utinit.c
diff --git a/drivers/acpi/utilities/utmath.c b/kernel/acpi/acpica/utmath.c
similarity index 100%
rename from drivers/acpi/utilities/utmath.c
rename to kernel/acpi/acpica/utmath.c
diff --git a/drivers/acpi/utilities/utmisc.c b/kernel/acpi/acpica/utmisc.c
similarity index 100%
rename from drivers/acpi/utilities/utmisc.c
rename to kernel/acpi/acpica/utmisc.c
diff --git a/drivers/acpi/utilities/utmutex.c b/kernel/acpi/acpica/utmutex.c
similarity index 100%
rename from drivers/acpi/utilities/utmutex.c
rename to kernel/acpi/acpica/utmutex.c
diff --git a/drivers/acpi/utilities/utobject.c b/kernel/acpi/acpica/utobject.c
similarity index 100%
rename from drivers/acpi/utilities/utobject.c
rename to kernel/acpi/acpica/utobject.c
diff --git a/drivers/acpi/utilities/utresrc.c b/kernel/acpi/acpica/utresrc.c
similarity index 100%
rename from drivers/acpi/utilities/utresrc.c
rename to kernel/acpi/acpica/utresrc.c
diff --git a/drivers/acpi/utilities/utstate.c b/kernel/acpi/acpica/utstate.c
similarity index 100%
rename from drivers/acpi/utilities/utstate.c
rename to kernel/acpi/acpica/utstate.c
diff --git a/drivers/acpi/utilities/utxface.c b/kernel/acpi/acpica/utxface.c
similarity index 100%
rename from drivers/acpi/utilities/utxface.c
rename to kernel/acpi/acpica/utxface.c
diff --git a/drivers/acpi/bus.c b/kernel/acpi/bus.c
similarity index 100%
rename from drivers/acpi/bus.c
rename to kernel/acpi/bus.c
diff --git a/drivers/acpi/glue.c b/kernel/acpi/glue.c
similarity index 100%
rename from drivers/acpi/glue.c
rename to kernel/acpi/glue.c
diff --git a/drivers/acpi/sleep/main.c b/kernel/acpi/main.c
similarity index 100%
rename from drivers/acpi/sleep/main.c
rename to kernel/acpi/main.c
diff --git a/drivers/acpi/osl.c b/kernel/acpi/osl.c
similarity index 100%
rename from drivers/acpi/osl.c
rename to kernel/acpi/osl.c
diff --git a/drivers/acpi/pci_bind.c b/kernel/acpi/pci_bind.c
similarity index 100%
rename from drivers/acpi/pci_bind.c
rename to kernel/acpi/pci_bind.c
diff --git a/drivers/acpi/pci_irq.c b/kernel/acpi/pci_irq.c
similarity index 100%
rename from drivers/acpi/pci_irq.c
rename to kernel/acpi/pci_irq.c
diff --git a/drivers/acpi/pci_link.c b/kernel/acpi/pci_link.c
similarity index 100%
rename from drivers/acpi/pci_link.c
rename to kernel/acpi/pci_link.c
diff --git a/drivers/acpi/pci_root.c b/kernel/acpi/pci_root.c
similarity index 100%
rename from drivers/acpi/pci_root.c
rename to kernel/acpi/pci_root.c
diff --git a/drivers/acpi/power.c b/kernel/acpi/power.c
similarity index 100%
rename from drivers/acpi/power.c
rename to kernel/acpi/power.c
diff --git a/drivers/acpi/sleep/proc.c b/kernel/acpi/proc.c
similarity index 100%
rename from drivers/acpi/sleep/proc.c
rename to kernel/acpi/proc.c
diff --git a/drivers/acpi/reboot.c b/kernel/acpi/reboot.c
similarity index 100%
rename from drivers/acpi/reboot.c
rename to kernel/acpi/reboot.c
diff --git a/drivers/acpi/scan.c b/kernel/acpi/scan.c
similarity index 100%
rename from drivers/acpi/scan.c
rename to kernel/acpi/scan.c
diff --git a/drivers/acpi/sleep/sleep.h b/kernel/acpi/sleep.h
similarity index 100%
rename from drivers/acpi/sleep/sleep.h
rename to kernel/acpi/sleep.h
diff --git a/drivers/acpi/tables.c b/kernel/acpi/tables.c
similarity index 100%
rename from drivers/acpi/tables.c
rename to kernel/acpi/tables.c
diff --git a/drivers/acpi/utils.c b/kernel/acpi/utils.c
similarity index 100%
rename from drivers/acpi/utils.c
rename to kernel/acpi/utils.c
diff --git a/drivers/acpi/sleep/wakeup.c b/kernel/acpi/wakeup.c
similarity index 100%
rename from drivers/acpi/sleep/wakeup.c
rename to kernel/acpi/wakeup.c
diff --git a/kernel/acpi/x86/Makefile b/kernel/acpi/x86/Makefile
new file mode 100644
index 0000000..cc3f387
--- /dev/null
+++ b/kernel/acpi/x86/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the Linux/ACPI x86 specific files
+#
+
+obj-y		+= blacklist.o
diff --git a/drivers/acpi/blacklist.c b/kernel/acpi/x86/blacklist.c
similarity index 100%
rename from drivers/acpi/blacklist.c
rename to kernel/acpi/x86/blacklist.c
-- 
1.5.6.6

