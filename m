Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbXA3DAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbXA3DAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 22:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXA3DAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 22:00:42 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38393 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbXA3DAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 22:00:42 -0500
Date: Mon, 29 Jan 2007 19:00:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: akpm@osdl.org
Cc: mingo@elte.hu, dipankar@in.ibm.com, ego@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Change constant zero to NOTIFY_DONE in ratelimit_handler()
Message-ID: <20070130030030.GA2839@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Change a hard-coded constant 0 to the symbolic equivalent NOTIFY_DONE
in the ratelimit_handler() CPU notifier handler function.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 page-writeback.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -urpNa -X dontdiff linux-2.6.20-rc6/mm/page-writeback.c linux-2.6.20-rc6-ratelimit_handler-fix/mm/page-writeback.c
--- linux-2.6.20-rc6/mm/page-writeback.c	2007-01-29 16:34:16.000000000 -0800
+++ linux-2.6.20-rc6-ratelimit_handler-fix/mm/page-writeback.c	2007-01-29 18:04:16.000000000 -0800
@@ -517,7 +517,7 @@ static int __cpuinit
 ratelimit_handler(struct notifier_block *self, unsigned long u, void *v)
 {
 	writeback_set_ratelimit();
-	return 0;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block __cpuinitdata ratelimit_nb = {
