Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbYGAVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbYGAVnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYGAVnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:43:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbYGAVnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:43:23 -0400
From: Jeremy Katz <katzj@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: davej@redhat.com, herbert@gondor.apana.org.au,
       Jeremy Katz <katzj@redhat.com>
Subject: [PATCH] Make loading padlock modules quieter when hardware isn't available
Date: Tue,  1 Jul 2008 17:41:35 -0400
Message-Id: <1214948495-19849-1-git-send-email-katzj@redhat.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When loading aes or sha256 via the module aliases, the padlock modules
also try to get loaded.  Make the error message for them not being
present only be a NOTICE rather than an ERROR so that use of 'quiet'
will suppress the messages

Signed-off-by: Jeremy Katz <katzj@redhat.com>
---
 drivers/crypto/padlock-aes.c |    4 ++--
 drivers/crypto/padlock-sha.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index bb30eb9..54a2a16 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -385,12 +385,12 @@ static int __init padlock_init(void)
 	int ret;
 
 	if (!cpu_has_xcrypt) {
-		printk(KERN_ERR PFX "VIA PadLock not detected.\n");
+		printk(KERN_NOTICE PFX "VIA PadLock not detected.\n");
 		return -ENODEV;
 	}
 
 	if (!cpu_has_xcrypt_enabled) {
-		printk(KERN_ERR PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
+		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index c666b4e..40d5680 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -254,12 +254,12 @@ static int __init padlock_init(void)
 	int rc = -ENODEV;
 
 	if (!cpu_has_phe) {
-		printk(KERN_ERR PFX "VIA PadLock Hash Engine not detected.\n");
+		printk(KERN_NOTICE PFX "VIA PadLock Hash Engine not detected.\n");
 		return -ENODEV;
 	}
 
 	if (!cpu_has_phe_enabled) {
-		printk(KERN_ERR PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
+		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
 		return -ENODEV;
 	}
 
-- 
1.5.6

