Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYIGAal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYIGAal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 20:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYIGAaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 20:30:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:62322 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYIGAaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 20:30:01 -0400
To: linux-kernel@vger.kernel.org
Cc: Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH 1/1] drivers/usb/host/pci-quirks.c: wait for EHCI handoff far too long in quirk_usb_disable_ehci()
Date: Sat,  6 Sep 2008 17:29:53 -0700
Message-Id: <1220747393-10401-2-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1220747393-10401-1-git-send-email-steven@uplinklabs.net>
References: <1220747393-10401-1-git-send-email-steven@uplinklabs.net>
From: Steven Noonan <steven.noonan@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a very noticeable bootup delay on some
systems (in my particular case, an HP dv5178us). The
problem is caused by a buggy BIOS which doesn't properly
announce that the handoff was completed.

The delay in the current version of pci-quirks.c is 5 seconds,
which I've cut down to 0.5 seconds.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/usb/host/pci-quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index ae6e70e..9a3609a 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -271,7 +271,7 @@ static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
 			/* if boot firmware now owns EHCI, spin till
 			 * it hands it over.
 			 */
-			msec = 5000;
+			msec = 500;
 			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
 				tried_handoff = 1;
 				msleep(10);
-- 
1.6.0.1

