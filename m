Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZLNAQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZLNAQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbZLNAQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:16:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34804 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbZLMX5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:53 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       miklos@szeredi.hu
Subject: [PATCH 0/9] Constify struct file_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:28 +0100
Message-Id: <cover.1260662997.git.re.emese@gmail.com>
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
backlight_ops
block_device_operations
dma_map_ops
extent_io_ops
file_lock_operations
* file_operations
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

 drivers/acpi/battery.c                           |    2 +-
 drivers/block/drbd/drbd_int.h                    |    2 +-
 drivers/block/drbd/drbd_proc.c                   |    2 +-
 drivers/char/pty.c                               |    1 +
 drivers/char/tty_io.c                            |    1 +
 drivers/media/dvb/dvb-core/dvbdev.c              |    1 +
 drivers/net/wireless/b43/debugfs.c               |    2 +-
 drivers/net/wireless/b43legacy/debugfs.c         |    2 +-
 drivers/net/wireless/libertas/debugfs.c          |    2 +-
 drivers/staging/b3dfg/b3dfg.c                    |    2 +-
 drivers/staging/dream/pmem.c                     |    4 ++--
 drivers/staging/dream/qdsp5/adsp_driver.c        |    2 +-
 drivers/staging/dream/qdsp5/audio_aac.c          |    2 +-
 drivers/staging/dream/qdsp5/audio_amrnb.c        |    2 +-
 drivers/staging/dream/qdsp5/audio_evrc.c         |    2 +-
 drivers/staging/dream/qdsp5/audio_in.c           |    4 ++--
 drivers/staging/dream/qdsp5/audio_mp3.c          |    2 +-
 drivers/staging/dream/qdsp5/audio_out.c          |    4 ++--
 drivers/staging/dream/qdsp5/audio_qcelp.c        |    2 +-
 drivers/staging/dream/qdsp5/snd.c                |    2 +-
 drivers/staging/dream/smd/smd_qmi.c              |    2 +-
 drivers/staging/dream/smd/smd_rpcrouter_device.c |    4 ++--
 drivers/staging/panel/panel.c                    |    4 ++--
 drivers/staging/poch/poch.c                      |    2 +-
 drivers/staging/rtl8192u/ieee80211/proc.c        |    2 +-
 drivers/staging/sep/sep_driver.c                 |    2 +-
 drivers/staging/vme/devices/vme_user.c           |    2 +-
 fs/fuse/cuse.c                                   |   19 ++++++++++++-------
 fs/fuse/dev.c                                    |    8 ++++----
 fs/fuse/fuse_i.h                                 |   10 ++++++++++
 virt/kvm/kvm_main.c                              |    3 +++
 31 files changed, 61 insertions(+), 40 deletions(-)

