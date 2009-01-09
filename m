Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZAIK4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZAIK4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZAIK4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:56:17 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:33391 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZAIK4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:56:11 -0500
Date: Fri, 09 Jan 2009 05:55:59 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: [git pull] ACPI & Suspend patches for 2.6.29-rc0
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Message-id: <alpine.LFD.2.00.0901090550590.4091@localhost.localdomain>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_xn4GNqut7BHxcMNp+Oe45Q)"
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_xn4GNqut7BHxcMNp+Oe45Q)
Content-type: TEXT/PLAIN; charset=ISO-8859-7
Content-transfer-encoding: 8BIT

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Creates drivers/platform/x86/ for the laptop drivers etc.
Suspend patch series from Rafael.
Cleanup some of the ACPI PCI Interrupt code from Bjorn.
Sync Linux with ACPICA 20081204 from Bob and Lin-Ming.
Moves private ACPICA headers into acpi/acpica/ directory.
Couple of bug fixes -- more to come.

This will update the files shown below.

thanks!
Len Brown
Intel Open Source Technology Center

ps. git diff is confused about hwregs.c vs hwxface.c below
        both got moved.  I'm running git version 1.6.1.76.gc123b,
	and I use "git diff -M --stat --summary linus..$RELEASE"


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.28/acpi-release-20081204-2.6.28.diff.gz

 Documentation/kernel-parameters.txt                |   46 +-
 arch/ia64/include/asm/acpi-ext.h                   |    1 -
 arch/ia64/include/asm/sn/acpi.h                    |    2 -
 arch/ia64/kernel/acpi.c                            |    1 +
 arch/ia64/sn/kernel/io_acpi_init.c                 |  103 ++--
 arch/ia64/sn/kernel/io_common.c                    |    5 +-
 arch/x86/kernel/acpi/boot.c                        |   17 +-
 arch/x86/kernel/acpi/cstate.c                      |    4 +-
 arch/x86/kernel/acpi/sleep.c                       |    2 +
 arch/x86/kernel/e820.c                             |   21 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/acpi/Kconfig                               |   84 ---
 drivers/acpi/Makefile                              |   25 +-
 drivers/acpi/acpica/Makefile                       |   44 ++
 .../acpi/{parser/pswalk.c => acpica/accommon.h}    |   84 +--
 {include/acpi => drivers/acpi/acpica}/acconfig.h   |    8 +-
 {include/acpi => drivers/acpi/acpica}/acdebug.h    |    0
 {include/acpi => drivers/acpi/acpica}/acdispat.h   |    0
 {include/acpi => drivers/acpi/acpica}/acevents.h   |    6 +-
 {include/acpi => drivers/acpi/acpica}/acglobal.h   |    9 +-
 {include/acpi => drivers/acpi/acpica}/achware.h    |   22 +-
 {include/acpi => drivers/acpi/acpica}/acinterp.h   |    0
 {include/acpi => drivers/acpi/acpica}/aclocal.h    |   86 +--
 {include/acpi => drivers/acpi/acpica}/acmacros.h   |  122 +----
 {include/acpi => drivers/acpi/acpica}/acnamesp.h   |    5 +-
 {include/acpi => drivers/acpi/acpica}/acobject.h   |    0
 {include/acpi => drivers/acpi/acpica}/acopcode.h   |    0
 {include/acpi => drivers/acpi/acpica}/acparser.h   |    0
 {include/acpi => drivers/acpi/acpica}/acpredef.h   |    0
 {include/acpi => drivers/acpi/acpica}/acresrc.h    |    0
 {include/acpi => drivers/acpi/acpica}/acstruct.h   |    0
 {include/acpi => drivers/acpi/acpica}/actables.h   |    2 +
 {include/acpi => drivers/acpi/acpica}/acutils.h    |   36 -
 {include/acpi => drivers/acpi/acpica}/amlcode.h    |    0
 {include/acpi => drivers/acpi/acpica}/amlresrc.h   |    0
 drivers/acpi/{dispatcher => acpica}/dsfield.c      |   11 +-
 drivers/acpi/{dispatcher => acpica}/dsinit.c       |    7 +-
 drivers/acpi/{dispatcher => acpica}/dsmethod.c     |   14 +-
 drivers/acpi/{dispatcher => acpica}/dsmthdat.c     |    7 +-
 drivers/acpi/{dispatcher => acpica}/dsobject.c     |   11 +-
 drivers/acpi/{dispatcher => acpica}/dsopcode.c     |   68 ++-
 drivers/acpi/{dispatcher => acpica}/dsutils.c      |   13 +-
 drivers/acpi/{dispatcher => acpica}/dswexec.c      |   13 +-
 drivers/acpi/{dispatcher => acpica}/dswload.c      |   13 +-
 drivers/acpi/{dispatcher => acpica}/dswscope.c     |    3 +-
 drivers/acpi/{dispatcher => acpica}/dswstate.c     |    7 +-
 drivers/acpi/{events => acpica}/evevent.c          |   17 +-
 drivers/acpi/{events => acpica}/evgpe.c            |   53 +-
 drivers/acpi/{events => acpica}/evgpeblk.c         |   82 ++-
 drivers/acpi/{events => acpica}/evmisc.c           |   62 +-
 drivers/acpi/{events => acpica}/evregion.c         |  140 ++--
 drivers/acpi/{events => acpica}/evrgnini.c         |   46 +-
 drivers/acpi/{events => acpica}/evsci.c            |   13 +-
 drivers/acpi/{events => acpica}/evxface.c          |    9 +-
 drivers/acpi/{events => acpica}/evxfevnt.c         |  170 +++++-
 drivers/acpi/{events => acpica}/evxfregn.c         |    5 +-
 drivers/acpi/{executer => acpica}/exconfig.c       |    9 +-
 drivers/acpi/{executer => acpica}/exconvrt.c       |    5 +-
 drivers/acpi/{executer => acpica}/excreate.c       |    7 +-
 drivers/acpi/{executer => acpica}/exdump.c         |    7 +-
 drivers/acpi/{executer => acpica}/exfield.c        |    5 +-
 drivers/acpi/{executer => acpica}/exfldio.c        |   20 +-
 drivers/acpi/{executer => acpica}/exmisc.c         |    7 +-
 drivers/acpi/{executer => acpica}/exmutex.c        |    5 +-
 drivers/acpi/{executer => acpica}/exnames.c        |    5 +-
 drivers/acpi/{executer => acpica}/exoparg1.c       |   11 +-
 drivers/acpi/{executer => acpica}/exoparg2.c       |    9 +-
 drivers/acpi/{executer => acpica}/exoparg3.c       |    7 +-
 drivers/acpi/{executer => acpica}/exoparg6.c       |    7 +-
 drivers/acpi/{executer => acpica}/exprep.c         |    7 +-
 drivers/acpi/{executer => acpica}/exregion.c       |    3 +-
 drivers/acpi/{executer => acpica}/exresnte.c       |    7 +-
 drivers/acpi/{executer => acpica}/exresolv.c       |    9 +-
 drivers/acpi/{executer => acpica}/exresop.c        |    9 +-
 drivers/acpi/{executer => acpica}/exstore.c        |    9 +-
 drivers/acpi/{executer => acpica}/exstoren.c       |    5 +-
 drivers/acpi/{executer => acpica}/exstorob.c       |    3 +-
 drivers/acpi/{executer => acpica}/exsystem.c       |    3 +-
 drivers/acpi/{executer => acpica}/exutils.c        |    5 +-
 drivers/acpi/{hardware => acpica}/hwacpi.c         |    1 +
 drivers/acpi/{hardware => acpica}/hwgpe.c          |   78 +--
 drivers/acpi/acpica/hwregs.c                       |  353 ++++++++++
 drivers/acpi/{hardware => acpica}/hwsleep.c        |   76 +--
 drivers/acpi/{hardware => acpica}/hwtimer.c        |    1 +
 .../acpi/{hardware/hwregs.c => acpica/hwxface.c}   |  744 +++++++-------------
 drivers/acpi/{namespace => acpica}/nsaccess.c      |   18 +-
 drivers/acpi/{namespace => acpica}/nsalloc.c       |    3 +-
 drivers/acpi/{namespace => acpica}/nsdump.c        |    3 +-
 drivers/acpi/{namespace => acpica}/nsdumpdv.c      |    3 +-
 drivers/acpi/{namespace => acpica}/nseval.c        |   77 +--
 drivers/acpi/{namespace => acpica}/nsinit.c        |    7 +-
 drivers/acpi/{namespace => acpica}/nsload.c        |    7 +-
 drivers/acpi/{namespace => acpica}/nsnames.c       |    5 +-
 drivers/acpi/{namespace => acpica}/nsobject.c      |    3 +-
 drivers/acpi/{namespace => acpica}/nsparse.c       |    9 +-
 drivers/acpi/{namespace => acpica}/nspredef.c      |  261 ++++++--
 drivers/acpi/{namespace => acpica}/nssearch.c      |    3 +-
 drivers/acpi/{namespace => acpica}/nsutils.c       |   15 +-
 drivers/acpi/{namespace => acpica}/nswalk.c        |    3 +-
 drivers/acpi/{namespace => acpica}/nsxfeval.c      |    5 +-
 drivers/acpi/{namespace => acpica}/nsxfname.c      |    3 +-
 drivers/acpi/{namespace => acpica}/nsxfobj.c       |    3 +-
 drivers/acpi/{parser => acpica}/psargs.c           |    9 +-
 drivers/acpi/{parser => acpica}/psloop.c           |    7 +-
 drivers/acpi/{parser => acpica}/psopcode.c         |    7 +-
 drivers/acpi/{parser => acpica}/psparse.c          |   23 +-
 drivers/acpi/{parser => acpica}/psscope.c          |    3 +-
 drivers/acpi/{parser => acpica}/pstree.c           |    5 +-
 drivers/acpi/{parser => acpica}/psutils.c          |    5 +-
 drivers/acpi/{parser => acpica}/pswalk.c           |    3 +-
 drivers/acpi/{parser => acpica}/psxface.c          |   40 +-
 drivers/acpi/{resources => acpica}/rsaddr.c        |    3 +-
 drivers/acpi/{resources => acpica}/rscalc.c        |    5 +-
 drivers/acpi/{resources => acpica}/rscreate.c      |    5 +-
 drivers/acpi/{resources => acpica}/rsdump.c        |    3 +-
 drivers/acpi/{resources => acpica}/rsinfo.c        |    3 +-
 drivers/acpi/{resources => acpica}/rsio.c          |    3 +-
 drivers/acpi/{resources => acpica}/rsirq.c         |    3 +-
 drivers/acpi/{resources => acpica}/rslist.c        |    3 +-
 drivers/acpi/{resources => acpica}/rsmemory.c      |    3 +-
 drivers/acpi/{resources => acpica}/rsmisc.c        |    3 +-
 drivers/acpi/{resources => acpica}/rsutils.c       |    5 +-
 drivers/acpi/{resources => acpica}/rsxface.c       |    5 +-
 drivers/acpi/{tables => acpica}/tbfadt.c           |  252 +++++--
 drivers/acpi/{tables => acpica}/tbfind.c           |    3 +-
 drivers/acpi/{tables => acpica}/tbinstal.c         |    5 +-
 drivers/acpi/{tables => acpica}/tbutils.c          |   30 +-
 drivers/acpi/{tables => acpica}/tbxface.c          |    5 +-
 drivers/acpi/{tables => acpica}/tbxfroot.c         |    3 +-
 drivers/acpi/{utilities => acpica}/utalloc.c       |    3 +-
 drivers/acpi/{utilities => acpica}/utcopy.c        |    3 +-
 drivers/acpi/{utilities => acpica}/utdebug.c       |   95 ++--
 drivers/acpi/{utilities => acpica}/utdelete.c      |    7 +-
 drivers/acpi/{utilities => acpica}/uteval.c        |   11 +-
 drivers/acpi/{utilities => acpica}/utglobal.c      |   12 +-
 drivers/acpi/{utilities => acpica}/utinit.c        |    7 +-
 drivers/acpi/{utilities => acpica}/utmath.c        |    1 +
 drivers/acpi/{utilities => acpica}/utmisc.c        |   23 +-
 drivers/acpi/{utilities => acpica}/utmutex.c       |    1 +
 drivers/acpi/{utilities => acpica}/utobject.c      |    3 +-
 drivers/acpi/{utilities => acpica}/utresrc.c       |    3 +-
 drivers/acpi/{utilities => acpica}/utstate.c       |    1 +
 drivers/acpi/{utilities => acpica}/utxface.c       |   18 +-
 drivers/acpi/battery.c                             |    5 +-
 drivers/acpi/cm_sbs.c                              |    3 -
 drivers/acpi/debug.c                               |    1 -
 drivers/acpi/dispatcher/Makefile                   |    9 -
 drivers/acpi/ec.c                                  |   57 +-
 drivers/acpi/events/Makefile                       |    9 -
 drivers/acpi/executer/Makefile                     |   10 -
 drivers/acpi/hardware/Makefile                     |    9 -
 drivers/acpi/{sleep => }/main.c                    |   79 ++-
 drivers/acpi/namespace/Makefile                    |   12 -
 drivers/acpi/numa.c                                |    1 -
 drivers/acpi/osl.c                                 |    4 +-
 drivers/acpi/parser/Makefile                       |    8 -
 drivers/acpi/pci_bind.c                            |   90 +--
 drivers/acpi/pci_irq.c                             |  472 ++++---------
 drivers/acpi/pci_link.c                            |    6 +-
 drivers/acpi/power.c                               |    6 +-
 drivers/acpi/{sleep => }/proc.c                    |   65 +-
 drivers/acpi/reboot.c                              |    2 +-
 drivers/acpi/resources/Makefile                    |   10 -
 drivers/acpi/sbshc.c                               |    1 -
 drivers/acpi/scan.c                                |    1 -
 drivers/acpi/{sleep => }/sleep.h                   |    0
 drivers/acpi/sleep/Makefile                        |    5 -
 drivers/acpi/system.c                              |   63 +--
 drivers/acpi/tables/Makefile                       |    7 -
 drivers/acpi/utilities/Makefile                    |    9 -
 drivers/acpi/utilities/utcache.c                   |  314 ---------
 drivers/acpi/video.c                               |   20 +
 drivers/acpi/video_detect.c                        |    4 +-
 drivers/acpi/{sleep => }/wakeup.c                  |    6 -
 drivers/ata/libata-acpi.c                          |    6 -
 drivers/ata/pata_acpi.c                            |    6 -
 drivers/char/tpm/tpm_bios.c                        |    2 -
 drivers/cpuidle/governors/menu.c                   |   10 +-
 drivers/ide/ide-acpi.c                             |    6 -
 drivers/misc/Kconfig                               |  284 +--------
 drivers/misc/Makefile                              |   13 -
 drivers/pci/hotplug/acpi_pcihp.c                   |    1 -
 drivers/pci/hotplug/pciehp.h                       |    1 -
 drivers/pci/pci-acpi.c                             |    2 -
 drivers/platform/Kconfig                           |    5 +
 drivers/platform/Makefile                          |    5 +
 drivers/platform/x86/Kconfig                       |  375 ++++++++++
 drivers/platform/x86/Makefile                      |   19 +
 drivers/{misc => platform/x86}/acer-wmi.c          |    0
 drivers/{misc => platform/x86}/asus-laptop.c       |    0
 drivers/{acpi => platform/x86}/asus_acpi.c         |    0
 drivers/{misc => platform/x86}/compal-laptop.c     |    0
 drivers/{misc => platform/x86}/eeepc-laptop.c      |    0
 drivers/{misc => platform/x86}/fujitsu-laptop.c    |  419 ++++++++----
 drivers/{misc => platform/x86}/hp-wmi.c            |    0
 drivers/{misc => platform/x86}/intel_menlow.c      |    0
 drivers/{misc => platform/x86}/msi-laptop.c        |    0
 drivers/{misc => platform/x86}/panasonic-laptop.c  |   22 -
 drivers/{misc => platform/x86}/sony-laptop.c       |   15 +-
 drivers/{misc => platform/x86}/tc1100-wmi.c        |    1 -
 drivers/{misc => platform/x86}/thinkpad_acpi.c     |    1 -
 drivers/{acpi => platform/x86}/toshiba_acpi.c      |    0
 drivers/{acpi => platform/x86}/wmi.c               |    0
 drivers/pnp/pnpacpi/core.c                         |    1 -
 include/acpi/acdisasm.h                            |  445 ------------
 include/acpi/acexcep.h                             |    6 +-
 include/acpi/acoutput.h                            |  103 +++-
 include/acpi/acpi.h                                |   31 +-
 include/acpi/acpiosxf.h                            |   13 +-
 include/acpi/acpixf.h                              |  100 +++-
 include/acpi/acrestyp.h                            |  405 +++++++++++
 include/acpi/actbl.h                               |   25 +
 include/acpi/actbl1.h                              |    2 +-
 include/acpi/actypes.h                             |  557 +++++----------
 include/acpi/platform/acenv.h                      |   45 +-
 include/acpi/platform/aclinux.h                    |    4 +-
 include/linux/acpi.h                               |   17 +-
 include/linux/pci_hotplug.h                        |    1 -
 include/linux/suspend.h                            |   13 +
 kernel/power/disk.c                                |    6 +-
 kernel/power/snapshot.c                            |  370 ++++++-----
 kernel/power/swsusp.c                              |  122 ++++
 223 files changed, 4467 insertions(+), 4259 deletions(-)
 create mode 100644 drivers/acpi/acpica/Makefile
 copy drivers/acpi/{parser/pswalk.c => acpica/accommon.h} (58%)
 rename {include/acpi => drivers/acpi/acpica}/acconfig.h (98%)
 rename {include/acpi => drivers/acpi/acpica}/acdebug.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/acdispat.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/acevents.h (97%)
 rename {include/acpi => drivers/acpi/acpica}/acglobal.h (97%)
 rename {include/acpi => drivers/acpi/acpica}/achware.h (89%)
 rename {include/acpi => drivers/acpi/acpica}/acinterp.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/aclocal.h (95%)
 rename {include/acpi => drivers/acpi/acpica}/acmacros.h (83%)
 rename {include/acpi => drivers/acpi/acpica}/acnamesp.h (98%)
 rename {include/acpi => drivers/acpi/acpica}/acobject.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/acopcode.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/acparser.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/acpredef.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/acresrc.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/acstruct.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/actables.h (98%)
 rename {include/acpi => drivers/acpi/acpica}/acutils.h (93%)
 rename {include/acpi => drivers/acpi/acpica}/amlcode.h (100%)
 rename {include/acpi => drivers/acpi/acpica}/amlresrc.h (100%)
 rename drivers/acpi/{dispatcher => acpica}/dsfield.c (99%)
 rename drivers/acpi/{dispatcher => acpica}/dsinit.c (98%)
 rename drivers/acpi/{dispatcher => acpica}/dsmethod.c (98%)
 rename drivers/acpi/{dispatcher => acpica}/dsmthdat.c (99%)
 rename drivers/acpi/{dispatcher => acpica}/dsobject.c (99%)
 rename drivers/acpi/{dispatcher => acpica}/dsopcode.c (96%)
 rename drivers/acpi/{dispatcher => acpica}/dsutils.c (99%)
 rename drivers/acpi/{dispatcher => acpica}/dswexec.c (99%)
 rename drivers/acpi/{dispatcher => acpica}/dswload.c (99%)
 rename drivers/acpi/{dispatcher => acpica}/dswscope.c (99%)
 rename drivers/acpi/{dispatcher => acpica}/dswstate.c (99%)
 rename drivers/acpi/{events => acpica}/evevent.c (96%)
 rename drivers/acpi/{events => acpica}/evgpe.c (94%)
 rename drivers/acpi/{events => acpica}/evgpeblk.c (94%)
 rename drivers/acpi/{events => acpica}/evmisc.c (93%)
 rename drivers/acpi/{events => acpica}/evregion.c (91%)
 rename drivers/acpi/{events => acpica}/evrgnini.c (95%)
 rename drivers/acpi/{events => acpica}/evsci.c (95%)
 rename drivers/acpi/{events => acpica}/evxface.c (99%)
 rename drivers/acpi/{events => acpica}/evxfevnt.c (81%)
 rename drivers/acpi/{events => acpica}/evxfregn.c (99%)
 rename drivers/acpi/{executer => acpica}/exconfig.c (99%)
 rename drivers/acpi/{executer => acpica}/exconvrt.c (99%)
 rename drivers/acpi/{executer => acpica}/excreate.c (99%)
 rename drivers/acpi/{executer => acpica}/exdump.c (99%)
 rename drivers/acpi/{executer => acpica}/exfield.c (99%)
 rename drivers/acpi/{executer => acpica}/exfldio.c (98%)
 rename drivers/acpi/{executer => acpica}/exmisc.c (99%)
 rename drivers/acpi/{executer => acpica}/exmutex.c (99%)
 rename drivers/acpi/{executer => acpica}/exnames.c (99%)
 rename drivers/acpi/{executer => acpica}/exoparg1.c (99%)
 rename drivers/acpi/{executer => acpica}/exoparg2.c (99%)
 rename drivers/acpi/{executer => acpica}/exoparg3.c (98%)
 rename drivers/acpi/{executer => acpica}/exoparg6.c (99%)
 rename drivers/acpi/{executer => acpica}/exprep.c (99%)
 rename drivers/acpi/{executer => acpica}/exregion.c (99%)
 rename drivers/acpi/{executer => acpica}/exresnte.c (98%)
 rename drivers/acpi/{executer => acpica}/exresolv.c (99%)
 rename drivers/acpi/{executer => acpica}/exresop.c (99%)
 rename drivers/acpi/{executer => acpica}/exstore.c (99%)
 rename drivers/acpi/{executer => acpica}/exstoren.c (99%)
 rename drivers/acpi/{executer => acpica}/exstorob.c (99%)
 rename drivers/acpi/{executer => acpica}/exsystem.c (99%)
 rename drivers/acpi/{executer => acpica}/exutils.c (99%)
 rename drivers/acpi/{hardware => acpica}/hwacpi.c (99%)
 rename drivers/acpi/{hardware => acpica}/hwgpe.c (86%)
 create mode 100644 drivers/acpi/acpica/hwregs.c
 rename drivers/acpi/{hardware => acpica}/hwsleep.c (91%)
 rename drivers/acpi/{hardware => acpica}/hwtimer.c (99%)
 rename drivers/acpi/{hardware/hwregs.c => acpica/hwxface.c} (62%)
 rename drivers/acpi/{namespace => acpica}/nsaccess.c (98%)
 rename drivers/acpi/{namespace => acpica}/nsalloc.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsdump.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsdumpdv.c (99%)
 rename drivers/acpi/{namespace => acpica}/nseval.c (81%)
 rename drivers/acpi/{namespace => acpica}/nsinit.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsload.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsnames.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsobject.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsparse.c (98%)
 rename drivers/acpi/{namespace => acpica}/nspredef.c (76%)
 rename drivers/acpi/{namespace => acpica}/nssearch.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsutils.c (98%)
 rename drivers/acpi/{namespace => acpica}/nswalk.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsxfeval.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsxfname.c (99%)
 rename drivers/acpi/{namespace => acpica}/nsxfobj.c (99%)
 rename drivers/acpi/{parser => acpica}/psargs.c (99%)
 rename drivers/acpi/{parser => acpica}/psloop.c (99%)
 rename drivers/acpi/{parser => acpica}/psopcode.c (99%)
 rename drivers/acpi/{parser => acpica}/psparse.c (97%)
 rename drivers/acpi/{parser => acpica}/psscope.c (99%)
 rename drivers/acpi/{parser => acpica}/pstree.c (99%)
 rename drivers/acpi/{parser => acpica}/psutils.c (99%)
 rename drivers/acpi/{parser => acpica}/pswalk.c (98%)
 rename drivers/acpi/{parser => acpica}/psxface.c (90%)
 rename drivers/acpi/{resources => acpica}/rsaddr.c (99%)
 rename drivers/acpi/{resources => acpica}/rscalc.c (99%)
 rename drivers/acpi/{resources => acpica}/rscreate.c (99%)
 rename drivers/acpi/{resources => acpica}/rsdump.c (99%)
 rename drivers/acpi/{resources => acpica}/rsinfo.c (99%)
 rename drivers/acpi/{resources => acpica}/rsio.c (99%)
 rename drivers/acpi/{resources => acpica}/rsirq.c (99%)
 rename drivers/acpi/{resources => acpica}/rslist.c (99%)
 rename drivers/acpi/{resources => acpica}/rsmemory.c (99%)
 rename drivers/acpi/{resources => acpica}/rsmisc.c (99%)
 rename drivers/acpi/{resources => acpica}/rsutils.c (99%)
 rename drivers/acpi/{resources => acpica}/rsxface.c (99%)
 rename drivers/acpi/{tables => acpica}/tbfadt.c (67%)
 rename drivers/acpi/{tables => acpica}/tbfind.c (99%)
 rename drivers/acpi/{tables => acpica}/tbinstal.c (99%)
 rename drivers/acpi/{tables => acpica}/tbutils.c (95%)
 rename drivers/acpi/{tables => acpica}/tbxface.c (99%)
 rename drivers/acpi/{tables => acpica}/tbxfroot.c (99%)
 rename drivers/acpi/{utilities => acpica}/utalloc.c (99%)
 rename drivers/acpi/{utilities => acpica}/utcopy.c (99%)
 rename drivers/acpi/{utilities => acpica}/utdebug.c (89%)
 rename drivers/acpi/{utilities => acpica}/utdelete.c (99%)
 rename drivers/acpi/{utilities => acpica}/uteval.c (99%)
 rename drivers/acpi/{utilities => acpica}/utglobal.c (99%)
 rename drivers/acpi/{utilities => acpica}/utinit.c (98%)
 rename drivers/acpi/{utilities => acpica}/utmath.c (99%)
 rename drivers/acpi/{utilities => acpica}/utmisc.c (97%)
 rename drivers/acpi/{utilities => acpica}/utmutex.c (99%)
 rename drivers/acpi/{utilities => acpica}/utobject.c (99%)
 rename drivers/acpi/{utilities => acpica}/utresrc.c (99%)
 rename drivers/acpi/{utilities => acpica}/utstate.c (99%)
 rename drivers/acpi/{utilities => acpica}/utxface.c (97%)
 delete mode 100644 drivers/acpi/dispatcher/Makefile
 delete mode 100644 drivers/acpi/events/Makefile
 delete mode 100644 drivers/acpi/executer/Makefile
 delete mode 100644 drivers/acpi/hardware/Makefile
 rename drivers/acpi/{sleep => }/main.c (92%)
 delete mode 100644 drivers/acpi/namespace/Makefile
 delete mode 100644 drivers/acpi/parser/Makefile
 rename drivers/acpi/{sleep => }/proc.c (92%)
 delete mode 100644 drivers/acpi/resources/Makefile
 rename drivers/acpi/{sleep => }/sleep.h (100%)
 delete mode 100644 drivers/acpi/sleep/Makefile
 delete mode 100644 drivers/acpi/tables/Makefile
 delete mode 100644 drivers/acpi/utilities/Makefile
 delete mode 100644 drivers/acpi/utilities/utcache.c
 rename drivers/acpi/{sleep => }/wakeup.c (96%)
 create mode 100644 drivers/platform/Kconfig
 create mode 100644 drivers/platform/Makefile
 create mode 100644 drivers/platform/x86/Kconfig
 create mode 100644 drivers/platform/x86/Makefile
 rename drivers/{misc => platform/x86}/acer-wmi.c (100%)
 rename drivers/{misc => platform/x86}/asus-laptop.c (100%)
 rename drivers/{acpi => platform/x86}/asus_acpi.c (100%)
 rename drivers/{misc => platform/x86}/compal-laptop.c (100%)
 rename drivers/{misc => platform/x86}/eeepc-laptop.c (100%)
 rename drivers/{misc => platform/x86}/fujitsu-laptop.c (74%)
 rename drivers/{misc => platform/x86}/hp-wmi.c (100%)
 rename drivers/{misc => platform/x86}/intel_menlow.c (100%)
 rename drivers/{misc => platform/x86}/msi-laptop.c (100%)
 rename drivers/{misc => platform/x86}/panasonic-laptop.c (97%)
 rename drivers/{misc => platform/x86}/sony-laptop.c (99%)
 rename drivers/{misc => platform/x86}/tc1100-wmi.c (99%)
 rename drivers/{misc => platform/x86}/thinkpad_acpi.c (99%)
 rename drivers/{acpi => platform/x86}/toshiba_acpi.c (100%)
 rename drivers/{acpi => platform/x86}/wmi.c (100%)
 delete mode 100644 include/acpi/acdisasm.h
 create mode 100644 include/acpi/acrestyp.h

