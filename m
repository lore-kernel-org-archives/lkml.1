Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbYFPI3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbYFPI3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYFPI3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:29:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:21048 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYFPI3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=LbiEUkweRMooIxHi248trs5MS32zaOwKJRbQH6+VuBQ5AUoAivQeylDCt0b9o/OicV
         1ZLeZWgjpRLG9sTvLpuoYip73Zw7IAcbJh9g07fwKYdwbTeWkS4L7DS/V2PYSYAuRTMb
         sTJ9QxU/l9dM1cgVZ4pxDBqEE1Duf+VUS5kUM=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: linux-kernel@vger.kernel.org, dwmw2@infradead.org, sam@ravnborg.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH v2] export linux/a.out.h
Date: Mon, 16 Jun 2008 10:29:33 +0200
Message-Id: <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213565555.26255.522.camel@pmac.infradead.org>
References: <1213565555.26255.522.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export linux/a.out.h like we do for asm/a.out.h as some applications needs
it (E.G. valgrind). One minor complication is that the content is protected
by an CONFIG_ARCH_SUPPORTS_AOUT ifdef, so get rid of it.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 include/linux/Kbuild  |    3 +++
 include/linux/a.out.h |    8 --------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 93b9885..e61f1f9 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -162,6 +162,9 @@ header-y += video_encoder.h
 header-y += videotext.h
 header-y += x25.h
 
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
+unifdef-y += a.out.h
+endif
 unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index 208f4e8..e86dfca 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -1,8 +1,6 @@
 #ifndef __A_OUT_GNU_H__
 #define __A_OUT_GNU_H__
 
-#ifdef CONFIG_ARCH_SUPPORTS_AOUT
-
 #define __GNU_EXEC_MACROS__
 
 #ifndef __STRUCT_EXEC_OVERRIDE__
@@ -277,10 +275,4 @@ struct relocation_info
 #endif /* no N_RELOCATION_INFO_DECLARED.  */
 
 #endif /*__ASSEMBLY__ */
-#else /* CONFIG_ARCH_SUPPORTS_AOUT */
-#ifndef __ASSEMBLY__
-struct exec {
-};
-#endif
-#endif /* CONFIG_ARCH_SUPPORTS_AOUT */
 #endif /* __A_OUT_GNU_H__ */
-- 
1.5.5.1

