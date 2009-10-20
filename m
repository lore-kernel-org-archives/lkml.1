Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZJTTjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZJTTjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZJTTjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:39:46 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34030 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZJTTjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=bUvrd8axDpag3i3vBki/GkX7laR73lcC1ceDSmCBTPnEqWDpcvhLg195VQONGWfiHi
         +CSGcfJkQyppSBIlLA2+VvGK+QuAetzaMGc0DjCJOB5XM29ENSLX6pRXnW/ZvQpYiG7z
         WxnKn/1Y/KUQ/8MM9K8JV0JVRjvZkmTw+4654=
From: Alessio Igor Bogani <abogani@texware.it>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH -tip] rt: Fix the follow oops
Date: Tue, 20 Oct 2009 21:39:18 +0200
Message-Id: <1256067558-9805-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    8.594883] kernel BUG at /build/buildd/linux-rt-2.6.31/mm/vmalloc.c:1303!
[    8.594886] invalid opcode: 0000 [#1] PREEMPT SMP
[    8.594890] last sysfs file: /sys/devices/pci0000:00/0000:00:08.0/host0/target0:0:0/0:0:0:0/block/sda/uevent
[    8.594893] CPU 1
[    8.594895] Modules linked in: x_tables(+) ath snd_page_alloc amd64_edac_mod parport nvidia(P) asus_atk0110 cfg80211 i2c_nforce2 serio_raw edac_core k8temp joydev hid_logitech ff_memless usbhid forcedeth floppy
[    8.594911] Pid: 1454, comm: modprobe Tainted: P           2.6.31-9-rt #152-Ubuntu System Product Name
[    8.594914] RIP: 0010:[<ffffffff811077ec>]  [<ffffffff811077ec>] __vunmap+0xec/0x110
[    8.594923] RSP: 0018:ffff880075103e08  EFLAGS: 00010246
[    8.594925] RAX: ffff8800735acbc0 RBX: ffffc90011c9d000 RCX: 0000000000000001
[    8.594928] RDX: ffff8800754147c0 RSI: 0000000000000001 RDI: 0000000000000000
[    8.594930] RBP: ffff880075103e28 R08: 0000000000000000 R09: 000000000000000b
[    8.594932] R10: 0000000000000000 R11: 000000000000000a R12: ffff88007302f940
[    8.594935] R13: 0000000000000001 R14: ffffc90011ca1538 R15: ffffffffa0a93e10
[    8.594938] FS:  00007f12206876f0(0000) GS:ffff880001b53000(0000) knlGS:0000000000000000
[    8.594941] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    8.594943] CR2: 00007f12206a2000 CR3: 00000000731d5000 CR4: 00000000000006e0
[    8.594945] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    8.594948] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    8.594951] Process modprobe (pid: 1454, threadinfo ffff880075102000, task ffff8800754147c0)
[    8.594953] Stack:
[    8.594954]  ffff880075103e38 ffffffffa0a95600 ffffc90011c9d000 ffffc90011ca1680
[    8.594958] <0> ffff880075103e38 ffffffff81107865 ffff880075103f48 ffffffff810972bf
[    8.594962] <0> ffff880075103e58 ffffffffa0a95600 ffffc900000000d7 ffffc90011ca1d00
[    8.594966] Call Trace:
[    8.594971]  [<ffffffff81107865>] vfree+0x25/0x30
[    8.594976]  [<ffffffff810972bf>] load_module+0x104f/0x1150
[    8.594980]  [<ffffffff81097431>] sys_init_module+0x71/0x230
[    8.594985]  [<ffffffff81012102>] system_call_fastpath+0x16/0x1b
[    8.594987] Code: c7 f0 f3 6d 81 31 c0 e8 73 85 f5 ff 48 83 c4 08 5b 41 5c 41 5d c9 c3 0f 1f 84 00 00 00 00 00 49 8b 7c 24 20 e8 d6 0f 01 00 eb a9 <0f> 0b eb fe 48 89 d9 48 c7 c2 98 f4 6d 81 be 0a 05 00 00 48 c7
[    8.595017] RIP  [<ffffffff811077ec>] __vunmap+0xec/0x110
[    8.595020]  RSP <ffff880075103e08>

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/edac/edac_mc.c        |    4 ++--
 drivers/edac/edac_pci_sysfs.c |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 335b7eb..1cf05cd 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -588,7 +588,7 @@ static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
 	pg = pfn_to_page(page);
 
 	if (PageHighMem(pg))
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 
 	virt_addr = kmap_atomic(pg, KM_BOUNCE_READ);
 
@@ -599,7 +599,7 @@ static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
 	kunmap_atomic(virt_addr, KM_BOUNCE_READ);
 
 	if (PageHighMem(pg))
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 }
 
 /* FIXME - should return -1 */
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 422728c..451383f 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/sysdev.h>
 #include <linux/ctype.h>
+#include <linux/interrupt.h>
 
 #include "edac_core.h"
 #include "edac_module.h"
@@ -559,7 +560,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 	u8 header_type;
 
 	/* stop any interrupts until we can acquire the status */
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 
 	/* read the STATUS register on this device */
 	status = get_pci_parity_status(dev, 0);
@@ -567,7 +568,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 	/* read the device TYPE, looking for bridges */
 	pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
 
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	debugf4("PCI STATUS= 0x%04x %s\n", status, dev_name(&dev->dev));
 
-- 
1.6.3.3