through these commits:

Alexey Starikovskiy (2):
      ACPI: EC: Add some basic check for ECDT data
      Newly inserted battery might differ from one just removed, so

Bjorn Helgaas (20):
      ACPI: PCI: use conventional PCI address format
      ACPI: PCI: remove unnecessary null pointer checks
      ACPI: PCI: simplify buffer management for evaluating _PRT
      ACPI: PCI: ignore _PRT function information
      ACPI: PCI: fix GSI/IRQ naming confusion
      ACPI: PCI: move struct acpi_prt_entry declaration out of public header file
      ACPI: PCI: add a helper to convert _PRT INTx pin number to name
      ACPI: PCI: always use the PCI INTx pin values, not the _PRT ones
      ACPI: PCI: use 1-based encoding for _PRT quirks
      ACPI: PCI: lookup _PRT entry by PCI dev and pin, not segment/bus/dev/pin
      ACPI: PCI: tweak _PRT lookup debug
      ACPI: PCI: remove callback from acpi_pci_irq_lookup & acpi_pci_irq_derive
      ACPI: PCI: use positive logic to simplify code
      ACPI: PCI: follow typical PCI INTx swizzling pattern
      ACPI: PCI: combine lookup and derive
      ACPI: PCI: simplify list of _PRT entries
      ACPI: PCI: simplify struct acpi_prt_entry
      ACPI: PCI: expand acpi_pci_allocate_irq() and acpi_pci_free_irq() inline
      ACPI: PCI: whitespace and useless initialization cleanup
      ACPI: PCI: add HP copyright

