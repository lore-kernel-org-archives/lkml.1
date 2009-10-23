Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbZJWXj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbZJWXj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZJWXj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:39:28 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33866 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZJWXj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lPWjlP0c3txPZg3tByuAm1BsiktK/BhubrkLuF99Q5UdFFslhx5EZG7hp1v0LOQ0DD
         FECUcu+bMbssT8dX2Si8if0toNwz60tKZnaEt0h9fE/AwTQxUoo+z5o+GvQuSC/sGFAp
         LK1vLi4VAmwQtLh9cxVx2ni3yb/1+WDE/6+B4=
From: Alexander Potashev <aspotashev@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alexander Potashev <aspotashev@gmail.com>
Subject: [PATCH] x86, boot: simplify setting of the PAE bit
Date: Sat, 24 Oct 2009 03:37:23 +0400
Message-Id: <1256341043-4928-1-git-send-email-aspotashev@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A single 'movl' is shorter than the 'xorl'-'orl' pair.
No behaviour change.

Signed-off-by: Alexander Potashev <aspotashev@gmail.com>
---
 arch/x86/boot/compressed/head_64.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 077e1b6..faff0dc 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -107,8 +107,7 @@ ENTRY(startup_32)
 	lgdt	gdt(%ebp)
 
 	/* Enable PAE mode */
-	xorl	%eax, %eax
-	orl	$(X86_CR4_PAE), %eax
+	movl	$(X86_CR4_PAE), %eax
 	movl	%eax, %cr4
 
  /*
-- 
1.6.5.1

