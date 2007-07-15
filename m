Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbXGOTA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbXGOTA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 15:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXGOTAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 15:00:20 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:41656
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751590AbXGOTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 15:00:19 -0400
Date: Sun, 15 Jul 2007 21:01:47 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: PATCH [2/5] fs/eventpoll.c: use list_for_each_entry() instead of list_for_each()
Message-ID: <20070715190147.GG4034@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070715185409.GE4034@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715185409.GE4034@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/eventpoll.c: use list_for_each_entry() instead of list_for_each()
in ep_poll_safewake()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 0b73cd4..fada1f9 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -325,15 +325,14 @@ static void ep_poll_safewake(struct poll_safewake *psw, wait_queue_head_t *wq)
 	int wake_nests = 0;
 	unsigned long flags;
 	struct task_struct *this_task = current;
-	struct list_head *lsthead = &psw->wake_task_list, *lnk;
+	struct list_head *lsthead = &psw->wake_task_list;
 	struct wake_task_node *tncur;
 	struct wake_task_node tnode;
 
 	spin_lock_irqsave(&psw->lock, flags);
 
 	/* Try to see if the current task is already inside this wakeup call */
-	list_for_each(lnk, lsthead) {
-		tncur = list_entry(lnk, struct wake_task_node, llink);
+	list_for_each_entry(tncur, lsthead, llink) {
 
 		if (tncur->wq == wq ||
 		    (tncur->task == this_task && ++wake_nests > EP_MAX_POLLWAKE_NESTS)) {

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona


   Usually when people are sad, they don't do anything. They just cry over
     their condition. But when they get angry, they bring about a change
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
