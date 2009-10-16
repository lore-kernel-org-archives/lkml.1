Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZJPM5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZJPM5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759241AbZJPM5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:57:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:50616 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759194AbZJPM5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:57:11 -0400
Date: Fri, 16 Oct 2009 12:55:50 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, tglx@linutronix.de, mingo@elte.hu,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de, borislav.petkov@amd.com,
       mingo@elte.hu
In-Reply-To: <1255689093-26921-2-git-send-email-borislav.petkov@amd.com>
References: <1255689093-26921-2-git-send-email-borislav.petkov@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/mce] x86, mce: Add a global MCE init helper
Message-ID: <tip-b33a6363649f0ff83ec81597ea7fe7e688f973cb@git.kernel.org>
Git-Commit-ID: b33a6363649f0ff83ec81597ea7fe7e688f973cb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Oct 2009 12:55:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b33a6363649f0ff83ec81597ea7fe7e688f973cb
Gitweb:     http://git.kernel.org/tip/b33a6363649f0ff83ec81597ea7fe7e688f973cb
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 16 Oct 2009 12:31:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Oct 2009 14:46:50 +0200

x86, mce: Add a global MCE init helper

Add an early initcall (pre SMP) which sets up global MCE
functionality.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <1255689093-26921-2-git-send-email-borislav.petkov@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 68d968e..8080170 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1436,8 +1436,6 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
 
-	if (raw_smp_processor_id() == 0)
-		atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
 }
 
 /*
@@ -1657,6 +1655,14 @@ static int __init mcheck_enable(char *str)
 }
 __setup("mce", mcheck_enable);
 
+static int __init mcheck_init(void)
+{
+	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
+
+	return 0;
+}
+early_initcall(mcheck_init);
+
 /*
  * Sysfs support
  */
