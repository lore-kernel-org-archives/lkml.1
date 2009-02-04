Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbZBDSv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbZBDSv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761360AbZBDStA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:00 -0500
Received: from kroah.org ([198.145.64.141]:34230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761355AbZBDSs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:48:59 -0500
Date: Wed, 4 Feb 2009 10:45:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/41] 2.6.27-stable review
Message-ID: <20090204184539.GA25246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.15 release.
There are 41 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Friday, February 6, 19:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.15-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                            |    2 +-
 arch/ia64/sn/kernel/io_acpi_init.c  |    8 ++--
 arch/m68knommu/Kconfig              |    4 ++
 arch/x86/Kconfig                    |    3 +
 arch/x86/kernel/acpi/cstate.c       |    4 +-
 arch/x86/lib/usercopy_32.c          |    4 +-
 arch/x86/lib/usercopy_64.c          |    4 +-
 arch/x86/mm/pageattr.c              |   49 ++++++++++++------
 arch/x86/pci/irq.c                  |    1 +
 drivers/acpi/ac.c                   |    2 +-
 drivers/acpi/acpi_memhotplug.c      |    5 +-
 drivers/acpi/asus_acpi.c            |    4 +-
 drivers/acpi/battery.c              |    5 +-
 drivers/acpi/bay.c                  |    2 +-
 drivers/acpi/bus.c                  |    4 +-
 drivers/acpi/button.c               |    4 +-
 drivers/acpi/container.c            |    2 +-
 drivers/acpi/dispatcher/dsmethod.c  |    3 +
 drivers/acpi/dock.c                 |    6 +-
 drivers/acpi/ec.c                   |    8 ++-
 drivers/acpi/namespace/nsutils.c    |    8 +++-
 drivers/acpi/namespace/nsxfname.c   |    1 +
 drivers/acpi/numa.c                 |    2 +-
 drivers/acpi/osl.c                  |    5 +-
 drivers/acpi/parser/psparse.c       |    4 +-
 drivers/acpi/pci_link.c             |    4 --
 drivers/acpi/pci_root.c             |    2 +-
 drivers/acpi/pci_slot.c             |   10 ++--
 drivers/acpi/power.c                |    2 +-
 drivers/acpi/processor_core.c       |    4 +-
 drivers/acpi/processor_idle.c       |    1 +
 drivers/acpi/processor_perflib.c    |    2 +-
 drivers/acpi/processor_throttling.c |    2 +-
 drivers/acpi/sbshc.c                |    2 +-
 drivers/acpi/scan.c                 |   12 ++++-
 drivers/acpi/sleep/main.c           |   10 +++-
 drivers/acpi/thermal.c              |   43 ++++++++++------
 drivers/acpi/utils.c                |    4 +-
 drivers/acpi/video.c                |   47 +++++++++--------
 drivers/ata/libata-acpi.c           |    2 +-
 drivers/ata/sata_mv.c               |    6 +-
 drivers/ata/sata_nv.c               |   77 ++++++++++++++++++----------
 drivers/char/selection.c            |    2 +-
 drivers/cpuidle/cpuidle.c           |    9 +++-
 drivers/cpuidle/governors/menu.c    |   10 +++-
 drivers/input/keyboard/atkbd.c      |   34 ++++++++++++
 drivers/misc/asus-laptop.c          |   15 +++---
 drivers/misc/eeepc-laptop.c         |    2 +-
 drivers/misc/fujitsu-laptop.c       |    8 ++--
 drivers/misc/intel_menlow.c         |   29 ++++++-----
 drivers/net/ixgb/ixgb_main.c        |    8 ++-
 drivers/pci/hotplug/acpiphp_glue.c  |   14 +++---
 drivers/pci/hotplug/acpiphp_ibm.c   |    4 +-
 drivers/pci/hotplug/sgi_hotplug.c   |    4 +-
 drivers/serial/jsm/jsm_tty.c        |    6 ++
 drivers/usb/host/isp1760-if.c       |   96 ++++++++++++++++++++---------------
 drivers/video/aty/mach64_ct.c       |   11 ++++
 fs/cifs/connect.c                   |   18 +++---
 fs/dlm/plock.c                      |    2 +
 fs/nfsd/nfs4state.c                 |   31 +++++++----
 include/acpi/acpi_bus.h             |    2 +-
 include/acpi/actypes.h              |    2 +-
 include/linux/if_vlan.h             |    7 +++
 include/linux/pci_ids.h             |    1 +
 net/8021q/vlan_core.c               |   46 ++++++++++++-----
 net/core/dev.c                      |    3 +
 66 files changed, 480 insertions(+), 258 deletions(-)
