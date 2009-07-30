Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZG3Rci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZG3Rci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 13:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZG3Rch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 13:32:37 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:55005 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZG3Rch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 13:32:37 -0400
X-Greylist: delayed 1895 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2009 13:32:37 EDT
From: Bart Van Assche <bart.vanassche@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.30] schedule_work() documentation improvements
Date: Thu, 30 Jul 2009 19:00:53 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30.3-scst-debug; KDE/4.1.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301900.54202.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two important aspects of the schedule_work() function are not yet documented:
- that it is allowed to pass a struct work_struct * to this function that
  is already on the kernel-global workqueue;
- the meaning of its return value.
The patch below documents both aspects.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>

diff -uprN orig/linux-2.6.30/kernel/workqueue.c linux-2.6.30/kernel/workqueue.c
--- orig/linux-2.6.30/kernel/workqueue.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30/kernel/workqueue.c	2009-07-30 18:58:07.000000000 +0200
@@ -603,7 +603,11 @@ static struct workqueue_struct *keventd_
  * schedule_work - put work task in global workqueue
  * @work: job to be done
  *
- * This puts a job in the kernel-global workqueue.
+ * Returns zero if @work was already on the kernel-global workqueue and
+ * non-zero otherwise.
+ *
+ * This puts a job in the kernel-global workqueue if it was not already queued
+ * and leaves it in the same position on the kernel-global workqueue otherwise.
  */
 int schedule_work(struct work_struct *work)
 {
