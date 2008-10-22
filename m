Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbYJVRtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbYJVRtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbYJVRgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:36:55 -0400
Received: from kroah.org ([198.145.64.141]:50468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758172AbYJVRgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:36:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/42] Staging: usbip: fix build warning on 64bit kernels
Date: Wed, 22 Oct 2008 10:29:23 -0700
Message-Id: <1224696563-5170-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/usbip/vhci_rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index 933ccaf..58e3995 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -202,7 +202,7 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 	ret = usbip_xmit(0, ud->tcp_socket, (char *) &pdu, sizeof(pdu), 0);
 	if (ret != sizeof(pdu)) {
 		uerr("receiving pdu failed! size is %d, should be %d\n",
-				ret, sizeof(pdu));
+				ret, (unsigned int)sizeof(pdu));
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
-- 
1.6.0.2

