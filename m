Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbYBVEhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbYBVEhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbYBVEhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:37:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517AbYBVEhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:37:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86 ptrace: fix compat PTRACE_SETREGS
In-Reply-To: Miklos Szeredi's message of  Thursday, 21 February 2008 18:20:23 +0100 <E1JSF5r-0007vI-1v@pomaz-ex.szeredi.hu>
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
	<20080215184741.GB8810@c2.user-mode-linux.org>
	<E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu>
	<E1JRD9I-0004L9-6E@pomaz-ex.szeredi.hu>
	<E1JSF5r-0007vI-1v@pomaz-ex.szeredi.hu>
Emacs: (setq software-quality (/ 1 number-of-authors))
Message-Id: <20080222043725.025A02701D5@magilla.localdomain>
Date: Thu, 21 Feb 2008 20:37:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Simple typo fix for regression introduced by the user_regset changes.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 702c33e..d862e39 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1160,7 +1160,7 @@ static int genregs32_set(struct task_struct *target,
 	if (kbuf) {
 		const compat_ulong_t *k = kbuf;
 		while (count > 0 && !ret) {
-			ret = putreg(target, pos, *k++);
+			ret = putreg32(target, pos, *k++);
 			count -= sizeof(*k);
 			pos += sizeof(*k);
 		}
@@ -1171,7 +1171,7 @@ static int genregs32_set(struct task_struct *target,
 			ret = __get_user(word, u++);
 			if (ret)
 				break;
-			ret = putreg(target, pos, word);
+			ret = putreg32(target, pos, word);
 			count -= sizeof(*u);
 			pos += sizeof(*u);
 		}
