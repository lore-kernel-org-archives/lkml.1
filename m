Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbXE1Hz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbXE1Hz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 03:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbXE1HzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 03:55:19 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:55715
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751866AbXE1HzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 03:55:18 -0400
Date: Mon, 28 May 2007 09:57:12 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: mingo@elte.hu, rml@tech9.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/sched.c: use list_for_each_entry_safe() in __wake_up_common()
Message-ID: <20070528075712.GA7201@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	mingo@elte.hu, rml@tech9.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_for_each_entry_safe() instead of list_for_each_safe() in
__wake_up_common()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

-- 

diff --git a/kernel/sched.c b/kernel/sched.c
index 799d23b..38723b7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3775,10 +3775,9 @@ EXPORT_SYMBOL(default_wake_function);
 static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
 			     int nr_exclusive, int sync, void *key)
 {
-	struct list_head *tmp, *next;
+	wait_queue_t *curr, *next;
 
-	list_for_each_safe(tmp, next, &q->task_list) {
-		wait_queue_t *curr = list_entry(tmp, wait_queue_t, task_list);
+	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
 		unsigned flags = curr->flags;
 
 		if (curr->func(curr, mode, sync, key) &&

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      In itself, homosexuality is as limiting as heterosexuality: the
     ideal should be to be capable of loving a woman or a man; either,
      a human being, without  feeling fear, restraint, or obligation
                          (Simone de Beauvoir)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
