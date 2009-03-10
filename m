Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZCJOTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZCJOTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZCJOTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:19:15 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:40689 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbZCJOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FeS3d+2x0yljHYf3TXEeV+7NGFTW+wsQvW914Uj0USQTuppWvnECVEcF7QvEW70muB
         HbVf6y9gqKHq99TSXTOoFlorfbEuKyq0Qg02swgtmN2RnHBeRmg2A8VDftVr5vWxes4l
         icoxtrzk79d4G6R2fVkMF3MjGzSPwYWacGbF0=
Date: Tue, 10 Mar 2009 22:19:38 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>
Subject: [Patch] uml: fix WARNING: vmlinux: 'memcpy' exported twice.
Message-ID: <20090310141938.GE3157@hack>
References: <49AFC206.9080004@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AFC206.9080004@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patch fixes the following warning on x86_64:

LD vmlinux.o
MODPOST vmlinux.o
WARNING: vmlinux: 'memcpy' exported twice. Previous export was in
vmlinux

Reported-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Tested-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Dike <jdike@addtoit.com>

---
diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
index 74f49bb..89b48a1 100644
--- a/arch/um/os-Linux/user_syms.c
+++ b/arch/um/os-Linux/user_syms.c
@@ -14,7 +14,6 @@
 #undef memset
 
 extern size_t strlen(const char *);
-extern void *memcpy(void *, const void *, size_t);
 extern void *memmove(void *, const void *, size_t);
 extern void *memset(void *, int, size_t);
 extern int printf(const char *, ...);
@@ -24,7 +23,11 @@ extern int printf(const char *, ...);
 EXPORT_SYMBOL(strstr);
 #endif
 
+#ifndef __x86_64__
+extern void *memcpy(void *, const void *, size_t);
 EXPORT_SYMBOL(memcpy);
+#endif
+
 EXPORT_SYMBOL(memmove);
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(printf);

 
