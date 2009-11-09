Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbZKIAMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbZKIAMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 19:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZKIAMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 19:12:13 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50203 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZKIAMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 19:12:12 -0500
Message-Id: <200911090012.nA90CF2i016994@www262.sakura.ne.jp>
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Nov 2009 09:12:15 +0900
References: <m13a4pjjh9.fsf@fess.ebiederm.org> <200911082215.HGJ57827.SJOVFFOHMOLFQt@I-love.SAKURA.ne.jp> <m1bpjch9hy.fsf@fess.ebiederm.org>
In-Reply-To: <m1bpjch9hy.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 08112009 #2944260, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> There has been a gradual transition from the assumption that the table ends with
> !ctl_name to the assumption that procname == NULL.  There is no sysctl entry
> with a valid ctl_name without a valid procname.

I see. Then, please add below one to your patchset.

Regards.
----------
[PATCH] sysctl security/tomoyo: Don't look at ctl_name

ctl_name field was removed. Always use procname field.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/tomoyo.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- security-testing-2.6.orig/security/tomoyo/tomoyo.c
+++ security-testing-2.6/security/tomoyo/tomoyo.c
@@ -122,15 +122,7 @@ static char *tomoyo_sysctl_path(struct c
 	*--end = '\0';
 	buflen--;
 	while (table) {
-		char num[32];
-		const char *sp = table->procname;
-
-		if (!sp) {
-			memset(num, 0, sizeof(num));
-			snprintf(num, sizeof(num) - 1, "=%d=", table->ctl_name);
-			sp = num;
-		}
-		if (tomoyo_prepend(&end, &buflen, sp) ||
+		if (tomoyo_prepend(&end, &buflen, table->procname) ||
 		    tomoyo_prepend(&end, &buflen, "/"))
 			goto out;
 		table = table->parent;
