Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYKDE5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYKDE5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 23:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYKDE53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 23:57:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:26524 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYKDE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 23:57:28 -0500
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: Steven Noonan <steven@uplinklabs.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH] EHCI pci-quirks.c: wait for BIOS handoff too long
Date: Mon,  3 Nov 2008 20:57:15 -0800
Message-Id: <1225774635-15032-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of waiting a painful 5000ms, quirk_usb_disable_ehci() now does a
1000ms loop to wait for the BIOS to acknowledge the handoff.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/usb/host/pci-quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index ae6e70e..1968ba1 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -271,7 +271,7 @@ static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
 			/* if boot firmware now owns EHCI, spin till
 			 * it hands it over.
 			 */
-			msec = 5000;
+			msec = 1000;
 			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
 				tried_handoff = 1;
 				msleep(10);
-- 
1.5.6.3

