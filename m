Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbYHREP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbYHREP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYHREPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:15:19 -0400
Received: from ozlabs.org ([203.10.76.45]:48527 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYHREPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:15:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] Remove deprecated stop_machine_run: fix Xen
Date: Mon, 18 Aug 2008 14:14:10 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181414.11164.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last use of (the deprecated) stop_machine_run in the tree.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/manage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
