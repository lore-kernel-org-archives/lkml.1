Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYBSApT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYBSApT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYBSApH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:45:07 -0500
Received: from www.tglx.de ([62.245.132.106]:50402 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbYBSApF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:45:05 -0500
Subject: [PATCH] queue usb USB_CDC_GET_ENCAPSULATED_RESPONSE message
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: tglx@linutronix.de, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 19 Feb 2008 01:44:50 +0100
Message-Id: <1203381890.3923.60.camel@bender.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

commit 0cf4f2de0a0f4100795f38ef894d4910678c74f8 introduced a bug, which
prevents sending an USB_CDC_GET_ENCAPSULATED_RESPONSE message. This
breaks the RNDIS initialization (especially / only Windoze machines
dislike this behavior...).

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>

---
 drivers/usb/gadget/ether.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.24/drivers/usb/gadget/ether.c
===================================================================
--- linux-2.6.24.orig/drivers/usb/gadget/ether.c
+++ linux-2.6.24/drivers/usb/gadget/ether.c
@@ -1568,6 +1568,7 @@ done_set_intf:
 				memcpy(req->buf, buf, n);
 				req->complete = rndis_response_complete;
 				rndis_free_response(dev->rndis_config, buf);
+				value = n;
 			}
 			/* else stalls ... spec says to avoid that */
 		}


