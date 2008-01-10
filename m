Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYAJTpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYAJTpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbYAJTpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:45:30 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:54997 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYAJTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:45:29 -0500
Date: Thu, 10 Jan 2008 14:45:05 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 - Fencepost errors in compat ptrace
Message-ID: <20080110194505.GA8054@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compat PTRACE_SETREGS and PTRACE_GETREGS are verifying_area
one word too few.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/x86/ia32/ptrace32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ptrace32.c b/arch/x86/ia32/ptrace32.c
index 4a233ad..e5d4eff 100644
--- a/arch/x86/ia32/ptrace32.c
+++ b/arch/x86/ia32/ptrace32.c
@@ -312,7 +312,7 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 
 	case PTRACE_GETREGS: { /* Get all gp regs from the child. */
 		int i;
-	  	if (!access_ok(VERIFY_WRITE, datap, 16*4)) {
+	  	if (!access_ok(VERIFY_WRITE, datap, 17*4)) {
 			ret = -EIO;
 			break;
 		}
@@ -328,7 +328,7 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_SETREGS: { /* Set all gp regs in the child. */
 		unsigned long tmp;
 		int i;
-	  	if (!access_ok(VERIFY_READ, datap, 16*4)) {
+	  	if (!access_ok(VERIFY_READ, datap, 17*4)) {
 			ret = -EIO;
 			break;
 		}
