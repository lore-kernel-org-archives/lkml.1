Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYHUJCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYHUJCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 05:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYHUJCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 05:02:17 -0400
Received: from sacred.ru ([62.205.161.221]:55324 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbYHUJCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 05:02:16 -0400
Message-ID: <48AD2F03.7050200@openvz.org>
Date: Thu, 21 Aug 2008 13:01:55 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix bad reference in comment inside __sigqueue_alloc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 21 Aug 2008 13:01:53 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment references the switch_user() function, which
doesn't exist. The real function this code is synchronizing
with is the switch_uid() one.

Can save some time for tags-jumping/grepping :)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/kernel/signal.c b/kernel/signal.c
index e661b01..bd880ed 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -183,7 +183,7 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	struct user_struct *user;
 
 	/*
-	 * In order to avoid problems with "switch_user()", we want to make
+	 * In order to avoid problems with "switch_uid()", we want to make
 	 * sure that the compiler doesn't re-load "t->user"
 	 */
 	user = t->user;
