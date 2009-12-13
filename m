Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZLNAMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZLNAMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbZLMX6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:58:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975AbZLMX54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:56 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       akpm@linux-foundation.org, alan@linux.intel.com,
       torvalds@linux-foundation.org
Subject: [PATCH 0/3] Constify struct hv_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:42 +0100
Message-Id: <cover.1260662998.git.re.emese@gmail.com>
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
file_operations
* hv_ops
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

 drivers/char/hvc_beat.c       |    2 +-
 drivers/char/hvc_console.c    |    6 +++---
 drivers/char/hvc_console.h    |    6 +++---
 drivers/char/hvc_iseries.c    |    2 +-
 drivers/char/hvc_iucv.c       |    2 +-
 drivers/char/hvc_rtas.c       |    2 +-
 drivers/char/hvc_udbg.c       |    2 +-
 drivers/char/hvc_vio.c        |    2 +-
 drivers/char/hvc_xen.c        |    2 +-
 drivers/char/virtio_console.c |    1 +
 10 files changed, 14 insertions(+), 13 deletions(-)

