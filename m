Return-Path: <linux-kernel-owner+w=401wt.eu-S1763204AbXLTMMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763204AbXLTMMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761246AbXLTMBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761142AbXLTMAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 22/43] powerpc ptrace generic peekdata/pokedata
Message-Id: <20071220115840.BD60C26F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:58:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ptrace_request handles these, we can drop some more boilerplate.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/powerpc/kernel/ptrace.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index eb27bd9..3e228d6 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -697,12 +697,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	int ret = -EPERM;
 
 	switch (request) {
-	/* when I and D space are separate, these will need to be fixed. */
-	case PTRACE_PEEKTEXT: /* read word at location addr. */
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR: {
 		unsigned long index, tmp;
@@ -730,12 +724,6 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 	}
 
-	/* If I and D space are separate, this will have to be fixed. */
-	case PTRACE_POKETEXT: /* write the word at location addr. */
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	/* write the word at location addr in the USER area */
 	case PTRACE_POKEUSR: {
 		unsigned long index;
-- 
1.5.3.6

