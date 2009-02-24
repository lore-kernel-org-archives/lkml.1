Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZBXMdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZBXMdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZBXMdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:33:09 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:42996 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZBXMdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:33:08 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH v2] init/main.c: annotate 'init_post' with
	'__releases(kernel_lock)'
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2009 13:32:51 +0100
Message-ID: <20090224123210.10671.76731.stgit@vmbox.hanneseder.net>
In-Reply-To: <49A148F7.1010302@s5r6.in-berlin.de>
References: <49A148F7.1010302@s5r6.in-berlin.de>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse warnings:
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

