Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbZKYQR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbZKYQR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZKYQR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:17:29 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:37978 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZKYQR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:17:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HGE2qli8Q/U512nRQR5ZZxjVnkbhuPhNUj+au69unEVovCjVsV7P3LR1mJVUIlOBYF
         8ZgI5xOOrfU1gWRJeSYt2z+RVjGlO1ZMuPRjjXlAA/1J1k2ECxbM5NHRHCZjcpzPUW1/
         Tt+aMrY5JAzArIcUq7kz2nvTD877TppIdhASQ=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Tim Blechmann <tim@klingt.org>
Subject: [PATCH] x86, 64-bit: Set data segments to null after switching to 64-bit mode
Date: Wed, 25 Nov 2009 11:17:36 -0500
Message-Id: <1259165856-3512-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <73c1f2160911250753q6c64791exabd79e994b315076@mail.gmail.com>
References: <73c1f2160911250753q6c64791exabd79e994b315076@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents kernel threads from inheriting non-null segment selectors,
and causing optimizations in __switch_to() to be ineffective.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/head_64.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 780cd92..22db86a 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -212,8 +212,8 @@ ENTRY(secondary_startup_64)
 	 */
 	lgdt	early_gdt_descr(%rip)
 
-	/* set up data segments. actually 0 would do too */
-	movl $__KERNEL_DS,%eax
+	/* set up data segments */
+	xorl %eax,%eax
 	movl %eax,%ds
 	movl %eax,%ss
 	movl %eax,%es
-- 
1.6.5.2

