Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZLUKP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZLUKP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 05:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZLUKP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 05:15:57 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:41709 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbZLUKP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 05:15:56 -0500
Date: Mon, 21 Dec 2009 11:15:49 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: kprobes: get rid of distinct type warning
Message-ID: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Every time I see this:

kernel/kprobes.c: In function 'register_kretprobe':
kernel/kprobes.c:1038: warning: comparison of distinct pointer types lacks a cast

I'm wondering if something changed in common code and we need to do
something for s390. Apparently that's not the case.
Let's get rid of this annoying warning.

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1035,7 +1035,7 @@ int __kprobes register_kretprobe(struct 
 	/* Pre-allocate memory for max kretprobe instances */
 	if (rp->maxactive <= 0) {
 #ifdef CONFIG_PREEMPT
-		rp->maxactive = max(10, 2 * num_possible_cpus());
+		rp->maxactive = max(10U, 2 * num_possible_cpus());
 #else
 		rp->maxactive = num_possible_cpus();
 #endif
