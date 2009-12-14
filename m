Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZLNAJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZLNAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZLNAJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:09:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34974 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033AbZLMX6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:13 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       penberg@cs.helsinki.fi
Subject: [PATCH 0/4] Constify struct kset_uevent_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:00 +0100
Message-Id: <cover.1260663000.git.re.emese@gmail.com>
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
hv_ops
intel_dvo_dev_ops
item_operations
iwl_ops
kgdb_arch
kgdb_io
* kset_uevent_ops
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

 drivers/base/bus.c      |    2 +-
 drivers/base/core.c     |    2 +-
 drivers/base/memory.c   |    2 +-
 fs/gfs2/sys.c           |    2 +-
 include/linux/kobject.h |   10 +++++-----
 kernel/params.c         |    2 +-
 lib/kobject.c           |    4 ++--
 lib/kobject_uevent.c    |    2 +-
 mm/slub.c               |    2 +-
 9 files changed, 14 insertions(+), 14 deletions(-)

