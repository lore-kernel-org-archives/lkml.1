Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYJGK7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYJGK7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYJGK7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:59:06 -0400
Received: from mailgw.miraclelinux.com ([122.216.84.157]:10511 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYJGK7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:59:05 -0400
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2008 06:59:05 EDT
Message-ID: <48EB3B44.3030202@miraclelinux.com>
Date: Tue, 07 Oct 2008 19:34:44 +0900
From: Naohiro Ooiwa <nooiwa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] oom_kill: fix calculation of the cpu_time and the run_time
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.4.4.348488, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.10.7.101929
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

The cpu-time is in tens of seconds
and the run-time is in thousands of secounds.

but the source code doesn't follow it.

I fixed it and also some white-spaces.
Could you please check this patch.


Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
---
 mm/oom_kill.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 64e5b4b..bddab74 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -100,14 +100,14 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)

 	/*
 	 * CPU time is in tens of seconds and run time is in thousands
-         * of seconds. There is no particular reason for this other than
-         * that it turned out to work very well in practice.
+	 * of seconds. There is no particular reason for this other than
+	 * that it turned out to work very well in practice.
 	 */
-	cpu_time = (cputime_to_jiffies(p->utime) + cputime_to_jiffies(p->stime))
-		>> (SHIFT_HZ + 3);
+	cpu_time = ((cputime_to_jiffies(p->utime) + cputime_to_jiffies(p->stime))
+		>> SHIFT_HZ) / 10UL;

 	if (uptime >= p->start_time.tv_sec)
-		run_time = (uptime - p->start_time.tv_sec) >> 10;
+		run_time = (uptime - p->start_time.tv_sec) / 1000UL;
 	else
 		run_time = 0;

-- 
1.5.4.1

