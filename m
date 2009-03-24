Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbZCXMN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbZCXMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbZCXMN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:13:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:44731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbZCXMN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:13:26 -0400
Date: Tue, 24 Mar 2009 12:12:37 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, jens.axboe@oracle.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       jens.axboe@oracle.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C89432.8010805@cn.fujitsu.com>
References: <49C89432.8010805@cn.fujitsu.com>
Subject: [tip:tracing/blktrace] blktrace: fix wrong calculation of RWBS
Message-ID: <tip-65796348e09880e12b97267d39b8857c758440a6@git.kernel.org>
Git-Commit-ID: 65796348e09880e12b97267d39b8857c758440a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 12:12:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65796348e09880e12b97267d39b8857c758440a6
Gitweb:     http://git.kernel.org/tip/65796348e09880e12b97267d39b8857c758440a6
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 24 Mar 2009 16:05:06 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 13:08:59 +0100

blktrace: fix wrong calculation of RWBS

Impact: fix the output of IO type category characters

Trace categories are the upper 16 bits, not the lower 16 bits.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <49C89432.8010805@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 1ffcbd4..9af4143 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -922,23 +922,24 @@ static void blk_unregister_tracepoints(void)
 static void fill_rwbs(char *rwbs, const struct blk_io_trace *t)
 {
 	int i = 0;
+	int tc = t->action >> BLK_TC_SHIFT;
 
-	if (t->action & BLK_TC_DISCARD)
+	if (tc & BLK_TC_DISCARD)
 		rwbs[i++] = 'D';
-	else if (t->action & BLK_TC_WRITE)
+	else if (tc & BLK_TC_WRITE)
 		rwbs[i++] = 'W';
 	else if (t->bytes)
 		rwbs[i++] = 'R';
 	else
 		rwbs[i++] = 'N';
 
-	if (t->action & BLK_TC_AHEAD)
+	if (tc & BLK_TC_AHEAD)
 		rwbs[i++] = 'A';
-	if (t->action & BLK_TC_BARRIER)
+	if (tc & BLK_TC_BARRIER)
 		rwbs[i++] = 'B';
-	if (t->action & BLK_TC_SYNC)
+	if (tc & BLK_TC_SYNC)
 		rwbs[i++] = 'S';
-	if (t->action & BLK_TC_META)
+	if (tc & BLK_TC_META)
 		rwbs[i++] = 'M';
 
 	rwbs[i] = '\0';
