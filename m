Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYKXTb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYKXTb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYKXTbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:31:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:49236 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYKXTbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:31:31 -0500
Message-ID: <154e089b0811241131m3a15fb14qaea2d151e14ef4ac@mail.gmail.com>
Date: Mon, 24 Nov 2008 20:31:29 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] proc: fix sparse warning
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warning

fs/proc/base.c:312:4: warning: do-while statement is not a compound statement

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 fs/proc/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 94ec750..0801249 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -308,9 +308,9 @@ static int proc_pid_auxv(struct task_struct *task,
char *buffer)
 	struct mm_struct *mm = get_task_mm(task);
 	if (mm) {
 		unsigned int nwords = 0;
-		do
+		do {
 			nwords += 2;
-		while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
+		} while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
 		res = nwords * sizeof(mm->saved_auxv[0]);
 		if (res > PAGE_SIZE)
 			res = PAGE_SIZE;
