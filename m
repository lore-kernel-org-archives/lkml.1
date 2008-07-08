Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYGHUNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYGHUNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYGHUNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:13:39 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:36881 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYGHUNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:13:39 -0400
Date: Tue, 8 Jul 2008 17:13:35 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: linux-kernel@vger.kernel.org
Cc: sfr@canb.auug.org.au, jeremy@goop.org, rjw@sisk.pl
Subject: [PATCH] xen: new power management driver calls
Message-ID: <20080708201327.GA11888@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-next won't build with CONFIG_XEN and CONFIG_PM_SLEEP because
xen_suspend calls device_power_up and device_resume, which require a
parameter since commit 1eede070a59e1cc73da51e1aaa00d9ab86572cfc.
---
 drivers/xen/manage.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 5b546e3..64c554e 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -63,7 +63,7 @@ static int xen_suspend(void *data)
 	gnttab_resume();
 	xen_mm_unpin_all();
 
-	device_power_up();
+	device_power_up(PMSG_RESUME);
 
 	if (!*cancelled) {
 		xen_irq_resume();
@@ -112,7 +112,7 @@ static void do_suspend(void)
 	else
 		xenbus_suspend_cancel();
 
-	device_resume();
+	device_resume(PMSG_RESUME);
 
 	/* Make sure timer events get retriggered on all CPUs */
 	clock_was_set();
-- 
1.5.6
