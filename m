Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbYASEWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbYASEWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 23:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbYASEW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 23:22:29 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:27662 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbYASEW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 23:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G8SE2NUHKwUTLGKJdr0Y4bM/l2TVRuU1JstwkKXC9MA3Nm4matzgYPLf504i3Mi2Q5suGNyg/4Sf06Oo9iJHq9mGpJTMB9nmqcqOz962GQNEt8lauwIXXr8CsYLvbLdGZ+ZyaczfkK0cYR+cUuKGyGxXbqrxzhrQrs+6mMYjBMM=
Subject: [PATCH] x86: Unify printk strings in fault_32|64.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 20:22:29 -0800
Message-Id: <1200716549.5724.150.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the address of the faulting library missed removing a
line ending from X86_32.

Also update the shorter printk format for X86_32 in fault_64.c
to make it easier to se the remaining differences.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, trivial printk update after Andi's patches.

 arch/x86/mm/fault_32.c |    2 +-
 arch/x86/mm/fault_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 793e830..0bd2417 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -589,7 +589,7 @@ bad_area_nosemaphore:
 		    printk_ratelimit()) {
 			printk(
 #ifdef CONFIG_X86_32
-			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx\n",
+			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx",
 #else
 			"%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx",
 #endif
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 9270a7d..9ac449e 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -591,7 +591,7 @@ bad_area_nosemaphore:
 		    printk_ratelimit()) {
 			printk(
 #ifdef CONFIG_X86_32
-			"%s%s[%d]: segfault at %08lx ip %08lx sp %08lx error %lx\n",
+			"%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx",
 #else
 			"%s%s[%d]: segfault at %lx ip %lx sp %lx error %lx",
 #endif
-- 
1.5.4.rc3.1118.gf6754c



