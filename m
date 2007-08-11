Return-Path: <linux-kernel-owner+w=401wt.eu-S1761062AbXHKOjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761062AbXHKOjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 10:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbXHKOjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 10:39:47 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:52089 "EHLO spock.one.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbXHKOjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 10:39:47 -0400
Date: Sat, 11 Aug 2007 16:39:23 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] uvesafb: always use mutexes when accessing uvfb_tasks
Message-ID: <20070811143923.GC13632@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Accesses to the uvfb_tasks array should be always be protected by a
mutex to avoid race conditions.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index aa5a9c3..e480670 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -208,6 +208,10 @@ static int uvesafb_exec(struct uvesafb_ktask *task)
 		err = !wait_for_completion_timeout(task->done,
 				msecs_to_jiffies(UVESAFB_TIMEOUT));
 
+	mutex_lock(&uvfb_lock);
+	uvfb_tasks[seq] = NULL;
+	mutex_unlock(&uvfb_lock);
+
 	seq++;
 	if (seq >= UVESAFB_TASKS_MAX)
 		seq = 0;


