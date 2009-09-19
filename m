Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbZISSFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbZISSFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZISSFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:05:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:46126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbZISSFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:05:02 -0400
Date: Sat, 19 Sep 2009 18:04:35 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090915151727.GB21670@alberich.amd.com>
References: <20090915151727.GB21670@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mce: Fix compile warning in case of CONFIG_SMP=n
Message-ID: <tip-a017421ddcdf34474f1133b27e33ab2ca6c19b96@git.kernel.org>
Git-Commit-ID: a017421ddcdf34474f1133b27e33ab2ca6c19b96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 18:04:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a017421ddcdf34474f1133b27e33ab2ca6c19b96
Gitweb:     http://git.kernel.org/tip/a017421ddcdf34474f1133b27e33ab2ca6c19b96
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 15 Sep 2009 17:17:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 19:48:14 +0200

x86, mce: Fix compile warning in case of CONFIG_SMP=n

Fix following compile warning:

  arch/x86/kernel/cpu/mcheck/mce_amd.c: In function 'threshold_create_bank':
  arch/x86/kernel/cpu/mcheck/mce_amd.c:492: warning: unused variable 'c'

which shows up when kernel is compiled with CONFIG_SMP=n.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20090915151727.GB21670@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 8cd5224..83a3d1f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -489,8 +489,9 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
 	char name[32];
+#ifdef CONFIG_SMP
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
+#endif
 
 	sprintf(name, "threshold_bank%i", bank);
 
