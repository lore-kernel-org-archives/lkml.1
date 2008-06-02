Return-Path: <linux-kernel-owner+w=401wt.eu-S1761903AbYFBNwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903AbYFBNwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbYFBNv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:51:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbYFBNv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:51:57 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Olaf Dabrunz <od@suse.de>, Stefan Assmann <sassmann@suse.de>
Subject: [PATCH 6/7] disable pci legacy boot irq quirks on noapic boot
Date: Mon,  2 Jun 2008 14:45:06 +0200
Message-Id: <12124107071424-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@suse.de>

Don't enable pci boot irq quirks when falling back to pic, this would
break interrupt routing.

Signed-off-by: Stefan Assmann <sassmann@suse.de>
Signed-off-by: Olaf Dabrunz <od@suse.de>
---
 include/asm-x86/io_apic.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index 5b1292f..461771c 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -151,8 +151,11 @@ extern int skip_ioapic_setup;
 /* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
 extern int timer_through_8259;
 
+extern int nobootirqquirk;
+
 static inline void disable_ioapic_setup(void)
 {
+	nobootirqquirk = 1;
 	skip_ioapic_setup = 1;
 }
 
-- 
1.5.2.4

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

