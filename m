Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbZIXNRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbZIXNRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZIXNQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:16:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:56178 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbZIXNQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:16:57 -0400
Date: Thu, 24 Sep 2009 13:16:21 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4ABB6EB7.7000002@gmail.com>
References: <4ABB6EB7.7000002@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix buffer allocation
Message-ID: <tip-a255a9981a8566a1efabec983b7811e937e662d2@git.kernel.org>
Git-Commit-ID: a255a9981a8566a1efabec983b7811e937e662d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 13:16:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a255a9981a8566a1efabec983b7811e937e662d2
Gitweb:     http://git.kernel.org/tip/a255a9981a8566a1efabec983b7811e937e662d2
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Thu, 24 Sep 2009 15:05:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 15:11:23 +0200

perf tools: Fix buffer allocation

"perf top" cores dump on my dev machine, if run from a directory
where vmlinux is present:

  *** glibc detected *** malloc(): memory corruption: 0x085670d0 ***

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: <stable@kernel.org>
LKML-Reference: <4ABB6EB7.7000002@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/module.c b/tools/perf/util/module.c
index 8f81622..0d8c85d 100644
--- a/tools/perf/util/module.c
+++ b/tools/perf/util/module.c
@@ -423,7 +423,7 @@ static int mod_dso__load_module_paths(struct mod_dso *self)
 	len += strlen(uts.release);
 	len += strlen("/modules.dep");
 
-	dpath = calloc(1, len);
+	dpath = calloc(1, len + 1);
 	if (dpath == NULL)
 		return err;
 
