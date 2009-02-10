Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZBJTDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZBJTDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZBJTDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:25 -0500
Received: from kroah.org ([198.145.64.141]:53532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754540AbZBJTDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:24 -0500
Date: Tue, 10 Feb 2009 10:59:24 -0800
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
Subject: [patch 00/53] 2.6.28-stable review
Message-ID: <20090210185924.GA14308@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.28.5 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the
Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
to add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Thursday, February 12 19:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.8-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Documentation/filesystems/sysfs-pci.txt |   13 +++-
 Makefile                                |    2 +-
 arch/ia64/sn/kernel/io_acpi_init.c      |    2 +-
 arch/ia64/sn/kernel/io_init.c           |    2 +-
 arch/x86/kernel/apic.c                  |    2 +-
 arch/x86/mm/fault.c                     |    8 ++-
 drivers/acpi/asus_acpi.c                |   16 ++++-
 drivers/acpi/dock.c                     |    6 ++-
 drivers/acpi/tables.c                   |    7 ++-
 drivers/acpi/tables/tbutils.c           |    7 +-
 drivers/acpi/video.c                    |   29 +++++++-
 drivers/ata/sata_via.c                  |    2 +
 drivers/block/nbd.c                     |    4 +
 drivers/char/agp/intel-agp.c            |   11 +++-
 drivers/firewire/fw-ohci.c              |    2 +-
 drivers/firewire/fw-sbp2.c              |   43 +++++++-----
 drivers/ieee1394/ohci1394.h             |    2 +-
 drivers/ieee1394/sbp2.c                 |   10 +++
 drivers/md/linear.c                     |    6 +-
 drivers/md/md.c                         |   24 ++++---
 drivers/misc/eeepc-laptop.c             |    7 ++-
 drivers/misc/panasonic-laptop.c         |    2 +-
 drivers/misc/sgi-xp/xpc.h               |    5 +-
 drivers/misc/sgi-xp/xpc_uv.c            |   11 ++--
 drivers/net/e1000/e1000_main.c          |    6 +-
 drivers/net/wireless/ipw2200.c          |   28 ++++++--
 drivers/net/wireless/ipw2200.h          |    1 +
 drivers/pci/pci-sysfs.c                 |    4 +-
 drivers/pci/pcie/aspm.c                 |    4 +-
 drivers/pci/rom.c                       |    8 ++-
 drivers/serial/8250_pci.c               |    9 +++
 drivers/usb/serial/option.c             |   93 +++++++++++++++----------
 drivers/usb/serial/ti_usb_3410_5052.c   |   13 +++-
 drivers/usb/serial/ti_usb_3410_5052.h   |    4 +
 drivers/usb/storage/scsiglue.c          |    2 +
 drivers/usb/storage/unusual_devs.h      |   15 ----
 fs/binfmt_elf.c                         |   14 +++-
 fs/seq_file.c                           |  115 ++++++++++++++++---------------
 fs/xfs/linux-2.6/xfs_buf.c              |    3 +-
 include/acpi/pdc_intel.h                |    2 +
 include/linux/module.h                  |    1 -
 include/linux/pci.h                     |    2 +-
 include/linux/pci_ids.h                 |    1 +
 include/linux/serial.h                  |    3 +-
 include/linux/wait.h                    |   11 +++-
 ipc/shm.c                               |    4 +
 kernel/sched.c                          |    4 +-
 kernel/sys.c                            |   16 +---
 kernel/wait.c                           |   59 ++++++++++++++--
 mm/memory.c                             |    2 +-
 mm/mlock.c                              |    5 +-
 net/sctp/input.c                        |   13 ++++
 sound/pci/hda/patch_realtek.c           |    4 +
 sound/usb/usbaudio.c                    |    1 +
 54 files changed, 448 insertions(+), 222 deletions(-)
