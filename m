Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790Ab0A0Ch1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0A0Ch1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473Ab0A0Ch0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:37:26 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49346 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab0A0Ch0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:37:26 -0500
Date: Tue, 26 Jan 2010 20:37:22 -0600
From: Russ Anderson <rja@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: Dean Nelson <dnelson@redhat.com>, Russ Anderson <rja@sgi.com>
Subject: [bigfix] x86, msr/cpuid: Pass the number of minors when unregistering MSR and CPUID drivers.
Message-ID: <20100127023722.GA22305@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the number of minors when unregistering MSR and CPUID drivers.

Reported-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Russ Anderson <rja@sgi.com>

---
While code reviewing the patch "x86, msr/cpuid: Register enough minors for
the MSR and CPUID drivers", Dean noticed the number of minors not being
passed when unregistering in the *_exit functions.

 arch/x86/kernel/cpuid.c |    2 +-
 arch/x86/kernel/msr.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpuid.c
===================================================================
--- linux.orig/arch/x86/kernel/cpuid.c	2010-01-26 15:23:38.000000000 -0600
+++ linux/arch/x86/kernel/cpuid.c	2010-01-26 15:30:15.000000000 -0600
@@ -234,7 +234,7 @@ static void __exit cpuid_exit(void)
 	for_each_online_cpu(cpu)
 		cpuid_device_destroy(cpu);
 	class_destroy(cpuid_class);
-	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
+	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
 	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
 }
 
Index: linux/arch/x86/kernel/msr.c
===================================================================
--- linux.orig/arch/x86/kernel/msr.c	2010-01-26 15:23:38.000000000 -0600
+++ linux/arch/x86/kernel/msr.c	2010-01-26 15:30:38.000000000 -0600
@@ -290,7 +290,7 @@ static void __exit msr_exit(void)
 	for_each_online_cpu(cpu)
 		msr_device_destroy(cpu);
 	class_destroy(msr_class);
-	unregister_chrdev(MSR_MAJOR, "cpu/msr");
+	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
 	unregister_hotcpu_notifier(&msr_class_cpu_notifier);
 }
 
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
