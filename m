Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0CIRTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:19:42 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43931 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0CIRTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:19:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O4b1L1zn0hEsqd9PqPfDUppr5b1vo/JqNCX6eKXzYwPipD8OO1BsrfhbNeGfs3L4w0
         +2K5W9NcTtUj290a5fXEcfnUj1qqYHDm+46sR6U6CfVyNfM5/4JOyN8FQ8QTCvduf3mE
         XWGRJNBA+Voi7c7BRxQlkjbBa7FmkK18D/o9E=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Greg KH <gregkh@suse.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzhangjin@gmail.com>, Zhang Le <r0bertz@gentoo.org>,
       Wu Zhangjin <wuzj@lemote.com>
Subject: [PATCH 2/3] Loongson-2F: Enable fixups of binutils 2.20.1
Date: Wed, 10 Mar 2010 01:12:32 +0800
Message-Id: <6ca9906a5469bc5cc4aafeac6f90ab3798a5a837.1268153722.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1268153722.git.wuzhangjin@gmail.com>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1268153722.git.wuzhangjin@gmail.com>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

As the "Fixups of Loongson2F" patch[1] to binutils have been applied
into binutils 2.20.1. It's time to enable the options provided by the
patch to compile the kernel.

Without these fixups, the system will hang unexpectedly for the bug of
processor.

To learn more about these fixups, please refer to the following
references.

[1] "Fixups of Loongson2F" patch for binutils(actually for gas)
http://sourceware.org/ml/binutils/2009-11/msg00387.html
[2] Chapter 15 of "Loongson2F User Manual"(Chinese Version)
http://www.loongson.cn/uploadfile/file/200808211
[3] English Version of the above chapter 15
http://groups.google.com.hk/group/loongson-dev/msg/e0d2e220958f10a6?dmode=source

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 2f2eac2..5ae342e 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -135,7 +135,9 @@ cflags-$(CONFIG_CPU_LOONGSON2)	+= -Wa,--trap
 cflags-$(CONFIG_CPU_LOONGSON2E) += \
 	$(call cc-option,-march=loongson2e,-march=r4600)
 cflags-$(CONFIG_CPU_LOONGSON2F) += \
-	$(call cc-option,-march=loongson2f,-march=r4600)
+	$(call cc-option,-march=loongson2f,-march=r4600) \
+	$(call as-option,-Wa$(comma)-mfix-loongson2f-nop,) \
+	$(call as-option,-Wa$(comma)-mfix-loongson2f-jump,)
 
 cflags-$(CONFIG_CPU_MIPS32_R1)	+= $(call cc-option,-march=mips32,-mips32 -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS32) \
 			-Wa,-mips32 -Wa,--trap
-- 
1.7.0.1

