Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbZEZX5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbZEZX5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZEZXyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38602 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbZEZXyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:44 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/31] x86: MCE: Rename and align out2 label
Date: Wed, 27 May 2009 01:54:12 +0200
Message-Id: <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Impact: Minor cleanup, no functional changes

There's only a single out path in do_machine_check now, so rename the label from
out2 to out.  Also align it at the first column.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2e3ceed..1ce7b55 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -366,9 +366,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	if (notify_die(DIE_NMI, "machine check", regs, error_code,
 			   18, SIGKILL) == NOTIFY_STOP)
-		goto out2;
+		goto out;
 	if (!banks)
-		goto out2;
+		goto out;
 
 	mce_setup(&m);
 
@@ -504,7 +504,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 			mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
- out2:
+out:
 	atomic_dec(&mce_entry);
 	sync_core();
 }
-- 
1.6.0.2

