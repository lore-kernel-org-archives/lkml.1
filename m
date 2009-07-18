Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZGRVWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZGRVWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 17:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZGRVWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 17:22:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:40742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZGRVWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 17:22:34 -0400
Date: Sat, 18 Jul 2009 21:17:03 GMT
From: tip-bot for Pavel Roskin <proski@gnu.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, proski@gnu.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, proski@gnu.org
In-Reply-To: <20090718204602.5191.360.stgit@mj.roinet.com>
References: <20090718204602.5191.360.stgit@mj.roinet.com>
Subject: [tip:timers/urgent] timer: Avoid reading uninitialized data
Message-ID: <tip-4841158b26e28e1476eed84c7347c18f11317750@git.kernel.org>
Git-Commit-ID: 4841158b26e28e1476eed84c7347c18f11317750
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 21:17:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4841158b26e28e1476eed84c7347c18f11317750
Gitweb:     http://git.kernel.org/tip/4841158b26e28e1476eed84c7347c18f11317750
Author:     Pavel Roskin <proski@gnu.org>
AuthorDate: Sat, 18 Jul 2009 16:46:02 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 18 Jul 2009 23:11:43 +0200

timer: Avoid reading uninitialized data

timer->expires may be uninitialized, so check timer_pending() before
touching timer->expires to pacify kmemcheck.

Signed-off-by: Pavel Roskin <proski@gnu.org>
LKML-Reference: <20090718204602.5191.360.stgit@mj.roinet.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 0b36b9e..a7f07d5 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -714,7 +714,7 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	 * networking code - if the timer is re-modified
 	 * to be the same thing then just return:
 	 */
-	if (timer->expires == expires && timer_pending(timer))
+	if (timer_pending(timer) && timer->expires == expires)
 		return 1;
 
 	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
