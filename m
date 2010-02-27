Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968610Ab0B0Qr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:47:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47615 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968575Ab0B0Qry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:47:54 -0500
Date: Sat, 27 Feb 2010 17:47:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/rlimit change for v2.6.34
Message-ID: <20100227164741.GA16619@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-rlimit-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-rlimit-for-linus

 Thanks,

	Ingo

------------------>
Jiri Slaby (1):
      x86: Use helpers for rlimits


 arch/x86/ia32/ia32_aout.c |    2 +-
 arch/x86/mm/mmap.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 2a4d073..0647478 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -297,7 +297,7 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	 * size limits imposed on them by creating programs with large
 	 * arrays in the data or bss.
 	 */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+	rlim = rlimit(RLIMIT_DATA);
 	if (rlim >= RLIM_INFINITY)
 		rlim = ~0;
 	if (ex.a_data + ex.a_bss > rlim)
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index c8191de..1dab519 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -71,7 +71,7 @@ static int mmap_is_legacy(void)
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
 
-	if (current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY)
+	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY)
 		return 1;
 
 	return sysctl_legacy_va_layout;
@@ -96,7 +96,7 @@ static unsigned long mmap_rnd(void)
 
 static unsigned long mmap_base(void)
 {
-	unsigned long gap = current->signal->rlim[RLIMIT_STACK].rlim_cur;
+	unsigned long gap = rlimit(RLIMIT_STACK);
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
