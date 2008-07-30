Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbYG3LaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbYG3LaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYG3LaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:30:09 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:63830 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYG3LaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=X1aYF6puTqGHDjKE5+vPWVNTkQvdwzQ2vpOxEr/OAXdsdVDCPYXOZDPNE0ZF5nALLL
         rHwGdu+IUToflzGjBUL/pLkbdb1mqyjsklkDK8ACmiBbIh7tOVlYarE2/mHWnXATY6Rg
         h1R++OO86VHZlTz03mIgdF3lIsmvHh3iqKkTU=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] x86: wrong register was used in align macro
Date: Wed, 30 Jul 2008 13:30:14 +0200
Message-ID: <m3sktr6249.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New ALIGN_DESTINATION macro has sad typo: r8d register was used instead
of ecx in fixup section. This can be considered as a regression.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index dfdf428..f118c11 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -52,7 +52,7 @@
 	jnz 100b
 102:
 	.section .fixup,"ax"
-103:	addl %r8d,%edx			/* ecx is zerorest also */
+103:	addl %ecx,%edx			/* ecx is zerorest also */
 	jmp copy_user_handle_tail
 	.previous
 
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index 40e0e30..108ad1c 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -32,7 +32,7 @@
 	jnz 100b
 102:
 	.section .fixup,"ax"
-103:	addl %r8d,%edx			/* ecx is zerorest also */
+103:	addl %ecx,%edx			/* ecx is zerorest also */
 	jmp copy_user_handle_tail
 	.previous
 

-- 
wbr, Vitaly
