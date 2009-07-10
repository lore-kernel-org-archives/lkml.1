Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZGJOBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZGJOBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZGJOBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:01:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:48493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZGJOBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:01:22 -0400
Date: Fri, 10 Jul 2009 14:00:40 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090705160154.GB4791@lenovo>
References: <20090705160154.GB4791@lenovo>
Subject: [tip:x86/cleanups] x86, ipi: Clean up safe_smp_processor_id() by using the cpu_has_apic() macro helper
Message-ID: <tip-a1b4f1a5b7f57be2593a9f1fca465a529c95fc07@git.kernel.org>
Git-Commit-ID: a1b4f1a5b7f57be2593a9f1fca465a529c95fc07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 14:00:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1b4f1a5b7f57be2593a9f1fca465a529c95fc07
Gitweb:     http://git.kernel.org/tip/a1b4f1a5b7f57be2593a9f1fca465a529c95fc07
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 5 Jul 2009 20:01:54 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 15:58:34 +0200

x86, ipi: Clean up safe_smp_processor_id() by using the cpu_has_apic() macro helper

We already use a lot of cpu_has_ helpers.
Lets do here the same for consistency.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090705160154.GB4791@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/ipi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index dbf5445..e6b4f51 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -150,7 +150,7 @@ int safe_smp_processor_id(void)
 {
 	int apicid, cpuid;
 
-	if (!boot_cpu_has(X86_FEATURE_APIC))
+	if (!cpu_has_apic)
 		return 0;
 
 	apicid = hard_smp_processor_id();
