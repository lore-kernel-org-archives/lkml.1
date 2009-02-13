Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbZBMHCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbZBMHCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 02:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbZBMHBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 02:01:43 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56555 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZBMHBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 02:01:42 -0500
Message-Id: <200902130700.n1D70wFI085999@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp,
       takedakn@nttdata.co.jp
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Feb 2009 16:00:58 +0900
References: <20090205081810.331987920@nttdata.co.jp> <alpine.LRH.1.10.0902121632160.18265@tundra.namei.org> <200902120653.n1C6rc9u027772@www262.sakura.ne.jp> <alpine.LRH.1.10.0902122024130.18751@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0902122024130.18751@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 13022009 #1614677, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I made a mistake when converting to use standard doubly linked list.
Please apply this patch.
----------
Subject: TOMOYO: Fix exception policy read failure.

Due to wrong initialization, "cat /sys/kernel/security/tomoyo/exception_policy"
returned nothing.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 security/tomoyo/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- security-testing-2.6.git.orig/security/tomoyo/domain.c
+++ security-testing-2.6.git/security/tomoyo/domain.c
@@ -376,7 +376,7 @@ int tomoyo_write_domain_keeper_policy(ch
 bool tomoyo_read_domain_keeper_policy(struct tomoyo_io_buffer *head)
 {
 	struct list_head *pos;
-	bool done = false;
+	bool done = true;
 
 	down_read(&tomoyo_domain_keeper_list_lock);
 	list_for_each_cookie(pos, head->read_var2,
