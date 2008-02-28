Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbYB1BAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbYB1BAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYB1A4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:50062 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761711AbYB1A43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=E9wR7Fwof5FzDCOUfb1mKKIlTACyEQI4Jcwy0n2IAgLX9fXVZlvguiS+2UkoNfKJOlIVyxoyBk1c6IRyTWGNGrqCS4dueRsPkBWHd36+6t/RQrRUDokGZCfDmeAHlqtfeiXxUP8PX0ZG9hgNfu/mIXRqGKnOthzIXyzf35d99b0=
Subject: [PATCH 12/12] sound: ca0106_mixer.c fix shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:10 -0800
Message-Id: <1204160170.20280.60.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the variable err to _err within the ADD_CTLS macro to avoid
shadowing the local variable.

sound/pci/ca0106/ca0106_mixer.c:710:2: warning: symbol 'err' shadows an earlier one
sound/pci/ca0106/ca0106_mixer.c:663:6: originally declared here
sound/pci/ca0106/ca0106_mixer.c:712:3: warning: symbol 'err' shadows an earlier one
sound/pci/ca0106/ca0106_mixer.c:663:6: originally declared here
sound/pci/ca0106/ca0106_mixer.c:721:3: warning: symbol 'err' shadows an earlier one
sound/pci/ca0106/ca0106_mixer.c:663:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/ca0106/ca0106_mixer.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/ca0106/ca0106_mixer.c b/sound/pci/ca0106/ca0106_mixer.c
index af73686..d366640 100644
--- a/sound/pci/ca0106/ca0106_mixer.c
+++ b/sound/pci/ca0106/ca0106_mixer.c
@@ -650,11 +650,11 @@ static int __devinit rename_ctl(struct snd_card *card, const char *src, const ch
 
 #define ADD_CTLS(emu, ctls)						\
 	do {								\
-		int i, err;						\
+		int i, _err;						\
 		for (i = 0; i < ARRAY_SIZE(ctls); i++) {		\
-			err = snd_ctl_add(card, snd_ctl_new1(&ctls[i], emu)); \
-			if (err < 0)					\
-				return err;				\
+			_err = snd_ctl_add(card, snd_ctl_new1(&ctls[i], emu)); \
+			if (_err < 0)					\
+				return _err;				\
 		}							\
 	} while (0)
 
-- 
1.5.4.3.342.g99e8

