Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZEZJRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZEZJRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZEZJQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:16:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37423 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbZEZJQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:16:01 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 7/7] Blackfin: fix strncmp.o build error
Date: Tue, 26 May 2009 05:15:56 -0400
Message-Id: <1243329356-12644-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
References: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some more fallout of the string changes:

  CC      arch/blackfin/lib/strncmp.o
In file included from include/linux/bitmap.h:9,
                 from include/linux/nodemask.h:90,
                 from include/linux/mmzone.h:17,
                 from include/linux/gfp.h:5,
                 from include/linux/kmod.h:23,
                 from include/linux/module.h:14,
                 from arch/blackfin/lib/strncmp.c:14:
include/linux/string.h: In function ‘strstarts’:
include/linux/string.h:132: error: implicit declaration of function ‘strncmp’
make[1]: *** [arch/blackfin/lib/strncmp.o] Error 1

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/blackfin/lib/strncmp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/lib/strncmp.c b/arch/blackfin/lib/strncmp.c
index 2aaae78..46518b1 100644
--- a/arch/blackfin/lib/strncmp.c
+++ b/arch/blackfin/lib/strncmp.c
@@ -8,9 +8,8 @@
 
 #define strncmp __inline_strncmp
 #include <asm/string.h>
-#undef strncmp
-
 #include <linux/module.h>
+#undef strncmp
 
 int strncmp(const char *cs, const char *ct, size_t count)
 {
-- 
1.6.3.1

