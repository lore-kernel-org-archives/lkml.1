Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbYHVPVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbYHVPVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYHVPU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:20:57 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51195 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYHVPU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:20:56 -0400
Date: Fri, 22 Aug 2008 18:20:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh64: re-add the __strnlen_user() prototype
Message-ID: <20080822152029.GA26762@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 42fd3b142d8867f5b58d6fb75592cd20fd654c1b
(sh: Initial consolidation of the _32/_64 uaccess split.)
mistakenly removed the sh64 __strnlen_user() prototype,
resulting in the following compile error:

<--  snip  -->

...
  CC      init/main.o
In file included from include/linux/poll.h:13,
                 from include/linux/rtc.h:113,
                 from include/linux/efi.h:19,
                 from init/main.c:43:
arch/sh/include/asm/uaccess.h: In function 'strnlen_user':
arch/sh/include/asm/uaccess.h:213: error: implicit declaration of function '__strnlen_user'
...
make[2]: *** [init/main.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
5f4815210f1a81795eb911141bd24feb2bac8521 
diff --git a/arch/sh/include/asm/uaccess_64.h b/arch/sh/include/asm/uaccess_64.h
index 81b3d51..5580fd4 100644
--- a/arch/sh/include/asm/uaccess_64.h
+++ b/arch/sh/include/asm/uaccess_64.h
@@ -76,4 +76,6 @@ extern long __put_user_asm_l(void *, long);
 extern long __put_user_asm_q(void *, long);
 extern void __put_user_unknown(void);
 
+extern long __strnlen_user(const char *__s, long __n);
+
 #endif /* __ASM_SH_UACCESS_64_H */

