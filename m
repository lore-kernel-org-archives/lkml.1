Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZCFO2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZCFO2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZCFO2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:28:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:42118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbZCFO23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:28:29 -0500
Date: Fri, 6 Mar 2009 14:27:45 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236265497.31324.11.camel@penberg-laptop>
References: <1236265497.31324.11.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: rename do_not_nx to disable_nx in mm/init_64.c
Message-ID: <tip-5dd61dfabcaa5bfb67afb8a2d255bd1e156562e3@git.kernel.org>
Git-Commit-ID: 5dd61dfabcaa5bfb67afb8a2d255bd1e156562e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 14:27:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dd61dfabcaa5bfb67afb8a2d255bd1e156562e3
Gitweb:     http://git.kernel.org/tip/5dd61dfabcaa5bfb67afb8a2d255bd1e156562e3
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 17:04:57 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 15:25:52 +0100

x86: rename do_not_nx to disable_nx in mm/init_64.c

As a preparational step for unifying noexec handling on 32-bit and 64-bit,
rename the do_not_nx variable to disable_nx on 64-bit.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236265497.31324.11.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 8a853bc..54efa57 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -85,7 +85,7 @@ early_param("gbpages", parse_direct_gbpages_on);
 pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
-static int do_not_nx __cpuinitdata;
+static int disable_nx __cpuinitdata;
 
 /*
  * noexec=on|off
@@ -100,9 +100,9 @@ static int __init nonx_setup(char *str)
 		return -EINVAL;
 	if (!strncmp(str, "on", 2)) {
 		__supported_pte_mask |= _PAGE_NX;
-		do_not_nx = 0;
+		disable_nx = 0;
 	} else if (!strncmp(str, "off", 3)) {
-		do_not_nx = 1;
+		disable_nx = 1;
 		__supported_pte_mask &= ~_PAGE_NX;
 	}
 	return 0;
@@ -114,7 +114,7 @@ void __cpuinit check_efer(void)
 	unsigned long efer;
 
 	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || do_not_nx)
+	if (!(efer & EFER_NX) || disable_nx)
 		__supported_pte_mask &= ~_PAGE_NX;
 }
 
