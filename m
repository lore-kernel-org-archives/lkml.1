Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZLNAEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZLNAEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZLNAET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:04:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35083 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbZLMX6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:33 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, lenb@kernel.org,
       torvalds@linux-foundation.org, linux@arm.linux.org.uk,
       akpm@linux-foundation.org, pavel@ucw.cz
Subject: [PATCH 00/10] Constify struct platform_suspend_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:16 +0100
Message-Id: <cover.1260663003.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
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
kset_uevent_ops
lock_manager_operations
microcode_ops
mtrr_ops
neigh_ops
nlmsvc_binding
pci_raw_ops
platform_hibernation_ops
* platform_suspend_ops
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

 arch/arm/mach-at91/pm.c                   |    2 +-
 arch/arm/mach-omap1/pm.c                  |    2 +-
 arch/arm/mach-omap2/pm24xx.c              |    2 +-
 arch/arm/mach-omap2/pm34xx.c              |    2 +-
 arch/arm/mach-pnx4008/pm.c                |    2 +-
 arch/arm/mach-pxa/pm.c                    |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c            |    2 +-
 arch/arm/mach-sa1100/pm.c                 |    2 +-
 arch/arm/plat-s3c/pm.c                    |    2 +-
 arch/avr32/mach-at32ap/pm.c               |    2 +-
 arch/blackfin/mach-common/pm.c            |    2 +-
 arch/mips/alchemy/devboards/pm.c          |    2 +-
 arch/powerpc/platforms/52xx/lite5200_pm.c |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pm.c  |    2 +-
 arch/powerpc/platforms/83xx/suspend.c     |    2 +-
 arch/sh/boards/mach-hp6xx/pm.c            |    2 +-
 arch/sh/kernel/cpu/shmobile/pm.c          |    2 +-
 drivers/acpi/sleep.c                      |    4 ++--
 drivers/macintosh/via-pmu.c               |    2 +-
 include/linux/suspend.h                   |   22 +++++++++++-----------
 kernel/power/suspend.c                    |    4 ++--
 21 files changed, 33 insertions(+), 33 deletions(-)

