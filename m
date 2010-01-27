Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160Ab0A0ITV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0A0ITV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706Ab0A0ITU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:19:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:44247 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab0A0ITT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:19:19 -0500
Date: Wed, 27 Jan 2010 08:18:52 GMT
From: tip-bot for Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@redhat.com,
       dnelson@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, rja@sgi.com,
       linux-kernel@vger.kernel.org, dnelson@redhat.com, tglx@linutronix.de
In-Reply-To: <20100127023722.GA22305@sgi.com>
References: <20100127023722.GA22305@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, msr/cpuid: Pass the number of minors when unregistering MSR and CPUID drivers.
Message-ID: <tip-da482474b8396e1a099c37ffc6541b78775aedb4@git.kernel.org>
Git-Commit-ID: da482474b8396e1a099c37ffc6541b78775aedb4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 08:18:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da482474b8396e1a099c37ffc6541b78775aedb4
Gitweb:     http://git.kernel.org/tip/da482474b8396e1a099c37ffc6541b78775aedb4
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Tue, 26 Jan 2010 20:37:22 -0600
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 26 Jan 2010 23:52:38 -0800

x86, msr/cpuid: Pass the number of minors when unregistering MSR and CPUID drivers.

Pass the number of minors when unregistering MSR and CPUID drivers.

Reported-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Dean Nelson <dnelson@redhat.com>
LKML-Reference: <20100127023722.GA22305@sgi.com>
Signed-off-by: Russ Anderson <rja@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpuid.c |    2 +-
 arch/x86/kernel/msr.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index cb27fd6..83e5e62 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -229,7 +229,7 @@ static void __exit cpuid_exit(void)
 	for_each_online_cpu(cpu)
 		cpuid_device_destroy(cpu);
 	class_destroy(cpuid_class);
-	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
+	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
 	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
 }
 
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 4bd93c9..206735a 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -285,7 +285,7 @@ static void __exit msr_exit(void)
 	for_each_online_cpu(cpu)
 		msr_device_destroy(cpu);
 	class_destroy(msr_class);
-	unregister_chrdev(MSR_MAJOR, "cpu/msr");
+	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
 	unregister_hotcpu_notifier(&msr_class_cpu_notifier);
 }
 
