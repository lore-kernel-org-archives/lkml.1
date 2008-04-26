Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYDZOWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYDZOWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYDZOWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:22:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36909 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYDZOWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:22:09 -0400
Date: Sat, 26 Apr 2008 16:21:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates
Message-ID: <20080426142134.GA13010@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 updates git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-fixes.git for-linus

Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      x86 PAT: tone down debugging messages
      x86 PAT: decouple from nonpromisc devmem

 arch/x86/Kconfig  |    4 ++--
 arch/x86/mm/pat.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4d350b5..4aa4180 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1049,9 +1049,9 @@ config MTRR
 	  See <file:Documentation/mtrr.txt> for more information.
 
 config X86_PAT
-	def_bool y
+	bool
 	prompt "x86 PAT support"
-	depends on MTRR && NONPROMISC_DEVMEM
+	depends on MTRR
 	help
 	  Use PAT attributes to setup page level cache control.
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ef8b64b..9851265 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -334,7 +334,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 				break;
 			}
 
-			printk("Overlap at 0x%Lx-0x%Lx\n",
+			pr_debug("Overlap at 0x%Lx-0x%Lx\n",
 			       saved_ptr->start, saved_ptr->end);
 			/* No conflict. Go ahead and add this new entry */
 			list_add(&new_entry->nd, saved_ptr->nd.prev);
