Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZIKJ0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZIKJ0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZIKJ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:26:09 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:44226 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZIKJ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BHQQ4AMoIJsde/0VinZbGwAYUJ+L/x2y2KET0rVwIeL+u+Hej0a2ZAiDzDZwa1Dnrw
         lWdXxXPe22tE2hATMtzGUr5j7fX3AAVyXAUiQnim7Z8M34vMHq1ZtRIa4Zzdh2vCPUsC
         fZE+WYV+vrWABIdqUP8/htljRYzppwmYJtsmw=
From: Wu <wuzhangjin@gmail.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, huhb@lemote.com,
       zhangfx@lemote.com, Wu Zhangjin <wuzhangjin@gmail.com>,
       Yan Hua <yanh@lemote.com>
Subject: [PATCH] ide: fixup for fujitsu disk
Date: Fri, 11 Sep 2009 17:25:58 +0800
Message-Id: <1252661158-8219-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch will fix the following problem on Yeeloong netbook with
fujitsu disk.

irq 14: nobody cared (try booting with the "irqpoll" option)
Call Trace:
[<ffffffff8020d438>] dump_stack+0x8/0x40
[<ffffffff8027ec64>] __report_bad_irq+0x58/0xe4
[<ffffffff8027ee6c>] note_interrupt+0x17c/0x23c
[<ffffffff8027f9b8>] handle_level_irq+0xcc/0x134
[<ffffffff802125b0>] mach_irq_dispatch+0xb8/0x1e0
[<ffffffff8020041c>] ret_from_irq+0x0/0x4
[<ffffffff8029e678>] free_hot_cold_page+0x224/0x2a0
[<ffffffff8026f794>] swsusp_free+0xb0/0x14c
[<ffffffff8026ec08>] hibernate+0x198/0x218
[<ffffffff8026cfa8>] state_store+0x90/0x138
[<ffffffff8032b5a4>] sysfs_write_file+0x130/0x194
[<ffffffff802c94fc>] vfs_write+0xb8/0x180
[<ffffffff802c96b8>] SyS_write+0x50/0x98
[<ffffffff80203fd8>] handle_sys+0x158/0x174

handlers:
[<ffffffff80429670>] (ide_intr+0x0/0x300)
Disabling IRQ #14

References:

1. commit 1fde02e7146d4a1bab80fd1506f9018fe71e8521 of
git://dev.lemote.com/linux_loongson.git
2. 8bc1e5aa06a2a9a425c4a6795fc564cba1521487 (ide: respect quirk_drives[]
list on all controllers)

Signed-off-by: Yan Hua <yanh@lemote.com>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/ide/ide-iops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 2892b24..821af66 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -292,6 +292,7 @@ static const char *nien_quirk_list[] = {
 	"QUANTUM FIREBALLP KX27.3",
 	"QUANTUM FIREBALLP LM20.4",
 	"QUANTUM FIREBALLP LM20.5",
+	"FUJITSU MHZ2160BH G2",
 	NULL
 };
 
-- 
1.6.2.1

