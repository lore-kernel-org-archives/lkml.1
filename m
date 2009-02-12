Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZBLGzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZBLGzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 01:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZBLGyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 01:54:50 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64482 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZBLGyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:54:49 -0500
Message-Id: <200902120653.n1C6rc9u027772@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp,
       takedakn@nttdata.co.jp
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Feb 2009 15:53:38 +0900
References: <20090205081810.331987920@nttdata.co.jp> <alpine.LRH.1.10.0902121632160.18265@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0902121632160.18265@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 12022009 #1609708, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> Applied to 
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
Thank you.

> Please fix the following issue detected by sparse:
Oh, sorry.

What can I do next?
----------
Subject: TOMOYO: Fix sparse warning.

Fix sparse warning.

$ make C=2 SUBDIRS=security/tomoyo CF="-D__cold__="
 CHECK   security/tomoyo/common.c
 CHECK   security/tomoyo/realpath.c
 CHECK   security/tomoyo/tomoyo.c
security/tomoyo/tomoyo.c:110:8: warning: symbol 'buf' shadows an earlier one
security/tomoyo/tomoyo.c:100:7: originally declared here

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 security/tomoyo/tomoyo.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- security-testing-2.6.git.orig/security/tomoyo/tomoyo.c
+++ security-testing-2.6.git/security/tomoyo/tomoyo.c
@@ -107,13 +107,13 @@ static char *tomoyo_sysctl_path(struct c
 	*--end = '\0';
 	buflen--;
 	while (table) {
-		char buf[32];
+		char num[32];
 		const char *sp = table->procname;
 
 		if (!sp) {
-			memset(buf, 0, sizeof(buf));
-			snprintf(buf, sizeof(buf) - 1, "=%d=", table->ctl_name);
-			sp = buf;
+			memset(num, 0, sizeof(num));
+			snprintf(num, sizeof(num) - 1, "=%d=", table->ctl_name);
+			sp = num;
 		}
 		if (tomoyo_prepend(&end, &buflen, sp) ||
 		    tomoyo_prepend(&end, &buflen, "/"))
