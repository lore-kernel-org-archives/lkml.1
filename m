Return-Path: <linux-kernel-owner+w=401wt.eu-S1750868AbXCQGZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868AbXCQGZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 02:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXCQGZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 02:25:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:25507 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbXCQGZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 02:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=WcgfXr8QVe5xN/kAzexvdzm3NoRgF21nMGcdOqKifvoiiTxFbGHXeg1rLEz4ow9s8HP2StXjMjh8xGEaTZuJ8YfAf1kfMEeFNjfAsRUEgwjv5kqUUUrVmS2qH0Kgo9ij6/WPUIJ7OAH55W8ukmNk/ufUyAWOjfw6R0nCMud2r0c=
Date: Sat, 17 Mar 2007 08:21:32 +0200
To: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH 2.6.21-rc4] kernel/exit: Fix a comment and code contradiction
Message-ID: <20070317062132.GA11326@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Comment in release_task() claims that group leader's parent process 
is signalled only if it desires so, which is not true.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

To save your time, here's the contradictory code which don't appear in 
the patch (appears after its last line):

      leader = p->group_leader;
      if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
		BUG_ON(leader->exit_signal == -1);
		do_notify_parent(leader, leader->exit_signal);


diff --git a/kernel/exit.c b/kernel/exit.c
index f132349..4a0a35f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -152,7 +152,7 @@ repeat:
 	/*
 	 * If we are the last non-leader member of the thread
 	 * group, and the leader is zombie, then notify the
-	 * group leader's parent process. (if it wants notification.)
+	 * group leader's parent process.
 	 */
 	zap_leader = 0;
 	leader = p->group_leader;

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

