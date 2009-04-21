Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZDUIJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZDUIJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZDUIHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:07:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:45520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbZDUIHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:07:50 -0400
Date: Tue, 21 Apr 2009 08:07:11 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090420200450.425091000@linux-os.sc.intel.com>
References: <20090420200450.425091000@linux-os.sc.intel.com>
Subject: [tip:x86/apic] x86: x2apic, IR: Clean up panic() with nox2apic boot option
Message-ID: <tip-39d83a5d684a457046aa2a6dac60f105966e78e9@git.kernel.org>
Git-Commit-ID: 39d83a5d684a457046aa2a6dac60f105966e78e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 08:07:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39d83a5d684a457046aa2a6dac60f105966e78e9
Gitweb:     http://git.kernel.org/tip/39d83a5d684a457046aa2a6dac60f105966e78e9
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 20 Apr 2009 13:02:29 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 09:08:26 +0200

x86: x2apic, IR: Clean up panic() with nox2apic boot option

Instead of panic() ignore the "nox2apic" boot option when BIOS
has already enabled x2apic prior to OS handover.

[ Impact: printk warning instead of panic() when BIOS has enabled x2apic already ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: dwmw2@infradead.org
Cc: Weidong Han <weidong.han@intel.com>
LKML-Reference: <20090420200450.425091000@linux-os.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2b30e52..d32f558 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -141,8 +141,12 @@ static int x2apic_preenabled;
 static int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
-	if (x2apic_enabled())
-		panic("Bios already enabled x2apic, can't enforce nox2apic");
+	if (x2apic_enabled()) {
+		pr_warning("Bios already enabled x2apic, "
+			   "can't enforce nox2apic");
+		return 0;
+	}
+
 	disable_x2apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
