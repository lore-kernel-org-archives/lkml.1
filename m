Return-Path: <linux-kernel-owner+w=401wt.eu-S934039AbXF2S1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039AbXF2S1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXF2S1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:27:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34581 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbXF2S1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:27:01 -0400
Date: Fri, 29 Jun 2007 20:26:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] saa7134 fix
Message-ID: <20070629182651.GA12811@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the fix in this commit:

| commit 58e78475ec706f93e0cc049449ffd11fbfdadb3e
| Author: Jeff Mahoney <jeffm@suse.com>
| Date:   Wed Jun 27 14:09:58 2007 -0700
|
|    saa7134: fix thread shutdown handling
|
|    This patch changes the test for the thread pid from >= 0 to > 0.

might be incomplete - there's another place where this driver has a
pid >= 0 check. Should this be 'pid > 0' too?

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: v/drivers/media/video/saa7134/saa7134-tvaudio.c
===================================================================
--- v.orig/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ v/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -1020,7 +1020,7 @@ int saa7134_tvaudio_do_scan(struct saa71
 		dprintk("sound IF not in use, skipping scan\n");
 		dev->automute = 0;
 		saa7134_tvaudio_setmute(dev);
-	} else if (dev->thread.pid >= 0) {
+	} else if (dev->thread.pid > 0) {
 		dev->thread.mode = UNSET;
 		dev->thread.scan2++;
 		wake_up_interruptible(&dev->thread.wq);
