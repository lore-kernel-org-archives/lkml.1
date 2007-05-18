Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbXERCmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbXERCmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbXERCmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:42:37 -0400
Received: from ozlabs.org ([203.10.76.45]:50029 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbXERCmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:42:36 -0400
Subject: [PATCH] sched_clock vs tsc_disable
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 May 2007 12:42:23 +1000
Message-Id: <1179456143.17608.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Not sure who's code this is, but it's in 2.6.22-rc1-mm1):

If you set tsc_disable (eg "notsc" on cmdline), sched-clock.c gives a
divide by zero on boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r fd2ae7085ca2 arch/i386/kernel/sched-clock.c
--- a/arch/i386/kernel/sched-clock.c	Fri May 18 11:04:27 2007 +1000
+++ b/arch/i386/kernel/sched-clock.c	Fri May 18 12:12:24 2007 +1000
@@ -103,7 +103,7 @@ static void resync_sc_freq(struct sc_dat
 static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
 {
 	sc->sync_base = jiffies;
-	if (!cpu_has_tsc) {
+	if (!cpu_has_tsc || tsc_disable) {
 		sc->unstable = 1;
 		return;
 	}


