Return-Path: <linux-kernel-owner+w=401wt.eu-S1765445AbXLPCXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765445AbXLPCXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 21:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbXLPCXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 21:23:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:54831 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbXLPCXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 21:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=YZvPxBadCOakZaOACNcctxKqpqmhhe79emU7KdM3Kc4pPYCCFitYK5DcQdZtxjOVLTC9lZOeKGer2n/4tT4E13IqR1bYa9gxFeJJUDRsWPuYksxptiBxu15C4F9lTuqSWrE38h+WX2ttYigg9vvWJtyxQHeSCoHY7cpLx4dKw5E=
Date: Sun, 16 Dec 2007 03:25:13 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH RESEND] ehci-hcd: fix sparse warning about shadowing
	'status' symbol
Message-ID: <20071216022510.GJ26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix warning:
drivers/usb/host/ehci-hcd.c:832:8: warning: symbol 'status' shadows an earlier one
drivers/usb/host/ehci-hcd.c:790:71: originally declared here

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
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
--
1.5.3.4

