Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZLNAWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZLNAWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZLMX5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbZLMX51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:27 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, torvalds@linux-foundation.org,
       len.brown@intel.com, akpm@linux-foundation.org, mjg@redhat.com,
       gregkh@suse.de
Subject: [PATCH 00/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:58:52 +0100
Message-Id: <cover.1260662994.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Hello everyone!

The following patch series attempts to constify several structures
that hold function pointers. This is only the initial batch, there
are about over 150 candidate structures, some of which can be
constified as well, I plan to submit them in the future.

The list of constified structures in this series (* marks this thread):
acpi_dock_ops
address_space_operations
* backlight_ops
block_device_operations
dma_map_ops
extent_io_ops
file_lock_operations
file_operations
hv_ops
intel_dvo_dev_ops
item_operations
iwl_ops
kgdb_arch
kgdb_io
kset_uevent_ops
lock_manager_operations
microcode_ops
mtrr_ops
neigh_ops
nlmsvc_binding
pci_raw_ops
platform_hibernation_ops
platform_suspend_ops
snd_ac97_build_ops
sysfs_ops
usb_mon_operations
wd_ops

There are certain exceptions where a given instance of the structure
cannot be const, they are marked with a comment in the patch.

The patches compile fine with an allyesconfig kernel on i386 and x86_64.

Please let me know if any of these structures should not be constified
and any other issues you see with them.


Changelog:
----------
v1 -> v2
	- updated to linus-git-053fe57
	- extended comments with a reference to code that prevents constification
	- split up patches by subsystem as suggested by Greg KH, Jiri Slaby
	- added all Acked-by's received so far
	- removed patch for super_operations for now
	- removed patch for ptmx_fops

Thanks,
   Emese

 drivers/acpi/video.c                            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c     |    4 ++--
 drivers/macintosh/via-pmu-backlight.c           |    4 ++--
 drivers/platform/x86/acer-wmi.c                 |    2 +-
 drivers/platform/x86/asus-laptop.c              |    2 +-
 drivers/platform/x86/asus_acpi.c                |    2 +-
 drivers/platform/x86/compal-laptop.c            |    2 +-
 drivers/platform/x86/dell-laptop.c              |    2 +-
 drivers/platform/x86/eeepc-laptop.c             |    2 +-
 drivers/platform/x86/fujitsu-laptop.c           |    2 +-
 drivers/platform/x86/msi-laptop.c               |    2 +-
 drivers/platform/x86/panasonic-laptop.c         |    2 +-
 drivers/platform/x86/sony-laptop.c              |    2 +-
 drivers/platform/x86/thinkpad_acpi.c            |    2 +-
 drivers/platform/x86/toshiba_acpi.c             |    2 +-
 drivers/staging/samsung-laptop/samsung-laptop.c |    2 +-
 drivers/usb/misc/appledisplay.c                 |    2 +-
 drivers/video/atmel_lcdfb.c                     |    2 +-
 drivers/video/aty/aty128fb.c                    |    2 +-
 drivers/video/aty/atyfb_base.c                  |    2 +-
 drivers/video/aty/radeon_backlight.c            |    2 +-
 drivers/video/backlight/adp5520_bl.c            |    2 +-
 drivers/video/backlight/adx_bl.c                |    2 +-
 drivers/video/backlight/atmel-pwm-bl.c          |    2 +-
 drivers/video/backlight/backlight.c             |    2 +-
 drivers/video/backlight/corgi_lcd.c             |    2 +-
 drivers/video/backlight/cr_bllcd.c              |    2 +-
 drivers/video/backlight/da903x_bl.c             |    2 +-
 drivers/video/backlight/generic_bl.c            |    2 +-
 drivers/video/backlight/hp680_bl.c              |    2 +-
 drivers/video/backlight/jornada720_bl.c         |    2 +-
 drivers/video/backlight/kb3886_bl.c             |    2 +-
 drivers/video/backlight/locomolcd.c             |    2 +-
 drivers/video/backlight/mbp_nvidia_bl.c         |    2 +-
 drivers/video/backlight/omap1_bl.c              |    2 +-
 drivers/video/backlight/progear_bl.c            |    2 +-
 drivers/video/backlight/pwm_bl.c                |    2 +-
 drivers/video/backlight/tosa_bl.c               |    2 +-
 drivers/video/backlight/wm831x_bl.c             |    2 +-
 drivers/video/bf54x-lq043fb.c                   |    2 +-
 drivers/video/bfin-t350mcqb-fb.c                |    2 +-
 drivers/video/nvidia/nv_backlight.c             |    2 +-
 drivers/video/omap2/displays/panel-taal.c       |    2 +-
 drivers/video/riva/fbdev.c                      |    2 +-
 include/linux/backlight.h                       |   12 ++++++------
 45 files changed, 52 insertions(+), 52 deletions(-)

