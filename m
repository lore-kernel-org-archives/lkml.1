Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbYCUQGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbYCUQGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbYCUQFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:05:46 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44285 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758610AbYCUQFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:05:45 -0400
Date: Fri, 21 Mar 2008 19:10:03 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: check_kill_permission: remove tasklist_lock
Message-ID: <20080321161003.GA1464@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that task_session() can't return a false NULL, check_kill_permission()
doesn't need tasklist_lock.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~5_CKP_NO_TASKLIST	2008-03-19 21:15:30.000000000 +0300
+++ 25/kernel/signal.c	2008-03-21 18:10:30.000000000 +0300
@@ -551,9 +551,7 @@ static int check_kill_permission(int sig
 	    !capable(CAP_KILL)) {
 		switch (sig) {
 		case SIGCONT:
-			read_lock(&tasklist_lock);
 			sid = task_session(t);
-			read_unlock(&tasklist_lock);
 			/*
 			 * We don't return the error if sid == NULL. The
 			 * task was unhashed, the caller must notice this.

