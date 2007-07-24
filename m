Return-Path: <linux-kernel-owner+w=401wt.eu-S934506AbXGXJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbXGXJRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762922AbXGXJQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:16:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37514 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762013AbXGXJQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:16:43 -0400
Date: Tue, 24 Jul 2007 11:16:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] pci/hotplug/cpqphp_ctrl.c: remove stale BKL use
Message-ID: <20070724091637.GA6554@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: pci/hotplug/cpqphp_ctrl.c: remove stale BKL use
From: Ingo Molnar <mingo@elte.hu>

remove stale BKL use from drivers/pci/hotplug/cpqphp_ctrl.c.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/pci/hotplug/cpqphp_ctrl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-rt-rebase.q/drivers/pci/hotplug/cpqphp_ctrl.c
===================================================================
--- linux-rt-rebase.q.orig/drivers/pci/hotplug/cpqphp_ctrl.c
+++ linux-rt-rebase.q/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -1746,10 +1746,8 @@ static void pushbutton_helper_thread(uns
 static int event_thread(void* data)
 {
 	struct controller *ctrl;
-	lock_kernel();
+
 	daemonize("phpd_event");
-	
-	unlock_kernel();
 
 	while (1) {
 		dbg("!!!!event_thread sleeping\n");
