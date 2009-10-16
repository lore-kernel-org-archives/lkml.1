Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZJPHYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZJPHYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbZJPHYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:24:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:38834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbZJPHYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:24:21 -0400
Date: Fri, 16 Oct 2009 07:22:27 GMT
From: tip-bot for Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rdreier@cisco.com, rolandd@cisco.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, tglx@linutronix.de, rolandd@cisco.com, mingo@elte.hu
In-Reply-To: <adaeip473qt.fsf@cisco.com>
References: <adaeip473qt.fsf@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don't print number of MCE banks for every CPU
Message-ID: <tip-93ae5012a79b11e7fc855b52c7ce1e16fe1540b0@git.kernel.org>
Git-Commit-ID: 93ae5012a79b11e7fc855b52c7ce1e16fe1540b0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Oct 2009 07:22:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93ae5012a79b11e7fc855b52c7ce1e16fe1540b0
Gitweb:     http://git.kernel.org/tip/93ae5012a79b11e7fc855b52c7ce1e16fe1540b0
Author:     Roland Dreier <rdreier@cisco.com>
AuthorDate: Thu, 15 Oct 2009 14:21:14 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Oct 2009 09:20:03 +0200

x86: Don't print number of MCE banks for every CPU

The MCE initialization code explicitly says it doesn't handle
asymmetric configurations where different CPUs support different
numbers of MCE banks, and it prints a big warning in that case.

Therefore, printing the "mce: CPU supports <x> MCE banks"
message into the kernel log for every CPU is pure redundancy
that clutters the log significantly for systems with lots of
CPUs.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
LKML-Reference: <adaeip473qt.fsf@cisco.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b1598a9..721a77c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1214,7 +1214,8 @@ static int __cpuinit mce_cap_init(void)
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 
 	b = cap & MCG_BANKCNT_MASK;
-	printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
+	if (!banks)
+		printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
 
 	if (b > MAX_NR_BANKS) {
 		printk(KERN_WARNING
