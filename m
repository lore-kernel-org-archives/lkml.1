Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbXLIVZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbXLIVZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXLIVYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:24:46 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:41846 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbXLIVYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:24:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=gevXXiCdzzCCYBIuQSSoAXbirj1zyebiiytF93vWHf3zRnqAEHelFOJZ+YmtpD1O4xpy3kxOupJgEpSBTvY6sgJWTpNYA+/9cv8xiwD5tksCCph4y5KgTx01r6ThvtPaw4EWJySbCNx1uH8ghc1vB3wrSfa3MDN0/Nj0A1O8X58=
Date: Sun, 9 Dec 2007 22:26:15 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ehci-hcd: fix sparse warning about shadowing 'status'
	symbol
Message-ID: <20071209212612.GC9440@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ehci-hcd: fix sparse warning about shadowing 'status' symbol

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 drivers/usb/host/ehci-hcd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 5f2d74e..e531f51 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -829,16 +829,16 @@ static int ehci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		/* reschedule QH iff another request is queued */
 		if (!list_empty (&qh->qtd_list)
 				&& HC_IS_RUNNING (hcd->state)) {
-			int status;
+			int schedule_status;

-			status = qh_schedule (ehci, qh);
+			schedule_status = qh_schedule (ehci, qh);
 			spin_unlock_irqrestore (&ehci->lock, flags);

-			if (status != 0) {
+			if (schedule_status != 0) {
 				// shouldn't happen often, but ...
 				// FIXME kill those tds' urbs
 				err ("can't reschedule qh %p, err %d",
-					qh, status);
+					qh, schedule_status);
 			}
 			return status;
 		}
