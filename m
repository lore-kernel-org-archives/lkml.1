Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0BJRXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:23:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab0BJRXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/40] x86: Raise vsyscall priority on hotplug notifier chain
Date: Wed, 10 Feb 2010 19:22:41 +0200
Message-Id: <1265822589-11155-13-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

KVM need vsyscall_init() to initialize MSR_TSC_AUX before it read the value.
Per Avi's suggestion, this patch raised vsyscall priority on hotplug notifier
chain, to 30.

CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/vsyscall_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 9055e58..1c0c6ab 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -301,7 +301,8 @@ static int __init vsyscall_init(void)
 	register_sysctl_table(kernel_root_table2);
 #endif
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
-	hotcpu_notifier(cpu_vsyscall_notifier, 0);
+	/* notifier priority > KVM */
+	hotcpu_notifier(cpu_vsyscall_notifier, 30);
 	return 0;
 }
 
-- 
1.6.5.3

