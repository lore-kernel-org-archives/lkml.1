Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZBKAZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZBKAZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZBKAZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:25:11 -0500
Received: from kroah.org ([198.145.64.141]:50863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754642AbZBKAZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:25:10 -0500
Date: Tue, 10 Feb 2009 16:23:28 -0800
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
Subject: [patch 00/56] 2.6.27-stable review
Message-ID: <20090211002328.GA14660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.16 release.
There are 56 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday, February 12 19:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.16-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/filesystems/sysfs-pci.txt    |   13 +++-
 Makefile                                   |    2 +-
 arch/ia64/sn/kernel/io_acpi_init.c         |    2 +-
 arch/ia64/sn/kernel/io_init.c              |    2 +-
 arch/x86/kernel/apic_32.c                  |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    3 +
 arch/x86/mm/fault.c                        |    8 ++-
 drivers/acpi/dock.c                        |    8 ++-
 drivers/acpi/executer/exconfig.c           |  113 ++++++++++++++++++++--------
 drivers/acpi/namespace/nsxfeval.c          |   79 +++++++++++++++++++
 drivers/acpi/tables.c                      |    7 ++-
 drivers/acpi/tables/tbutils.c              |    7 +-
 drivers/acpi/video.c                       |   29 ++++++-
 drivers/char/agp/intel-agp.c               |   17 +++-
 drivers/char/vt.c                          |    5 +-
 drivers/firewire/fw-ohci.c                 |    2 +-
 drivers/firewire/fw-sbp2.c                 |   43 ++++++----
 drivers/ieee1394/ohci1394.h                |    2 +-
 drivers/ieee1394/sbp2.c                    |   10 +++
 drivers/md/dm-mpath.c                      |    4 +-
 drivers/md/md.c                            |   36 ++++++---
 drivers/misc/eeepc-laptop.c                |    3 +-
 drivers/misc/sgi-xp/xpc.h                  |    5 +-
 drivers/misc/sgi-xp/xpc_uv.c               |   11 +--
 drivers/net/e1000/e1000_main.c             |    6 +-
 drivers/net/usb/hso.c                      |    2 +-
 drivers/net/wireless/ipw2200.c             |   28 +++++--
 drivers/net/wireless/ipw2200.h             |    1 +
 drivers/pci/pci-sysfs.c                    |    4 +-
 drivers/pci/pcie/aspm.c                    |    4 +-
 drivers/pci/rom.c                          |    8 +-
 drivers/serial/8250_pci.c                  |   17 ++++
 drivers/usb/serial/option.c                |   93 ++++++++++++++---------
 drivers/usb/serial/ti_usb_3410_5052.c      |   13 +++-
 drivers/usb/serial/ti_usb_3410_5052.h      |    4 +
 drivers/usb/storage/scsiglue.c             |    2 +
 drivers/usb/storage/unusual_devs.h         |   15 ----
 drivers/video/console/fbcon.c              |   39 +++-------
 drivers/video/console/mdacon.c             |    2 +-
 drivers/video/console/sticon.c             |    4 +-
 drivers/video/console/vgacon.c             |    4 +-
 fs/binfmt_elf.c                            |   14 +++-
 fs/seq_file.c                              |  115 ++++++++++++++--------------
 fs/xfs/linux-2.6/xfs_buf.c                 |    3 +-
 include/acpi/pdc_intel.h                   |    2 +
 include/linux/console_struct.h             |    1 -
 include/linux/module.h                     |    1 -
 include/linux/pci.h                        |    2 +-
 include/linux/pci_ids.h                    |    1 +
 include/linux/wait.h                       |   11 ++-
 ipc/shm.c                                  |    4 +
 kernel/irq/chip.c                          |    1 +
 kernel/sched.c                             |    4 +-
 kernel/wait.c                              |   59 +++++++++++++--
 mm/swap.c                                  |   13 ---
 net/sctp/input.c                           |   13 +++
 net/sunrpc/svcsock.c                       |    9 ++-
 sound/pci/hda/patch_realtek.c              |    4 +
 sound/usb/usbaudio.c                       |    1 +
 59 files changed, 622 insertions(+), 295 deletions(-)
