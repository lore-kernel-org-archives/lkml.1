Return-Path: <linux-kernel-owner+w=401wt.eu-S934218AbZHEK4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218AbZHEK4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934206AbZHEKz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:55:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:57650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934207AbZHEKz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:55:58 -0400
Date: Wed, 5 Aug 2009 10:55:28 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, macro@linux-mips.org, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, macro@linux-mips.org, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <20090722205259.GE15805@lenovo>
References: <20090722205259.GE15805@lenovo>
Subject: [tip:x86/apic] x86, apic: Drop redundant bit assignment
Message-ID: <tip-9910887af84e33ba98fd6792029470ae80166208@git.kernel.org>
Git-Commit-ID: 9910887af84e33ba98fd6792029470ae80166208
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 10:55:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9910887af84e33ba98fd6792029470ae80166208
Gitweb:     http://git.kernel.org/tip/9910887af84e33ba98fd6792029470ae80166208
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Thu, 23 Jul 2009 00:52:59 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Aug 2009 10:30:52 +0200

x86, apic: Drop redundant bit assignment

cpu_has_apic has already investigated boot_cpu_data
X86_FEATURE_APIC bit for being clear if condition is
triggered.

So there is no need to clear this bit second time.

Signed-off-by: Cyrill Gorcuno v <gorcunov@openvz.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
LKML-Reference: <20090722205259.GE15805@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0a1c283..0b021c5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1651,7 +1651,6 @@ int __init APIC_init_uniprocessor(void)
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
 		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
 			boot_cpu_physical_apicid);
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
 #endif
