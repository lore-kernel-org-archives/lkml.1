Return-Path: <linux-kernel-owner+w=401wt.eu-S932100Ab0AEAvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab0AEAvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923Ab0AEAux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:50:53 -0500
Received: from kroah.org ([198.145.64.141]:34201 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab0AEAfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:06 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Shaun Ruffell <sruffell@digium.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/97] dma-debug: Fix bug causing build warning
Date: Mon,  4 Jan 2010 16:32:45 -0800
Message-Id: <1262651630-7354-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

commit a8fe9ea200ea21421ea750423d1d4d4f7ce037cf upstream.

Stephen Rothwell reported the following build warning:

 lib/dma-debug.c: In function 'dma_debug_device_change':
 lib/dma-debug.c:680: warning: 'return' with no value, in function returning non-void

Introduced by commit f797d9881b62c2ddb1d2e7bd80d87141949c84aa
("dma-debug: Do not add notifier when dma debugging is disabled").

Return 0 [notify-done] when disabled. (this is standard bus notifier behavior.)

Signed-off-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20091231125624.GA14666@liondog.tnic>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dma-debug.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index dcd43e3..5a77c7c 100644
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
-- 
1.6.6

