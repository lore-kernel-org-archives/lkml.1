Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504Ab0AECSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab0AECSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256Ab0AECSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:18:54 -0500
Received: from ozlabs.org ([203.10.76.45]:51140 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0AECSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:18:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Revert "x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium"
Date: Tue, 5 Jan 2010 12:48:49 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "H. Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001051248.49700.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ae1b22f6e46c03cede7cea234d0bf2253b4261cf.
    
As Linus said in 982d007a6ee: "There was something really messy about
cmpxchg8b and clone CPU's, so if you enable it on other CPUs later, do it
carefully."
    
This breaks lguest for those configs, but we can fix that by emulating
if we have to.
    
Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=14884
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: stable@kernel.org
---
 arch/x86/Kconfig.cpu |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 08e442b..f20ddf8 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -396,7 +396,7 @@ config X86_TSC
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on !M386 && !M486
+	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
