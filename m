Return-Path: <linux-kernel-owner+w=401wt.eu-S937516AbXGLBDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937516AbXGLBDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759025AbXGLBDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:03:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44768 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532AbXGLBDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:03:11 -0400
Date: Wed, 11 Jul 2007 18:03:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, dipankar@in.ibm.com, josht@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: [PATCH] Remove workaround for unimmunized rcu_dereference from mce_log()
Message-ID: <20070712010308.GA1605@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070712010058.GA30869@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712010058.GA30869@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the rmb() from mce_log(), since the immunized version of
rcu_dereference() makes it unnecessary.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 mce.c |    3 ---
 1 file changed, 3 deletions(-)

diff -urpNa -X dontdiff linux-2.6.22-volrcud/arch/x86_64/kernel/mce.c linux-2.6.22-volrcud-mcefix/arch/x86_64/kernel/mce.c
--- linux-2.6.22-volrcud/arch/x86_64/kernel/mce.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-volrcud-mcefix/arch/x86_64/kernel/mce.c	2007-07-11 17:22:06.000000000 -0700
@@ -67,9 +67,6 @@ void mce_log(struct mce *mce)
 	wmb();
 	for (;;) {
 		entry = rcu_dereference(mcelog.next);
-		/* The rmb forces the compiler to reload next in each
-		    iteration */
-		rmb();
 		for (;;) {
 			/* When the buffer fills up discard new entries. Assume
 			   that the earlier errors are the more interesting. */
