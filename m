Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbYIWNgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbYIWNgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYIWNgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:36:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:34025 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYIWNga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:36:30 -0400
Message-Id: <20080923133459.116940632@programming.kicks-ass.net>
References: <20080923133340.929758093@programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 15:33:41 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/6] lockstat: fixup signed division
Content-Disposition: inline; filename=lockstat-fix-div.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some recent modification to this code made me notice the little todo mark.
Now that we have more elaborate 64-bit division functions this isn't hard.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep_proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -470,11 +470,12 @@ static void seq_line(struct seq_file *m,
 
 static void snprint_time(char *buf, size_t bufsiz, s64 nr)
 {
-	unsigned long rem;
+	s64 div;
+	s32 rem;
 
 	nr += 5; /* for display rounding */
-	rem = do_div(nr, 1000); /* XXX: do_div_signed */
-	snprintf(buf, bufsiz, "%lld.%02d", (long long)nr, (int)rem/10);
+	div = div_s64_rem(nr, 1000, &rem);
+	snprintf(buf, bufsiz, "%lld.%02d", (long long)div, (int)rem/10);
 }
 
 static void seq_time(struct seq_file *m, s64 time)

-- 

