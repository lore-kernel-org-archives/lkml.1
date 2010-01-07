Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302Ab0AGBRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0AGBRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760Ab0AGBRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:17:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:23491 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0AGBRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:17:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dHRn2SNJ3VsOrjT4SICS5UdgVeC4qQwv4jtwKYXZ04ZF0X9oKxEo4Okw2QFnwO4KU0
         v30oBoU/alfqH2HnkRISujuBBxjNUewv+2ZUbMfLEGLajvuGNbigfmxzJCBu/eWu02B4
         bbX1ZFGUZSrAE99EHgDuwQRXZmJSmwCU3jaSA=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] USB: FHCI: avoid NULL pointer dereference
Date: Thu,  7 Jan 2010 04:17:32 +0300
Message-Id: <1262827052-29329-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign fhci only if usb is not NULL.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/usb/host/fhci-hcd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index 0951818..78e7c3c 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -242,9 +242,10 @@ err:
 static void fhci_usb_free(void *lld)
 {
 	struct fhci_usb *usb = lld;
-	struct fhci_hcd *fhci = usb->fhci;
+	struct fhci_hcd *fhci;
 
 	if (usb) {
+		fhci = usb->fhci;
 		fhci_config_transceiver(fhci, FHCI_PORT_POWER_OFF);
 		fhci_ep0_free(usb);
 		kfree(usb->actual_frame);
-- 
1.6.6

