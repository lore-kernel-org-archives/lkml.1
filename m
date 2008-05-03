Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYECT1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYECT1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYECT1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:27:24 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48670 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbYECT1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:27:23 -0400
Date: Sat, 3 May 2008 22:26:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] fix asm-mips/types.h syntax error
Message-ID: <20080503192617.GQ5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit 23cf11ddb5099f8c7f7cb3eb154bff0faf31cae9
(mips: types: use <asm-generic/int-*.h> for the mips architecture):

<--  snip  -->

...
  CC      kernel/bounds.s
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/types.h:12,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/page-flags.h:8,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/bounds.c:9:
include2/asm/types.h:56:2: error: #endif without #if
make[2]: *** [kernel/bounds.s] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
5de735b6b9037ad6b8a30ef51f4bd8e011954144 diff --git a/include/asm-mips/types.h b/include/asm-mips/types.h
index 7a2ee4f..bcbb8d6 100644
--- a/include/asm-mips/types.h
+++ b/include/asm-mips/types.h
@@ -19,8 +19,6 @@
 
 typedef unsigned short umode_t;
 
-#endif
-
 #endif /* __ASSEMBLY__ */
 
 /*

