Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685AbZIXJib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbZIXJib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZIXJi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:38:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:47598 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZIXJi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:38:26 -0400
Date: Thu, 24 Sep 2009 09:37:29 GMT
From: tip-bot for Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rdreier@cisco.com, rolandd@cisco.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, tglx@linutronix.de, rolandd@cisco.com, mingo@elte.hu
In-Reply-To: <adazl8l2swc.fsf@cisco.com>
References: <adazl8l2swc.fsf@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Reduce verbosity of "TSC is reliable" message
Message-ID: <tip-ea01c0d7315d6e3218fd22a6947c5b09305fcf65@git.kernel.org>
Git-Commit-ID: ea01c0d7315d6e3218fd22a6947c5b09305fcf65
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 09:37:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea01c0d7315d6e3218fd22a6947c5b09305fcf65
Gitweb:     http://git.kernel.org/tip/ea01c0d7315d6e3218fd22a6947c5b09305fcf65
Author:     Roland Dreier <rdreier@cisco.com>
AuthorDate: Wed, 23 Sep 2009 15:33:23 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 11:35:19 +0200

x86: Reduce verbosity of "TSC is reliable" message

On modern systems, the kernel prints the message

    Skipping synchronization checks as TSC is reliable.

once for every non-boot CPU.

This gets kind of ridiculous on huge systems; for example, on a
64-thread system I was lucky enough to get:

    $ dmesg | grep 'TSC is reliable' | wc
         63     567    4221

There's no point to doing this for every CPU, since the code is
just checking the boot CPU anyway, so change this to a
printk_once() to make the message appears only once.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
LKML-Reference: <adazl8l2swc.fsf@cisco.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/tsc_sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 027b5b4..f379309 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -114,7 +114,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		return;
 
 	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
-		pr_info("Skipping synchronization checks as TSC is reliable.\n");
+		printk_once(KERN_INFO "Skipping synchronization checks as TSC is reliable.\n");
 		return;
 	}
 
