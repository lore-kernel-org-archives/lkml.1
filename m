Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYDLJvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYDLJvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 05:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbYDLJvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 05:51:18 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:16084 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbYDLJvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 05:51:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=H9Bwo/a4i/q+IRjNnzybvkaq0mVT0jtD9YTU1L549LMiR2aSpbLDz2aWDpbDaiLPStMEfJ2t/TZjP9tI+0grWKG5piGVCyvdj1sJ/c9bxG3E5WXw8d+/fcn+yrSpT476+yzdK6W9pFVnJkUQUd+OSXqI/26Gw67iIT84Hg59vbE=
Date: Sat, 12 Apr 2008 17:47:33 +0800 (CST)
Message-Id: <20080412.174733.133433510.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] uml: compile error fix
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=gb2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3C9kwEB032721


This patch fixes this error:

  CC      arch/um/kernel/smp.o
In file included from /home/wangcong/projects/linux-2.6/arch/um/kernel/smp.c:9:
include2/asm/tlb.h: In function ¡®tlb_remove_page¡¯:
include2/asm/tlb.h:101: error: implicit declaration of function ¡®page_cache_release¡¯
make[2]: *** [arch/um/kernel/smp.o] Error 1
make[1]: *** [arch/um/kernel] Error 2
make: *** [sub-make] Error 2

And since including <linux/pagemap.h> in <linux/swap.h> will break sparc,
we add this #include in uml's own header.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/include/asm-um/tlb.h b/include/asm-um/tlb.h
index 39fc475..5240fa1 100644
--- a/include/asm-um/tlb.h
+++ b/include/asm-um/tlb.h
@@ -1,6 +1,7 @@
 #ifndef __UM_TLB_H
 #define __UM_TLB_H
 
+#include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <asm/percpu.h>
 #include <asm/pgalloc.h>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
