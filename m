Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZEZXzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZEZXzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbZEZXyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38572 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbZEZXyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:41 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/31] x86: MCE: Synchronize core after machine check handling
Date: Wed, 27 May 2009 01:54:03 +0200
Message-Id: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Impact: Spec compliance

The example code in the IA32 SDM recommends to synchronize the CPU
after machine check handling. So do that here.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 87f8198..249e3cf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -328,6 +328,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 	 * Don't clear MCG_STATUS here because it's only defined for
 	 * exceptions.
 	 */
+
+	sync_core();
 }
 EXPORT_SYMBOL_GPL(machine_check_poll);
 
@@ -501,6 +503,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
  out2:
 	atomic_dec(&mce_entry);
+	sync_core();
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
 
-- 
1.6.0.2

