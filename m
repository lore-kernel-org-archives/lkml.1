Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbYJRQc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbYJRQc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 12:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYJRQcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 12:32:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:6785 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYJRQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 12:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=jA5m0Ch5VYx1PG+MrgpUpt6cG6N4HZxFPj4LM84xvbMyVjrhoZm0/g4+sbC6VUGYQg
         CcwgyO3Lw0dFsG8/PjbvMmUQ0PvsZvg7nvSac3fgsKeoToU7PFtrwEM+eeqwDOa3Srdl
         CWz0rTYjVnAJ9KhYwJLOtZ9pkSvjrQDJtjtPw=
Message-ID: <48FA0FAD.4010308@gmail.com>
Date: Sat, 18 Oct 2008 18:32:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparc: correct section of current_pc()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest mainline gives this section mismatch on sparc:

The function current_pc() references
the variable __init no_sun4u_here.
This is often because current_pc lacks a __init 
annotation or the annotation of no_sun4u_here is wrong.

Since current_pc() is used only in early time, it is correct to
put it in .init section.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/arch/sparc/kernel/head.S b/arch/sparc/kernel/head.S
index 2d325fd..2fe2c11 100644
--- a/arch/sparc/kernel/head.S
+++ b/arch/sparc/kernel/head.S
@@ -465,6 +465,7 @@ gokernel:
 		mov	%o7, %g4		! Save %o7
 
 		/* Jump to it, and pray... */
+		__INIT
 current_pc:
 		call	1f
 		 nop