Bob Moore (25):
      ACPICA: Fix several warnings under gcc 4 compiler
      ACPICA: Update FACS waking vector interfaces
      ACPICA: Optimize execution of AML While loops
      ACPICA: Add a mechanism to escape infinite AML While() loops
      ACPICA: Update debug output for IndexField I/O
      ACPICA: Fix namestring for the SystemCMOS address space
      ACPICA: Emit warning if two FACS or DSDT tables found in the FADT
      ACPICA: Add global pointer for FACS table to simplify FACS access
      ACPICA: Reformat comments, no functional changes
      ACPICA: Add support to externally execute _OSI method
      ACPICA: Remove references to obsolete ACPI_DUMP_APP
      ACPICA: Fix to allow aliases within ASL namepaths
      ACPICA: Add Buffer->String conversion for predefined methods
      ACPICA: Consolidate method arg count validation code
      ACPICA: Update version to 20081031
      ACPICA: New: acpi_get_gpe_device interface
      ACPICA: New: Public GPE group enable/disable interfaces
      ACPICA: New: acpi_read and acpi_write public interfaces
      ACPICA: Move all public H/W interfaces to new hwxface
      ACPICA: New: acpi_reset interface - write to reset register
      ACPICA: Restructure includes into public/private
      ACPICA: Fixes for various ACPI data tables
      ACPICA: Add ACPI_MUTEX_TYPE configuration option
      ACPICA: FADT parsing changes and fixes
      ACPICA: FADT: Update error msgs for consistency

