Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZBUTuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZBUTuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 14:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZBUTuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 14:50:44 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:42953 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbZBUTun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:50:43 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH] init/main.c: fix sparse warnings: context imbalance
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 21 Feb 2009 20:50:37 +0100
Message-ID: <20090221194940.12602.54077.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Attribute function 'init_post' with __releases(...).

Fix this sparse warnings:
  init/main.c:805:21: warning: context imbalance in 'init_post' - unexpected unlock
  init/main.c:899:9: warning: context imbalance in 'kernel_init' - wrong count at exit

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 init/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index 82456a9..fe53aa6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -803,6 +803,7 @@ int initmem_now_dynamic;
  * makes it inline to init() and it becomes part of init.text section
  */
 static noinline int init_post(void)
+	__releases(kernel_lock)
 {
 	/* need to finish all async __init code before freeing the memory */
 	async_synchronize_full();

