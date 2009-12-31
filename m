Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbZLaObt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbZLaObt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 09:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZLaObs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 09:31:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:56648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbZLaObq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 09:31:46 -0500
Date: Thu, 31 Dec 2009 14:31:08 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, joerg.roedel@amd.com,
       sruffell@digium.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, torvalds@linux-foundation.org, stable@kernel.org,
       tglx@linutronix.de, sruffell@digium.com, mingo@elte.hu
In-Reply-To: <20091231125624.GA14666@liondog.tnic>
References: <20091231125624.GA14666@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] dma-debug: Fix bug causing build warning
Message-ID: <tip-a8fe9ea200ea21421ea750423d1d4d4f7ce037cf@git.kernel.org>
Git-Commit-ID: a8fe9ea200ea21421ea750423d1d4d4f7ce037cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8fe9ea200ea21421ea750423d1d4d4f7ce037cf
Gitweb:     http://git.kernel.org/tip/a8fe9ea200ea21421ea750423d1d4d4f7ce037cf
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 31 Dec 2009 15:16:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Dec 2009 15:16:23 +0100

dma-debug: Fix bug causing build warning

Stephen Rothwell reported the following build warning:

 lib/dma-debug.c: In function 'dma_debug_device_change':
 lib/dma-debug.c:680: warning: 'return' with no value, in function returning non-void

Introduced by commit f797d9881b62c2ddb1d2e7bd80d87141949c84aa
("dma-debug: Do not add notifier when dma debugging is disabled").

Return 0 [notify-done] when disabled. (this is standard bus notifier behavior.)

Signed-off-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
LKML-Reference: <20091231125624.GA14666@liondog.tnic>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/dma-debug.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 7399744..cf90620 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -670,14 +670,13 @@ static int device_dma_allocations(struct device *dev)
 	return count;
 }
 
-static int dma_debug_device_change(struct notifier_block *nb,
-				    unsigned long action, void *data)
+static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct device *dev = data;
 	int count;
 
 	if (global_disable)
-		return;
+		return 0;
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
