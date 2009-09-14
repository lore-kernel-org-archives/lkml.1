Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbZINUE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbZINUE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbZINUE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:04:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:42788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870AbZINUE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:04:26 -0400
Date: Mon, 14 Sep 2009 20:04:03 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: clocksource_select must be called with mutex locked
Message-ID: <tip-e6c733050faa93ce616bfedccd279ab12cffdd7b@git.kernel.org>
Git-Commit-ID: e6c733050faa93ce616bfedccd279ab12cffdd7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 14 Sep 2009 20:04:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6c733050faa93ce616bfedccd279ab12cffdd7b
Gitweb:     http://git.kernel.org/tip/e6c733050faa93ce616bfedccd279ab12cffdd7b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 14 Sep 2009 19:51:11 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Sep 2009 21:59:32 +0200

clocksource: clocksource_select must be called with mutex locked

The callers of clocksource_select must hold clocksource_mutex to
protect the clocksource_list.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>


---
 kernel/time/clocksource.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5697155..2c2e5ba 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -471,7 +471,9 @@ static void clocksource_select(void)
 static int __init clocksource_done_booting(void)
 {
 	finished_booting = 1;
+	mutex_lock(&clocksource_mutex);
 	clocksource_select();
+	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
 fs_initcall(clocksource_done_booting);
