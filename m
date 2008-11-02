Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYKBQEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYKBQEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 11:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYKBQE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 11:04:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:39422 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYKBQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 11:04:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=BnA1NTY+BYhmN6QqbLvUJL82XHuL89LC6zHkJFFhCoVYGYM2P6/9pt8VlZUIkOqyeh
         2zdLx6IFCeRG0xm81iDi+5PJVuxt4VkLgBEvYxz9ouN0ghfbNtR3XpAp6gz02S1dicWr
         z8iJ835lsJKUIfptPxupEMjbKyHErzs0/buYk=
From: Matt Fleming <mjf@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, venkatesh.pallipadi@intel.com,
       Matt Fleming <mjf@gentoo.org>
Subject: [PATCH 2/3] HPET: Enter hpet_interrupt_handler with interrupts disabled
Date: Sun,  2 Nov 2008 16:04:19 +0000
Message-Id: <1225641860-6120-2-git-send-email-mjf@gentoo.org>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1225641860-6120-1-git-send-email-mjf@gentoo.org>
References: <1225641860-6120-1-git-send-email-mjf@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions that may be called from this handler require that
interrupts are disabled.

Signed-off-by: Matt Fleming <mjf@gentoo.org>
---
 arch/x86/kernel/hpet.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index f10f946..c28fff2 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -445,7 +445,8 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 {
 
 	if (request_irq(dev->irq, hpet_interrupt_handler,
-			IRQF_SHARED|IRQF_NOBALANCING, dev->name, dev))
+			IRQF_DISABLED|IRQF_SHARED|IRQF_NOBALANCING,
+			dev->name, dev))
 		return -1;
 
 	disable_irq(dev->irq);
-- 
1.5.6.4

