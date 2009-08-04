Return-Path: <linux-kernel-owner+w=401wt.eu-S932935AbZHDPeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbZHDPeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932347AbZHDPeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:34:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:40072 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbZHDPeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:34:01 -0400
Date: Tue, 4 Aug 2009 15:32:57 GMT
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
Message-ID: <tip-5c0c5f2bcb98afd2af6eebad0b0b1f7ffd04d73a@git.kernel.org>
Git-Commit-ID: 5c0c5f2bcb98afd2af6eebad0b0b1f7ffd04d73a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:33:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c0c5f2bcb98afd2af6eebad0b0b1f7ffd04d73a
Gitweb:     http://git.kernel.org/tip/5c0c5f2bcb98afd2af6eebad0b0b1f7ffd04d73a
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Thu, 23 Jul 2009 00:52:59 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:35:45 +0200

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
index a79e8a9..1221f68 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1660,7 +1660,6 @@ int __init APIC_init_uniprocessor(void)
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
 		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
 			boot_cpu_physical_apicid);
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
 #endif
