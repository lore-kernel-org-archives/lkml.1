Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYAZWyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYAZWyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYAZWya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:54:30 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:44597 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbYAZWy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:54:29 -0500
Date: Sat, 26 Jan 2008 23:54:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] [SPARC/SPARC64] fix usage of .section .sched.text in assembler code
Message-ID: <20080126225439.GB27215@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ld will generate an unique named section when assembler do not
use "ax" but gcc does. Add the misisng annotation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/sparc/lib/rwsem.S   |    2 +-
 arch/sparc64/lib/rwsem.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/lib/rwsem.S b/arch/sparc/lib/rwsem.S
index 2065774..f406b1f 100644
--- a/arch/sparc/lib/rwsem.S
+++ b/arch/sparc/lib/rwsem.S
@@ -7,7 +7,7 @@
 #include <asm/ptrace.h>
 #include <asm/psr.h>
 
-	.section .sched.text
+	.section .sched.text, "ax"
 	.align	4
 
 	.globl		___down_read
diff --git a/arch/sparc64/lib/rwsem.S b/arch/sparc64/lib/rwsem.S
index 75f0e6b..1a4cc56 100644
--- a/arch/sparc64/lib/rwsem.S
+++ b/arch/sparc64/lib/rwsem.S
@@ -6,7 +6,7 @@
 
 #include <asm/rwsem-const.h>
 
-	.section	.sched.text
+	.section	.sched.text, "ax"
 
 	.globl		__down_read
 __down_read:
-- 
1.5.4.rc3.14.g44397