Corentin Chary (1):
      eeepc-laptop: use select and not depends on

Hannes Eder (1):
      ACPI: EC: fix compilation warning

Len Brown (10):
      drivers/misc/Makefile, Kconfig: cleanup
      create drivers/platform/x86/ from drivers/misc/
      ACPI: move wmi, asus_acpi, toshiba_acpi to drivers/platform/x86
      ACPI: disable MPS when NO APIC-table found
      ACPI: simplify buffer management for acpi_pci_bind() etc.
      ACPICA: delete acdisasm.h
      ACPICA: delete utcache.c
      ACPI: fix build warning
      ACPICA: create acpica/ directory
      ACPICA: hide private headers

Lin Ming (15):
      ACPICA: Fix possible memory leak on error in parser
      ACPICA: Allow multiple backslash prefix in namepaths
      ACPICA: Enhance implicit return mechanism
      ACPI: osl.c: replace return_ACPI_STATUS with return
      ACPI: ec.c: call acpi_get_name to get node name
      ACPI: proc.c: remove ACPI_FUNCTION_TRACE
      ACPI: wakeup.c: remove ACPI_FUNCTION_TRACE
      ACPI: main.c: use new public GPE group enable/disable interfaces
      ACPI: sony-laptop.c: call acpi_get_object_info to get node info
      ACPI: power.c: call acpi_get_name to get node name
      ACPI: panasonic-laptop.c: remove ACPI_FUNCTION_TRACE
      ACPI: io_acpi_init.c: call acpi_get_name to get node fullname
      ACPI: io_common.c: call acpi_get_table to avoid using ACPI_SIG_DSDT
      ACPI: reboot.c: use new acpi_reset interface
      ACPI: remove private acpica headers from driver files

Mark Lord (1):
      /proc/acpi/alarm: handle day-of-month wraparound on readback

Pallipadi, Venkatesh (1):
      cpuidle: Add decaying history logic to menu idle predictor

Rafael J. Wysocki (7):
      ACPI hibernate: Add a mechanism to save/restore ACPI NVS memory
      x86 hibernate: Mark ACPI NVS memory region at startup
      ACPI hibernate: Introduce new kernel parameter acpi_sleep=s4_nonvs
      Hibernate: Do not oops on resume if image data are incorrect
      Hibernate: Take overlapping zones into account (rev. 2)
      Hibernate: Replace unnecessary evaluation of pfn_to_page()
      ACPI: Do not modify SCI_EN directly

Randy Dunlap (1):
      doc: fix kernel-parameters.txt formatting

Roel Kluin (1):
      ACPI: ec.c, pci_link.c, video_detec.c: static

Tony Vroon (2):
      fujitsu-laptop: Add BL power, LED control and radio state information
      fujitsu-laptop: Simplify SBLL/SBL2 backlight handling

Zhang Rui (3):
      ACPI: video: Fix reversed brightness behavior on ThinkPad SL series
      Hibernate: Call platform_begin before swsusp_shrink_memory
      video: always update the brightness when poking "brightness"

Zhao Yakui (2):
      ACPI: Avoid array address overflow when _CST MWAIT hint bits are set
      ACPI : Use RSDT instead of XSDT by adding boot option of "acpi=rsdt"

robert.moore@intel.com (2):
      ACPICA: FADT: set acpi_gbl_use_default_register_widths to TRUE by default
      ACPICA: Update version to 20081204.

with this log:

commit d97c0defba25a959a990f6d4759f43075540832e
Merge: ec9f168... b4f9fe1...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 04:01:26 2009 -0500

    Merge branch 'drivers-platform' into release
    
    Conflicts:
    	drivers/misc/Kconfig
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ec9f168fcc344d2ffec1c8c822076bf22dab5c33
Merge: b2576e1... 087da3b...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:41:08 2009 -0500

    Merge branch 'simplify_PRT' into release
    
    Conflicts:
    	drivers/acpi/pci_irq.c
    
    Note that this merge disables
    e1d3a90846b40ad3160bf4b648d36c6badad39ac
    pci, acpi: reroute PCI interrupt to legacy boot interrupt equivalent
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b2576e1d4408e134e2188c967b1f28af39cd79d4
Merge: 3cc8a5f... 2150edc...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:39:43 2009 -0500

    Merge branch 'linus' into release

commit 3cc8a5f4ba91f67bbdb81a43a99281a26aab8d77
Merge: d0302bc... ada9cfd...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:38:15 2009 -0500

    Merge branch 'suspend' into release

commit d0302bc62af7983040ea1cd1b5dd2b36e1a6a509
Merge: 106ad8d... 237889b...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:37:48 2009 -0500

    Merge branch 'misc' into release
    
    Conflicts:
    	include/acpi/acpixf.h
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 106ad8d6b0a7c1a597fab56ec692c39f553fabbc
Merge: 33a8c92... f87a1a5...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:37:26 2009 -0500

    Merge branch 'fujitsu-laptop' into release

commit 33a8c927e423a205bcbbecdc43b451bad781a08e
Merge: b8ef914... 8a383ef...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:37:20 2009 -0500

    Merge branch 'fluff' into release

commit b8ef914e58e90c3b4dba5f5bdd8ab04c45d3e008
Merge: a8e896e... 3e54048... 935e5f2... 7b37b5f...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:37:11 2009 -0500

    Merge branches 'release', 'bugzilla-11880', 'bugzilla-12037' and 'bugzilla-12257' into release

commit a8e896e2813316a2d3657dc07d5eef83c3b2d9f4
Merge: 39cecf2... 50b1785...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:36:59 2009 -0500

    Merge branch 'battery' into release

commit 39cecf2091f10c3a5052d1e58da690d20852b243
Merge: 38f64c7... d944718...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:36:53 2009 -0500

    Merge branch 'asus-eeepc' into release

