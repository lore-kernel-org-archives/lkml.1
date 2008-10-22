Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbYJVWTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbYJVWTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbYJVWTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:19:08 -0400
Received: from kroah.org ([198.145.64.141]:54889 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755971AbYJVWTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:19:03 -0400
Date: Wed, 22 Oct 2008 15:12:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.26.7
Message-ID: <20081022221246.GC15277@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.26.7
kernel.

It contains a wide range of bugfixes, and all users of the 2.6.26 kernel
series are strongly encouraged to upgrade.

Actually, scratch that, you all should upgrade to the 2.6.27 kernel
series as soon as possible, as there will probably only be one more
2.6.26 kernel release, so starting to migrate now would be a very good
idea.

I'll also be replying to this message with a copy of the patch between
2.6.26.6 and 2.6.26.7

The updated 2.6.26.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/video4linux/CARDLIST.au0828 |    2 
 Makefile                                  |    2 
 arch/x86/kernel/alternative.c             |    2 
 arch/x86/kernel/io_apic_32.c              |    3 
 arch/x86/kernel/process_64.c              |    4 
 arch/x86/mm/ioremap.c                     |    2 
 drivers/acpi/video.c                      |   14 ++-
 drivers/ata/libata-eh.c                   |   24 +----
 drivers/char/drm/i915_dma.c               |    2 
 drivers/char/tty_io.c                     |    2 
 drivers/hwmon/it87.c                      |   39 +++++++--
 drivers/media/video/au0828/au0828-cards.c |    3 
 drivers/media/video/bt8xx/bttv-driver.c   |    2 
 drivers/media/video/tvaudio.c             |    2 
 drivers/media/video/uvc/uvc_ctrl.c        |   44 +++++++---
 drivers/media/video/uvc/uvc_video.c       |   33 +++++--
 drivers/media/video/zoran_driver.c        |    2 
 drivers/net/wireless/b43legacy/xmit.c     |    2 
 drivers/pci/pci-acpi.c                    |    7 +
 drivers/pci/pci-sysfs.c                   |   19 ++++
 drivers/pci/pcie/aspm.c                   |   18 ++++
 drivers/pci/probe.c                       |    3 
 drivers/video/console/fbcon.c             |    4 
 fs/cifs/cifsglob.h                        |    1 
 fs/cifs/cifssmb.c                         |    4 
 fs/cifs/readdir.c                         |  128 +++++++++++++++---------------
 fs/splice.c                               |    3 
 include/acpi/actbl.h                      |    1 
 include/linux/ata.h                       |    2 
 include/linux/pci-aspm.h                  |    5 +
 include/linux/pci_regs.h                  |    1 
 kernel/module.c                           |    2 
 kernel/sched_rt.c                         |    8 -
 33 files changed, 259 insertions(+), 131 deletions(-)

Alan Cox (2):
      x86, early_ioremap: fix fencepost error
      tty: Termios locking - sort out real_tty confusions and lock reads

Alexey Dobriyan (1):
      modules: fix module "notes" kobject leak

Arjan van de Ven (1):
      security: avoid calling a NULL function pointer in drivers/video/tvaudio.c

Dario Faggioli (1):
      sched_rt.c: resch needed in rt_rq_enqueue() for the root rt_rq

David Rientjes (1):
      x86: avoid dereferencing beyond stack + THREAD_SIZE

Greg Kroah-Hartman (1):
      Linux 2.6.26.7

Jean Delvare (3):
      V4L: bttv: Prevent NULL pointer dereference in radio_open
      V4L: zr36067: Fix RGBR pixel format
      hwmon: (it87) Prevent power-off on Shuttle SN68PT

Larry Finger (1):
      b43legacy: Fix failure in rate-adjustment mechanism

Laurent Pinchart (2):
      V4L/DVB (8498): uvcvideo: Return sensible min and max values when querying a boolean control.
      V4L/DVB (8617): uvcvideo: don't use stack-based buffers for USB transfers.

Linus Torvalds (2):
      Don't allow splice() to files opened with O_APPEND
      Check mapped ranges on sysfs resource files

Matthias Hopf (1):
      drm/i915: fix ioremap of a user address for non-root (CVE-2008-3831)

Michael Krufky (1):
      DVB: au0828: add support for another USB id for Hauppauge HVR950Q

Oleg Nesterov (1):
      fbcon_set_all_vcs: fix kernel crash when switching the rotated consoles

Ralph Loader (1):
      V4L/DVB (9053): fix buffer overflow in uvc-video

Shaohua Li (2):
      PCI: disable ASPM per ACPI FADT setting
      PCI: disable ASPM on pre-1.1 PCIe devices

Stefan Bader (1):
      x86: Reserve FIRST_DEVICE_VECTOR in used_vectors bitmap.

Steve French (1):
      CIFS: make sure we have the right resume info before calling CIFSFindNext

Taisuke Yamada (1):
      libata: LBA28/LBA48 off-by-one bug in ata.h

Tejun Heo (2):
      libata: always do follow-up SRST if hardreset returned -EAGAIN
      libata: fix EH action overwriting in ata_eh_reset()

Thomas Gleixner (1):
      x86: improve UP kernel when CPU-hotplug and SMP is enabled

Zhao Yakui (1):
      ACPI: Ignore _BQC object when registering backlight device

