Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbYB1A7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbYB1A7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYB1A4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:30 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:51661 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761624AbYB1A42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WR+yCi2pjMYPJE/ZkVTnZKFTga2a9tdZBVQVmNOAvXVPbGb7qZelFLGOtg/TtVc0IF6jXQpJqGzhE90JQjAmkz0Qpn1hAQet1mM9/RLlZvq+04zqbMD0Y17aVrgytXAiCobN3784n/O/TN0rti44aBr5Adby1Td+ONvfPRwWTyU=
Subject: [PATCH 11/12] sound: ca0106_main.c fix shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:09 -0800
Message-Id: <1204160169.20280.59.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change to intr_enable as per the two functions it is defined in.
sound/pci/ca0106/ca0106_main.c:438:15: warning: symbol 'enable' shadows an earlier one
sound/pci/ca0106/ca0106_main.c:159:12: originally declared here
sound/pci/ca0106/ca0106_main.c:449:15: warning: symbol 'enable' shadows an earlier one
sound/pci/ca0106/ca0106_main.c:159:12: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/ca0106/ca0106_main.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 176e0f0..3818249 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -435,22 +435,22 @@ int snd_ca0106_i2c_write(struct snd_ca0106 *emu,
 static void snd_ca0106_intr_enable(struct snd_ca0106 *emu, unsigned int intrenb)
 {
 	unsigned long flags;
-	unsigned int enable;
-  
+	unsigned int intr_enable;
+
 	spin_lock_irqsave(&emu->emu_lock, flags);
-	enable = inl(emu->port + INTE) | intrenb;
-	outl(enable, emu->port + INTE);
+	intr_enable = inl(emu->port + INTE) | intrenb;
+	outl(intr_enable, emu->port + INTE);
 	spin_unlock_irqrestore(&emu->emu_lock, flags);
 }
 
 static void snd_ca0106_intr_disable(struct snd_ca0106 *emu, unsigned int intrenb)
 {
 	unsigned long flags;
-	unsigned int enable;
-  
+	unsigned int intr_enable;
+
 	spin_lock_irqsave(&emu->emu_lock, flags);
-	enable = inl(emu->port + INTE) & ~intrenb;
-	outl(enable, emu->port + INTE);
+	intr_enable = inl(emu->port + INTE) & ~intrenb;
+	outl(intr_enable, emu->port + INTE);
 	spin_unlock_irqrestore(&emu->emu_lock, flags);
 }
 
-- 
1.5.4.3.342.g99e8


