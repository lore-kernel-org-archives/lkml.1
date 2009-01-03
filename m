Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbZACUlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbZACUlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZACUlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:41:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57107 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbZACUlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:41:16 -0500
Date: Sun, 4 Jan 2009 05:40:37 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland McGrath <roland@redhat.com>, Sripathi Kodi <sripathik@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Frank Mayhar <fmayhar@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] getrusage: RUSAGE_THREAD should return ru_utime and ru_stime
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090104053654.069C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I believe that's bugfix. not new implement.

==
Subject: [PATCH] getrusage: RUSAGE_THREAD should return ru_utime and ru_stime
Impact: regression fix

Original getrusage(RUSAGE_THREAD) implementation can return ru_utime and ru_stime.
but unforunately commit f06febc96ba8e0af80bcc3eaec0a109e88275fac break it.

this patch restore it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Roland McGrath <roland@redhat.com>
CC: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Frank Mayhar <fmayhar@google.com>
---
 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/kernel/sys.c
===================================================================
--- a/kernel/sys.c	2009-01-04 05:01:15.000000000 +0900
+++ b/kernel/sys.c	2009-01-04 05:35:51.000000000 +0900
@@ -1551,6 +1551,8 @@ static void k_getrusage(struct task_stru
 	utime = stime = cputime_zero;
 
 	if (who == RUSAGE_THREAD) {
+		utime = task_utime(current);
+		stime = task_stime(current);
 		accumulate_thread_rusage(p, r);
 		goto out;
 	}


