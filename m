Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZLBRU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZLBRU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZLBRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:19:12 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:42297 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZLBRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:19:10 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>
Date: Wed,  2 Dec 2009 18:18:49 +0100
Message-Id: <1259774329-29663-12-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259774329-29663-11-git-send-email-giometti@linux.it>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
 <1259774329-29663-2-git-send-email-giometti@linux.it>
 <1259774329-29663-3-git-send-email-giometti@linux.it>
 <1259774329-29663-4-git-send-email-giometti@linux.it>
 <1259774329-29663-5-git-send-email-giometti@linux.it>
 <1259774329-29663-6-git-send-email-giometti@linux.it>
 <1259774329-29663-7-git-send-email-giometti@linux.it>
 <1259774329-29663-8-git-send-email-giometti@linux.it>
 <1259774329-29663-9-git-send-email-giometti@linux.it>
 <1259774329-29663-10-git-send-email-giometti@linux.it>
 <1259774329-29663-11-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 11/11] arm: add low level IRQ timestamps recording for arm platforms.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 arch/arm/kernel/irq.c |    2 ++
 drivers/pps/Kconfig   |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index c9a8619..4708db2 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -109,6 +109,8 @@ asmlinkage void __exception asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 
 	irq_enter();
 
+	irq_save_ts(irq);
+
 	/*
 	 * Some hardware gives randomly wrong interrupts.  Rather
 	 * than crashing, do something sensible.
diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 6e8a2aa..dcef32e 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -24,7 +24,7 @@ config PPS
 
 config PPS_IRQ_EVENTS
 	bool "Use low level IRQ timestamps"
-	depends on PPS && (X86_32 || X86_64)
+	depends on PPS && (X86_32 || X86_64 || ARM)
 	default no
 	help
 	  Say Y here if you wish using low level IRQ timestamps to register
-- 
1.6.3.3