commit 38f64c771bece2cdbd72ed733e6fc8f2e279a7c1
Merge: e2f7a77... 2602a67...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 03:36:32 2009 -0500

    Merge branch 'alarm' into release

commit e2f7a7772880458edff1b1cc5a988947229fac26
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 00:30:03 2009 -0500

    ACPICA: hide private headers
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95b482a8d31116f3f5c2a5089569393234d06385
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 00:13:17 2009 -0500

    ACPICA: create acpica/ directory
    
    also, delete sleep/ and delete ACPI_CFLAGS from Makefile
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2602a671ad7321a25d253c080837e4569a9bceed
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jan 9 02:10:16 2009 -0500

    ACPI: fix build warning
    
    when CONFIG_RTC_DRV_CMOS=m
    and thus !defined(HAVE_ACPI_LEGACY_ALARM)
    
    drivers/acpi/proc.c:85: warning: ¡cmos_bcd_read¢ declared ¡static¢ but
    never defined
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 237889bf0a62f1399fb2ba0c2a259e6a96597131
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Dec 17 16:55:18 2008 +0800

    ACPI : Use RSDT instead of XSDT by adding boot option of "acpi=rsdt"
    
    On some boxes there exist both RSDT and XSDT table. But unfortunately
    sometimes there exists the following error when XSDT table is used:
       a. 32/64X address mismatch
       b. The 32/64X FACS address mismatch
    
       In such case the boot option of "acpi=rsdt" is provided so that
    RSDT is tried instead of XSDT table when the system can't work well.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8246
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    cc:Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 13b40a1a065824d2d4e55c8b48ea9f3f9d162929
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Sun Jan 4 12:04:21 2009 +0800

    ACPI: Avoid array address overflow when _CST MWAIT hint bits are set
    
    The Cx Register address obtained from the _CST object is used as the MWAIT
    hints if the register type is FFixedHW. And it is used to check whether
    the Cx type is supported or not.
    
    On some boxes the following Cx state package is obtained from _CST object:
        >{
                    ResourceTemplate ()
                    {
                        Register (FFixedHW,
                            0x01,               // Bit Width
                            0x02,               // Bit Offset
                            0x0000000000889759, // Address
                            0x03,               // Access Size
                            )
                    },
    
                    0x03,
                    0xF5,
                    0x015E }
    
       In such case we should use the bit[7:4] of Cx address to check whether
    the Cx type is supported or not.
    
    mask the MWAIT hint to avoid array address overflow
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Acked-by:Venki Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f87a1a5f6cdaff6232fed2ef0ae0479df9e781e8
Author: Tony Vroon <tony@linx.net>
Date:   Wed Jan 7 10:11:24 2009 +0000

    fujitsu-laptop: Simplify SBLL/SBL2 backlight handling
    
    GBLS and GBLL only differ in the clearing of the GHKS flag, so there is no need
    to have two backlight level readouts. Also, per Peter Gruber, the need for the
    BLNF check has disappeared.
    As a result, cleanups can be made in the code. This has been tested on the both
    the S6410 and the S6420 platforms and causes no functionality regressions, on
    the console without X or within X. One module parameter to disable the hotkeys
    is dropped, as we only ever took one codepath anyway.
    
    Signed-off-by: Tony Vroon <tony@linx.net>
    Tested-by: Peter Gruber <nokos@gmx.net>
    Tested-By: Stephen Gildea <stepheng+linux@gildea.com>
    Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3a407086090bb4fa1908d4dc3739c9ebc8ad6686
Author: Tony Vroon <tony@linx.net>
Date:   Wed Dec 31 18:19:59 2008 +0000

    fujitsu-laptop: Add BL power, LED control and radio state information
    
    The FUNC interface in the Fujitsu-Siemens DSDT was unused until now. It exposes
    state information that is now reported in additional platform files (whether the
    radios are killed by the hardware switch or operational, whether the machine is
    docked and whether the lid is open).
    Support for the backlight class is now extended with the ability to power the
    backlight on & off. Optional support for the LED class allows the keyboard
    headlamps found on the U810 netbook and the Fujitsu logo illumination on the
    P8010 notebook to be turned on & off.
    
    This was fed through checkpatch.pl and tested on the S6420, P8010 & U810 platforms.
    
    Signed-off-by: Stephen Gildea <stepheng+linux@gildea.com>
    Tested-by: Stephen Gildea <stepheng+linux@gildea.com>
    Tested-by: Julian Brown <jules@panic.cs-bristol.org.uk>
    Signed-off-by: Tony Vroon <tony@linx.net>
    Tested-by: Peter Gruber <nokos@gmx.net>
    Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6620e0c49f577454b772fb381543d60ae53eb885
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jan 8 23:46:09 2009 -0500

    ACPICA: delete utcache.c
    
    ACPI_USE_LOCAL_CACHE will never be defined by the Linux kernel,
    and thus utcache.c will always be dead code.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5b929aa1ae7c64b40ab85c7b49d9f086747c85d2
Author: Len Brown <len.brown@intel.com>
Date:   Thu Jan 8 23:44:17 2009 -0500

    ACPICA: delete acdisasm.h
    
    it is referenced only #ifdef ACPI_DISASSEMBLER,
    which is never set by the kernel.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e8443c358c34f3fe65236e24147ddf0cd0e61b08
Author: robert.moore@intel.com <robert.moore@intel.com>
Date:   Wed Dec 31 13:15:01 2008 +0800

    ACPICA: Update version to 20081204.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 40774f7acaba897f99ceea5d7de65ee8e2bd3696
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Dec 16 18:22:01 2008 +0800

    ACPICA: FADT: Update error msgs for consistency
    
    Update all messages so they look consistent.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4b67a0e467a57e24da6b761dbf95fa5d0225ff19
Author: robert.moore@intel.com <robert.moore@intel.com>
Date:   Wed Dec 31 13:07:26 2008 +0800

    ACPICA: FADT: set acpi_gbl_use_default_register_widths to TRUE by default
    
    This returns the FADT support to the original behavior, which is
    to use default register widths. However, now check each register
    definition and report a warning if it differs from the default.
    This is a first step to moving away from the default widths,
    rather than outright believing the widths in all FADTs for all
    machines, considered rather dangerous until more data is obtained.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 06f5541960d02d5e0ddd8fd5c9a1554d85d94fa9
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Dec 31 03:06:06 2008 +0800

    ACPICA: FADT parsing changes and fixes
    
    1) Update the register lengths for the PM1 event blocks. The
    length must be divided by two in order to use these to access
    the status registers.
    2) Add run-time option to use default register lengths to override a
    faulty FADT.
    3) Add warning message if any of the X64 address structures contain a length
    that does not match the legacy length earlier in the FADT.
    4) Move all FADT warning messages into the ValidateFadt function.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1685bd404dc2ecce2fdae6410e85ded2f2c0136d
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Dec 31 03:03:29 2008 +0800

    ACPICA: Add ACPI_MUTEX_TYPE configuration option
    
    Used to specify whether the OSL mutex interfaces should be used,
    or binary semaphores instead.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7488c8d51134a152f022bc11547157f80a725ff1
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Dec 16 16:04:29 2008 +0800

    ACPICA: Fixes for various ACPI data tables
    
    Eliminate extraneous "zero length subtable" messages.
    Fix subtable output for ERST, MCFG, EINJ tables.
    Implement all subtables for HEST.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50df4d8b0f6e1971b930f3158c9ee0e4263e636d
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Dec 31 03:01:23 2008 +0800

    ACPICA: Restructure includes into public/private
    
    acpi.h now includes only the "public" acpica headers. All other
    acpica headers are "private" and should not be included by acpica
    users. One new file, accommon.h is used to include the commonly
    used private headers for acpica code generation. Future plans
    are to move all private headers to a new subdirectory.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ea7e96e0f2277107d9ea14c3f16c86ba82b2e560
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 16:28:17 2008 +0800

    ACPI: remove private acpica headers from driver files
    
    External driver files should not include any private acpica headers.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2ee62612485f888b731804ca1b3b18ed8e842b51
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 16:40:31 2008 +0800

    ACPI: reboot.c: use new acpi_reset interface
    
    Use new acpi_reset interface to write to reset register
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d3fd902d1ed43aebfc407c08d7ce86495604124c
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Dec 30 11:11:57 2008 +0800

    ACPICA: New: acpi_reset interface - write to reset register
    
    Uses the FADT-defined reset register and reset value. Checks the
    FADT flags for the reset register supported bit. Supports reset
    register in memory or I/O space, but not in PCI config space
    since the host has the information to do it.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7db5d82d0278b506441ab6025f0c6ce2f2aa3019
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Dec 30 11:04:48 2008 +0800

    ACPICA: Move all public H/W interfaces to new hwxface
    
    Move public interfaces from hwregs.c to new file, hwxface.c -
    similar to the structure of the other ACPICA components.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ecfbbc7b46f74ca48b9f42132739114c9e70f8e4
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Dec 31 02:55:32 2008 +0800

    ACPICA: New: acpi_read and acpi_write public interfaces
    
    Changed the acpi_hw_low_level_read and acpi_hw_low_level_write functions to
    the public acpi_read and acpi_write to allow direct access to
    ACPI registers.  Removed the "width" parameter since the width
    can be obtained from the input GAS structure. Updated the FADT
    initialization to setup the GAS structures with the proper
    widths. Some widths are still hardcoded because many FADTs have
    incorrect register lengths.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 385c4d98d851bc94ad4f351fe25fe49b70b9cf78
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 17:08:57 2008 +0800

    ACPI: io_common.c: call acpi_get_table to avoid using ACPI_SIG_DSDT
    
    ACPI_SIG_DSDT is acpica internal used only.
    call acpi_get_table to avoid using ACPI_SIG_DSDT.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a8ce4471fe74cf749bcfef7e557a7b94f725c494
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 17:07:01 2008 +0800

    ACPI: io_acpi_init.c: call acpi_get_name to get node fullname
    
    acpi_ns_print_node_pathname is internal used only
    use acpi_get_name instead to get node fullname
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 46422814f988b32d595dd2ce6d43f4c6d3623d41
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 17:04:24 2008 +0800

    ACPI: panasonic-laptop.c: remove ACPI_FUNCTION_TRACE
    
    ACPI_FUNCTION_TRACE is an internal acpica function.
    remove ACPI_FUNCTION_TRACE from driver file
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 60a4ce7f4148155d3f28eea4a213f7ee47cd57b7
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 17:02:22 2008 +0800

    ACPI: power.c: call acpi_get_name to get node name
    
    acpi_ut_get_node_name is an internal acpica function.
    use acpi_get_name to get node ascii name
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 30823736162ff91512965e3c730557e34fa71d6d
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 16:59:35 2008 +0800

    ACPI: sony-laptop.c: call acpi_get_object_info to get node info
    
    Avoid using internal acpica structures acpi_namespace_node and acpi_operand_object
    Call acpi_get_object_info to get node ascii name and method arg count
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3d97e426aa97d60b3dac1b72923b90b491fbac20
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 16:57:46 2008 +0800

    ACPI: main.c: use new public GPE group enable/disable interfaces
    
    Avoid using internal functions: acpi_hw_disable_all_gpes and acpi_hw_enable_all_runtime_gpes
    Use new public GPE group enable/disable interfaces: acpi_disable_all_gpes and acpi_enable_all_runtime_gpes
    
    Also avoid using internal symbol ACPI_TABLE_INDEX_FACS, call acpi_get_table.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 08ac07b826cfd9a9b28aa094f14e1c023bdc9864
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Dec 30 09:55:48 2008 +0800

    ACPICA: New: Public GPE group enable/disable interfaces
    
    Added acpi_disable_all_gpes and acpi_enable_all_runtime_gpes for
    public use.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e97d6bf1a01b7403d98aea95731863aab2e84064
