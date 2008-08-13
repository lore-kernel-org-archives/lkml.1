Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYHMFwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYHMFwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYHMFw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:52:26 -0400
Received: from ozlabs.org ([203.10.76.45]:60851 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbYHMFwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:52:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] stop_machine: wean Xen off stop_machine_run
Date: Wed, 13 Aug 2008 15:52:18 +1000
User-Agent: KMail/1.9.9
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808131552.18942.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last use of (the deprecated) stop_machine_run in the tree.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 332ec042cb4d drivers/xen/manage.c
--- a/drivers/xen/manage.c	Wed Aug 13 10:48:27 2008 +1000
+++ b/drivers/xen/manage.c	Wed Aug 13 15:50:02 2008 +1000
@@ -102,7 +102,7 @@ static void do_suspend(void)
 	/* XXX use normal device tree? */
 	xenbus_suspend();
 
-	err = stop_machine_run(xen_suspend, &cancelled, 0);
+	err = stop_machine(xen_suspend, &cancelled, &cpumask_of_cpu(0));
 	if (err) {
 		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
 		goto out;
