Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZGFVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZGFVGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZGFVGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:06:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:32770 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbZGFVF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:05:59 -0400
Subject: [PATCH -tip V2] x86: thread_info.h moving comment to where it
 should be
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0907062052230.19480@localhost.localdomain>
References: <1246879925.28541.3.camel@hpdv5.satnam>
	 <alpine.LFD.2.00.0907062052230.19480@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 02:35:09 +0530
Message-Id: <1246914309.2478.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 20:54 +0200, Thomas Gleixner wrote:
> On Mon, 6 Jul 2009, Jaswinder Singh Rajput wrote:
> > 
> > By mistake commit 2052e8d40ad58 moved following comment to wrong place,
> > where it does not make any sense :
> 
> Wrong. commit 2052e8d4 had the comments in the right place. commit
> 3351cc03 replaced the two identical INIT_THREAD_INFO macros and did
> not update the comments.
> 

Ahh so you was also part of it, here is updated patch:

[PATCH -tip] x86: thread_info.h moving comment to where it should be

By mistake commit 3351cc03 forget to move following comment along
with INIT_THREAD_INFO :

 "preempt_count needs to be 1 initially, until the scheduler is functional."

Moving comment back to right place where preempt_count is setting to 1

Also by mistake commit 2052e8d4 forget to fix extra line which is not required.
Removed that extra line.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/thread_info.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index b078352..1131636 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -43,6 +43,9 @@ struct thread_info {
 	int			uaccess_err;
 };
 
+/*
+ * preempt_count needs to be 1 initially, until the scheduler is functional
+ */
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.task		= &tsk,			\
@@ -169,12 +172,9 @@ struct thread_info {
 #define STACK_WARN	(THREAD_SIZE/8)
 /*
  * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
 
-
 /* how to get the current stack pointer from C */
 register unsigned long current_stack_pointer asm("esp") __used;
 
@@ -205,7 +205,6 @@ static inline struct thread_info *current_thread_info(void)
 
 /*
  * macros/functions for gaining access to the thread information structure
- * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
 #ifndef __ASSEMBLY__
 DECLARE_PER_CPU(unsigned long, kernel_stack);
-- 
1.6.0.6