Author: Bob Moore <robert.moore@intel.com>
Date:   Tue Dec 30 09:45:17 2008 +0800

    ACPICA: New: acpi_get_gpe_device interface
    
    This function maps an input GPE index to a GPE block device. Also
    Added acpi_current_gpe_count to track the current number of GPEs
    that are being managed by the ACPICA core (both FADT-based GPEs
    and the GPEs contained in GPE block devices.)
    
    Modify drivers/acpi/system.c to use these 2 new interfaces
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c1e3523ccbeca312e11557d2a75f90632a2fb5c7
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 16:51:19 2008 +0800

    ACPI: wakeup.c: remove ACPI_FUNCTION_TRACE
    
    ACPI_FUNCTION_TRACE is an internal acpica function.
    remove ACPI_FUNCTION_TRACE
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 95d9a7a828aedef965234f348b916caa98be1e6c
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 16:49:26 2008 +0800

    ACPI: proc.c: remove ACPI_FUNCTION_TRACE
    
    ACPI_FUNCTION_TRACE and return_VALUE are internal acpica functions.
    remove ACPI_FUNCTION_TRACE
    replace return_VALUE with return
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0175d562a29ad052c510782c7e76bc63d5155b9b
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Tue Dec 16 16:46:12 2008 +0800

    ACPI: ec.c: call acpi_get_name to get node name
    
    acpi_namespace_node is internal struct, it should not be used outside of ACPICA
    call acpi_get_name to get node ascii name
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 889c78be9e8d84ea7f991b9b868e006cdb8e42b0
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Dec 31 09:23:57 2008 +0800

    ACPI: osl.c: replace return_ACPI_STATUS with return
    
    return_ACPI_STATUS is an internal acpica function, replace it with return.
    acpi_gbl_permanent_mmap moved from acglobal.h to acpixf.h for external use
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9e6dada9d255497127251c03aaa59296d186f959
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Wed Dec 31 10:58:48 2008 +0800

    video: always update the brightness when poking "brightness"
    
    always update props.brightness no matter the backlight is changed
    via procfs, hotkeys or sysfs.
    
    Sighed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8a383ef0be01e0e6e84c85f8bf35e4e6fcfb8981
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Tue Dec 9 20:45:30 2008 +0100

    ACPI: ec.c, pci_link.c, video_detec.c: static
    
    Sparse asked whether these could be static.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 087da3b4e2d7d3ef70a4fa649b9a286fdeb0e44e
