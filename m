Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYFOVHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYFOVHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 17:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYFOVHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 17:07:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:21673 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYFOVHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 17:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=pIFTPJRRtAHZm2CHN47xvOhF/aXs77RztS/SP1DRdVq1ZaGwC/kVBPTQdUNlZvhl58
         IStP04VF/jV5T7xzIUfS7i3CAcDavvs5TCqZVxsw6GqEIYsH+rmKzFuncE/hbX+kXCVu
         CQowDiU30NnbwxD0CwCE6S1ej1BHQMUWNX39I=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: linux-kernel@vger.kernel.org, dwmw2@infradead.org, sam@ravnborg.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] export linux/a.out.h
Date: Sun, 15 Jun 2008 23:07:01 +0200
Message-Id: <1213564021-5195-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export linux/a.out.h like we do for asm/a.out.h as some applications needs
it (E.G. valgrind). One minor complication is that the interesting stuff is
protected by an CONFIG_ARCH_SUPPORTS_AOUT ifdef, so make sure that gets
defined for unifdef.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 include/linux/Kbuild |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 93b9885..d998fc7 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -162,6 +162,8 @@ header-y += video_encoder.h
 header-y += videotext.h
 header-y += x25.h
 
+UNIFDEF += -DCONFIG_ARCH_SUPPORTS_AOUT
+unifdef-y += a.out.h
 unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
-- 
1.5.5.1