Author: Len Brown <len.brown@intel.com>
Date:   Tue Dec 30 22:44:33 2008 -0500

    ACPI: simplify buffer management for acpi_pci_bind() etc.
    
    use ACPI_ALLOCATE_BUFFER to remove the allocations
    within acpi_pci_bind(), acpi_pci_unbind() and acpi_pci_bind_root().
    While there, delete some unnecessary param inits from those routines.
    
    Delete concept of ACPI_PATHNAME_MAX, since this was the last use.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 39488b041e2fdc206b3de4517b8f220ae07b2a20
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:31:42 2008 -0700

    ACPI: PCI: add HP copyright
    
    Add HP copyright to pci_irq.c.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3f0f3c27be19d390f23af1075d9948d0310e2673
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:31:37 2008 -0700

    ACPI: PCI: whitespace and useless initialization cleanup
    
    This patch makes function declarations consistent throughout
    the file and removes some unnecessary initializations.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 74f82af1eda39c26c17f8030e4f60c00929ec9df
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:31:32 2008 -0700

    ACPI: PCI: expand acpi_pci_allocate_irq() and acpi_pci_free_irq() inline
    
    acpi_pci_allocate_irq() and acpi_pci_free_irq() are trivial and
    only used once, so just open-code them.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4eaf6db3ea0edf7e011a613b5a15360444e58fec
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:31:27 2008 -0700

    ACPI: PCI: simplify struct acpi_prt_entry
    
    Remove unused "irq" field, remove unnecessary struct,
    rename "handle" to "link".
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3604a9f445afde2801b8c24b63dd289c33e290a6
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:31:21 2008 -0700

    ACPI: PCI: simplify list of _PRT entries
    
    We don't need a struct containing a count and a list_head; a simple
    list_head is sufficient.  The list iterators handle empty lists
    fine.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5697b7ca406b4ee0afeef6d9a29b823767716cab
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:31:16 2008 -0700

    ACPI: PCI: combine lookup and derive
    
    This folds acpi_pci_irq_derive() into acpi_pci_irq_lookup() so it
    can be easily used by both acpi_pci_irq_enable() and acpi_pci_irq_disable().
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ee40136313323db1096b17df7b436d22a24ef2be
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:31:11 2008 -0700

    ACPI: PCI: follow typical PCI INTx swizzling pattern
    
    No functional change; this just uses the typical pattern of
    PCI INTx swizzling done on other architectures.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b1ea18d3b3542b55861d7f968ded705e3bc2aa6
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:31:06 2008 -0700

    ACPI: PCI: use positive logic to simplify code
    
    This doesn't change anything functionally; it just changes tests
    so we test for success instead of failure.  This makes the code
    read more easily and allows us to remove the "!entry" in the while
    loop condition.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit beba8a643d7f774cf27c3c92a51b99cebf787415
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:31:01 2008 -0700

    ACPI: PCI: remove callback from acpi_pci_irq_lookup & acpi_pci_irq_derive
    
    We currently pass a callback function (either acpi_pci_allocate_irq() or
    acpi_pci_free_irq()) to acpi_pci_irq_lookup() and acpi_pci_irq_derive().
    
    I think it's simpler to remove the callback and just have the enable/
    disable functions make the calls directly.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 1350487eeb616889f589e9b8c06bd5077452b7e3
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:56 2008 -0700

    ACPI: PCI: tweak _PRT lookup debug
    
    Print one message (either "found" or "not found") for every _PRT
    search.  And add pin information to the INTx swizzling debug.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 063563b4b8f87e2be0e127ccf3a8e6eef6309ff4
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:51 2008 -0700

    ACPI: PCI: lookup _PRT entry by PCI dev and pin, not segment/bus/dev/pin
    
    There's no reason to pass around segment, bus, and device independently
    when we can just pass the pci_dev pointer, which carries all those
    already.
    
    The pci_dev contains an interrupt pin, too, but we still have to pass both
    the pci_dev and the pin because when we use a bridge to derive an IRQ, we
    need the pin from the downstream device, not the bridge.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c458033c9b72a81b890d97ec6339694bab252383
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:46 2008 -0700

    ACPI: PCI: use 1-based encoding for _PRT quirks
    
    Use the PCI INTx pin encoding (1=INTA, 2=INTB, etc) for _PRT quirks.
    Then we can simply compare "entry->pin == quirk->pin".
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e64e9db53ab78d20dff4cc1aec8a6b0e4e70ce8c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:41 2008 -0700

    ACPI: PCI: always use the PCI INTx pin values, not the _PRT ones
    
    This patch changes pci_irq.c to always use PCI INTx pin encodings
    instead of a mix of PCI and _PRT encodings.
    
    The PCI INTx pin numbers from the PCI_INTERRUPT_PIN config register
    are 0=device doesn't use interrupts, 1=INTA, ..., 4=INTD.  But the
    _PRT table uses 0=INTA, ..., 3=INTD.
    
    This patch converts the _PRT encoding to the PCI encoding immediately
    when we add a _PRT entry to the global list.  All the rest of the
    code can then use the PCI encoding consistently.
    
    The point of this is to make the interrupt swizzling look the same
    as on other architectures, so someday we can unify them.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit cf68b80b0e0cbc6a0d7bbb36b07ce94779ef5f1f
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:36 2008 -0700

    ACPI: PCI: add a helper to convert _PRT INTx pin number to name
    
    This adds a helper function to convert INTx pin numbers from the _PRT
    (0, 1, 2, 3) to the pin name ('A', 'B', 'C', 'D').
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f748bafa3ca1fb056e63afdeecacc1c68d8104df
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:31 2008 -0700

    ACPI: PCI: move struct acpi_prt_entry declaration out of public header file
    
    The struct acpi_prt_entry is used only in pci_irq.c, so there's no
    need for the declaration to be public.  This patch moves it into
    pci_irq.c.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c13f889a24e6ced50abb582dab3ee4b7c79b038e
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:26 2008 -0700

    ACPI: PCI: fix GSI/IRQ naming confusion
    
    The interrupt numbers from _PRT entries are GSIs, not Linux IRQs.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b52b3f4af83571e86f910b07a61b177e2b7d8409
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:20 2008 -0700

    ACPI: PCI: ignore _PRT function information
    
    _PRT entries don't contain any useful PCI function information (the
    function part of the PCI address is supposed to be 0xffff), and we
    don't ever look at it, so this patch just removes the reference to
    it.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2320ac6cb078eec77bf93742895dc35e64fae124
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:15 2008 -0700

    ACPI: PCI: simplify buffer management for evaluating _PRT
    
    Previously, acpi_pci_irq_add_prt() did all its own buffer management.
    But now that we have ACPI_ALLOCATE_BUFFER, we no longer need to do
    that management.  And we don't have to call acpi_get_irq_routing_table()
    twice (once to learn the size of the buffer needed, and again to
    actually get the table).
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3b8249de43ecf05407888c1ca6ca6e4945ff823c
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:10 2008 -0700

    ACPI: PCI: remove unnecessary null pointer checks
    
    Better to oops and learn about a bug than to silently cover it up.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 21a53283a012f21764f2aaaac9414849e1153d93
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Mon Dec 8 21:30:05 2008 -0700

    ACPI: PCI: use conventional PCI address format
    
    Use the conventional format for PCI addresses (%04x:%02x:%02x.%d).
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 11e93130c7ce5228d484fd5e86f3984835d4256b
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Dec 29 19:19:07 2008 +0100

    ACPI: Do not modify SCI_EN directly
    
    According to the ACPI specification the SCI_EN flag is controlled by
    the hardware, which sets this flag to inform the kernel that ACPI is
    enabled.  For this reason, we shouldn't try to modify SCI_EN
    directly.  Also, we don't need to do it in irqrouter_resume(), since
    lower-level resume code takes care of enabling ACPI in case it hasn't
    been enabled by the BIOS before passing control to the kernel (which
    by the way is against the ACPI specification).
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 816bb611e41be29b476dc16f6297eb551bf4d747
Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date:   Tue Dec 30 14:46:02 2008 -0800

    cpuidle: Add decaying history logic to menu idle predictor
    
    Add decaying history of predicted idle time, instead of using the last early
    wakeup. This logic helps menu governor do better job of predicting idle time.
    
    With this change, we also measured noticable (~8%) power savings on
    a DP server system with CPUs supporting deep C states, when system
    was lightly loaded. There was no change to power or perf on other load
    conditions.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9b02d6e198d8249246760a93b3adb8df6ecb5204
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 27 15:20:20 2008 +0800

    ACPICA: Update version to 20081031
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7a4b8131ac7b47feb110b3e0142d4207ee79a025
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Nov 13 11:25:22 2008 +0800

    ACPICA: Enhance implicit return mechanism
    
    For Windows compatibility, return an implicit integer of value
    zero for methods that have no executable code. A default implicit
    value of zero is provided for methods. Lin Ming.
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit eeb4437e63c39ce19cf9b2de36a1dddbf12910c4
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 13 11:19:24 2008 +0800

    ACPICA: Consolidate method arg count validation code
    
    Merge the code that validates control method argument counts into
    the predefined validation module. Eliminates possible multiple
    warnings for incorrect counts.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a647b5c34047560d7efe7e53e756c6692ce67dc7
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Nov 14 08:44:39 2008 +0800

    ACPICA: Add Buffer->String conversion for predefined methods
    
    For predefined methods (such as _BIF), add automatic conversion for
    objects that are required to be a String, but a Buffer was found
    instead. This can happen when reading string battery data from
    an operation region, because it used to be difficult to convert
    the data from buffer to string from within the ASL. Linux BZ 11822.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11822
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d037c5fd7367548191eab2b376a1d08c4ffaf7ff
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Nov 13 10:54:39 2008 +0800

    ACPICA: Allow multiple backslash prefix in namepaths
    
    In a fully qualified namepath, allow multiple backslash prefixes.
    This can happen because of the use of a double-backslash in strings
    (since backslash is the escape character) causing confusion.
    ACPICA BZ 739 Lin Ming.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=739
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5572a9859fa55216597b8226717691956d3e53e3
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 13 10:51:49 2008 +0800

    ACPICA: Fix to allow aliases within ASL namepaths
    
    Fixes a problem where the use of an alias within a namepath
    would result in a not found error or cause the compiler to fault.
    Also now allows forward references from the Alias operator itself.
    ACPICA BZ 738.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=738
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 319f8b892722f289bb6e07b1067be3b2e0714238
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 13 10:48:00 2008 +0800

    ACPICA: Remove references to obsolete ACPI_DUMP_APP
    
    This define is no longer used.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit a8fadc923d1659f1a322194d420808d5b255883c
Author: Bob Moore <robert.moore@intel.com>
Date:   Thu Nov 13 09:45:35 2008 +0800

    ACPICA: Add support to externally execute _OSI method
    
    The current implemenation of _OSI within ACPICA only allows other
    control methods to execute _OSI. This change allows the host
    OS to execute _OSI via the AcpiEvaluateObject interface. _OSI
    is a special method -- it does not exist in the AML code, it is
    implemented within ACPICA.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 9f15fc666ef54afc7aff31dfa31edecf00e0d81a
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 16:01:56 2008 +0800

    ACPICA: Reformat comments, no functional changes
    
    Reformat comments to use fewer lines.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 009c4cbe99bea2da53f29ad685975a36f38c001c
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 15:34:52 2008 +0800

    ACPICA: Add global pointer for FACS table to simplify FACS access
    
    Use a global pointer instead of using AcpiGetTableByIndex for
    each FACS access. This simplifies the code for the Global Lock
    and the Firmware Waking Vector(s).
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c87609f31a8641009641fc1d19dac75e6de06fd4
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 15:23:20 2008 +0800

    ACPICA: Emit warning if two FACS or DSDT tables found in the FADT
    
    Checks if there are two valid but different addresses for the
    FACS and DSDT within the FADT (mismatch between the 32-bit and
    64-bit fields.)
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 34830726c9761f66299f4d82c4357e5faec54013
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 15:17:41 2008 +0800

    ACPICA: Fix namestring for the SystemCMOS address space
    
    This fixes the name of this address space, changing it from the
    incorrect CMOS to the correct SystemCMOS.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e9a8c6a90953b65326881189a1f3782bb2f6d250
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 15:16:49 2008 +0800

    ACPICA: Update debug output for IndexField I/O
    
    Split the "data register I/O" with more informative read and
    write messages.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit fc37445733aeae4fd1a20385850620354263b1d5
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 15:15:29 2008 +0800

    ACPICA: Add a mechanism to escape infinite AML While() loops
    
    Add a loop counter to force exit from AML While loops if the
    count becomes too large. This can occur in poorly written AML
    when the hardware does not respond within a while loop and the
    loop does not implement a timeout. The maximum loop count is
    configurable. A new exception code is returned when a loop is
    broken, AE_AML_INFINITE_LOOP.  Bob Moore, Alexey Starikovskiy.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 96411a630412f057d365aa1e9de7d23c069d627a
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 15:02:00 2008 +0800

    ACPICA: Optimize execution of AML While loops
    
    Previously, a control state object was allocated and freed for
    each execution of the loop. The optimization is to simply reuse
    the control state for each iteration. This speeds up the raw loop
    execution time by about 5%.
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 84d4db7c528e23f8c9ae0be12960549347003eeb
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Wed Nov 12 14:56:59 2008 +0800

    ACPICA: Fix possible memory leak on error in parser
    
    Fixes a possible memory leak if an allocation failure happens in
    the parse loop. Must terminate an executing control method.
    Lin Ming, Bob Moore. ACPICA BZ 489.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=489
    
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d85988fa0205b18459071e4bd709e48e695b952d
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 14:54:05 2008 +0800

    ACPICA: Update FACS waking vector interfaces
    
    Split AcpiSetFirmwareWakingVector into two: one for the 32-bit
    vector, another for the 64-bit vector. This is required because the
    host OS must setup the wake much differently for each vector (real
    vs. protected mode, etc.) and the interface should not be deciding
    which vector to use.  Also eliminate the GetFirmwareWakingVector
    interface, as it served no purpose (only the firmware reads the
    vector, OS only writes the vector.)  ACPICA BZ 731.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=731
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6de4048a416d46eb2ac6597d03d2b58806a6b800
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Nov 12 14:16:21 2008 +0800

    ACPICA: Fix several warnings under gcc 4 compiler
    
    New compiler is pickier than older versions.
    Joerg Sonnenberger. From ACPICA BZ 732.
    
    http://www.acpica.org/bugzilla/show_bug.cgi?id=732
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d9447183366ce849d7483bbd369752ac748e0422
Author: Corentin Chary <corentincj@iksaif.net>
Date:   Tue Dec 23 21:08:29 2008 +0100

    eeepc-laptop: use select and not depends on
    
    As len said:
    "Kconfig should offer users features, and not make users
    devine their dependencies.
    
    Signed-off-by: Corentin Chary <corentincj@iksaif.net>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7b37b5fd9ba32c0c5afc3537eed7e7466f2173e2
Author: Len Brown <len.brown@intel.com>
Date:   Tue Dec 23 01:47:42 2008 -0500

    ACPI: disable MPS when NO APIC-table found
    
    When ACPI is asked to find an MADT (APIC table)
    and fails, then ACPI expects to run in PIC mode.
    
    However, if an MP Table is was found, IRQs will be
    registered as if an IOAPIC is being used, even
    though ACPI is configuring interrupt links links for PIC mode.
    
    In this scenario, disable MPS so that IRQs
    are registered in PIC mode, consistent with ACPI.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12257
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 50b178512b7d6e7724f87459f6bd06504c9c2da1
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Dec 23 02:44:54 2008 +0300

    Newly inserted battery might differ from one just removed, so
    update of battery info fields is required.
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Andy Neitzke <neitzke@ias.edu>
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy <at> suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ada9cfdd158abb8169873dc8e5ae39b1ec6ffa8c
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Fri Dec 19 10:57:32 2008 -0800

    doc: fix kernel-parameters.txt formatting
    
    Spell out "wrt".  I suspect plenty of people won't know
    what that means.
    
    Fix a '}' that should be a ']'.
    
    Reformat long lines into shorter lines.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b4f9fe12157a33351d0df78e925dcacd13252783
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 11 14:37:26 2008 -0500

    ACPI: move wmi, asus_acpi, toshiba_acpi to drivers/platform/x86
    
    These are platform specific drivers that happen to use ACPI,
    while drivers/acpi/ is for code that implements ACPI itself.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 41b16dce390510f550a4d2b12b98e0258bbed6e2
Author: Len Brown <len.brown@intel.com>
Date:   Mon Dec 1 00:09:47 2008 -0500

    create drivers/platform/x86/ from drivers/misc/
    
    Move x86 platform specific drivers from drivers/misc/
    to a new home under drivers/platform/x86/.
    
    The community has been maintaining x86 vendor-specific
    platform specific drivers under /drivers/misc/ for a few years.
    The oldest ones started life under drivers/acpi.
    They moved out of drivers/acpi/ because they don't actually
    implement the ACPI specification, but either simply
    use ACPI, or implement vendor-specific ACPI extensions.
    
    In the future we anticipate...
    drivers/misc/ will go away.
    other architectures will create drivers/platform/<arch>
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8c36790a21eec6c39c372e92c76e81865005a6ce
Author: Len Brown <len.brown@intel.com>
Date:   Sun Nov 30 23:59:07 2008 -0500

    drivers/misc/Makefile, Kconfig: cleanup
    
    tabs->space and delete unnecessary dummy build-in.o rule.
    
    Suggested-by: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit baa5835df10254762aedb6cb23a9c1508f969736
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Dec 8 00:52:49 2008 +0100

    Hibernate: Replace unnecessary evaluation of pfn_to_page()
    
    Replace one evaluation of pfn_to_page() in copy_data_pages() with
    the value of a local variable containing the right number already.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 846705deb059c352cc0e5806d5964f815b8c6d98
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Nov 26 18:00:24 2008 -0500

    Hibernate: Take overlapping zones into account (rev. 2)
    
    It has been requested to make hibernation work with memory
    hotplugging enabled and for this purpose the hibernation code has to
    be reworked to take the possible overlapping of zones into account.
    Thus, rework the hibernation memory bitmaps code to prevent
    duplication of PFNs from occuring and add checks to make sure that
    one page frame will not be marked as saveable many times.
    
    Additionally, use list.h lists instead of open-coded lists to
    implement the memory bitmaps.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 69643279a88dea000ac2f858091d0e365f778245
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Tue Nov 11 21:32:44 2008 +0100

    Hibernate: Do not oops on resume if image data are incorrect
    
    During resume from hibernation using the userland interface image
    data are being passed from the used space process to the kernel.
    These data need not be valid, but currently the kernel sometimes
    oopses if it gets invalid image data, which is wrong.  Make the
    kernel return error codes to the user space in such cases.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ba84ed9546e91348fdf3ff2bff859b0ee53b407a
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Oct 26 20:56:30 2008 +0100

    ACPI hibernate: Introduce new kernel parameter acpi_sleep=s4_nonvs
    
    On some machines it may be necessary to disable the saving/restoring
    of the ACPI NVS memory region during hibernation/resume.  For this
    purpose, introduce new ACPI kernel command line option
    acpi_sleep=s4_nonvs.
    
    Based on a patch by Zhang Rui.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Nigel Cunningham <nigel@tuxonice.net>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit b69edc76539be6a4aa39a22f85365fd4a3b3b9d2
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Oct 31 01:02:41 2008 +0100

    x86 hibernate: Mark ACPI NVS memory region at startup
    
    Introduce new initcall for marking the ACPI NVS memory at startup, so
    that it can be saved/restored during hibernation/resume.
    
    Based on a patch by Zhang Rui.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3f4b0ef7f2899c91b1d6958779f084b44dd59d32
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sun Oct 26 20:52:15 2008 +0100

    ACPI hibernate: Add a mechanism to save/restore ACPI NVS memory
    
    According to the ACPI Specification 3.0b, Section 15.3.2,
    "OSPM will call the _PTS control method some time before entering a
    sleeping state, to allow the platform's AML code to update this
    memory image before entering the sleeping state. After the system
    awakes from an S4 state, OSPM will restore this memory area and call
    the _WAK control method to enable the BIOS to reclaim its memory
    image."  For this reason, implement a mechanism allowing us to save
    the NVS memory during hibernation and to restore it during the
    subsequent resume.
    
    Based on a patch by Zhang Rui.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Nigel Cunningham <nigel@tuxonice.net>
    Cc: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3fe0313e6ec572e6bb3f9d247316a834336db4be
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Sun Oct 26 20:50:26 2008 +0100

    Hibernate: Call platform_begin before swsusp_shrink_memory
    
    Call platform_begin() before swsusp_shrink_memory() so that we can
    always allocate enough memory to save the ACPI NVS region from
    platform_begin().
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Acked-by: Nigel Cunningham <nigel@tuxonice.net>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 935e5f290ec1eb0f1c15004421f5fd3154380fd5
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Dec 11 16:24:52 2008 -0500

    ACPI: video: Fix reversed brightness behavior on ThinkPad SL series
    
    Section B.6.2 of ACPI 3.0b specification that defines _BCL method
    doesn't require the brightness levels returned to be sorted.
    At least ThinkPad SL300 (and probably all IdeaPads) returns the
    array reversed (i.e. bightest levels have lowest indexes), which
    causes the brightness management behave in completely reversed
    manner on these machines (brightness increases when the laptop is
    idle, while the display dims when used).
    
    Sorting the array by brightness level values after reading the list
    fixes the issue.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=12037
    
    Signed-off-by: Zhang Rui <rui.zhang@intel.com>
    Tested-by: Lubomir Rintel <lkundrak@v3.sk>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 48452e5f99ab35d643df0463b6ad11aea8ea7bdc
Author: Mark Lord <lkml@rtr.ca>
Date:   Tue Dec 9 10:46:30 2008 -0500

    /proc/acpi/alarm: handle day-of-month wraparound on readback
    
    Fix month wrap issue with readback from /proc/acpi/alarm
    This bug has been around *forever*.
    
      $ echo '2008-12-01 10:36:20' > /proc/acpi/alarm
      $ cat /proc/acpi/alarm
      2008-11-01 10:36:20
    
    Note how the readback above shows the month incorrectly
    when the alarm is set in the *next* calendar month.
    But with this patch applied, it shows the correct month (12).
    
    Signed-off-by: Mark Lord <mlord@pobox.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3e54048691bce3f323fd5460695273be379803b9
Author: Hannes Eder <hannes@hanneseder.net>
Date:   Sat Nov 29 07:21:29 2008 +0100

    ACPI: EC: fix compilation warning
    
    Fix the warning introduced in commit c5279dee26c0e8d7c4200993bfc4b540d2469598,
    and give the dummy variable a more verbose name.
    
      drivers/acpi/ec.c: In function 'acpi_ec_ecdt_probe':
      drivers/acpi/ec.c:1015: warning: ISO C90 forbids mixed declarations and code
    
    Signed-off-by: Hannes Eder <hannes@hanneseder.net>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c5279dee26c0e8d7c4200993bfc4b540d2469598
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed Nov 26 17:11:53 2008 -0500

    ACPI: EC: Add some basic check for ECDT data
    
    One more ASUS comes with empty ECDT, add a guard for it...
    
    http://bugzilla.kernel.org/show_bug.cgi?id=11880
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

--Boundary_(ID_xn4GNqut7BHxcMNp+Oe45Q)--
