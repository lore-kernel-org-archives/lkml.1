Return-Path: <linux-kernel-owner+w=401wt.eu-S936653AbZLQEiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936653AbZLQEiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935750AbZLQEhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:37:47 -0500
Received: from kroah.org ([198.145.64.141]:55490 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763970AbZLQEEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:13 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:49 2009
Message-Id: <20091217035649.269026296@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Anand Gadiyar <gadiyar@ti.com>
Subject: [049/151] USB: musb_gadget_ep0: fix unhandled endpoint 0 IRQs, again
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 196f1b7a387546f425df2f1fad26772e3d513aea upstream.

Commit a5073b52833e4df8e16c93dc4cbb7e0c558c74a2 (musb_gadget: fix
unhandled endpoint 0 IRQs) somehow missed its key change:

"The gadget EP0 code routinely ignores an interrupt at end of
the data phase because of musb_g_ep0_giveback() resetting the
state machine to "idle, waiting for SETUP" phase prematurely."

So, the majority of the cases of unhandled IRQs is still unfixed...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_gadget_ep0.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/musb/musb_gadget_ep0.c
+++ b/drivers/usb/musb/musb_gadget_ep0.c
@@ -199,7 +199,6 @@ service_in_request(struct musb *musb, co
 static void musb_g_ep0_giveback(struct musb *musb, struct usb_request *req)
 {
 	musb_g_giveback(&musb->endpoints[0].ep_in, req, 0);
-	musb->ep0_state = MUSB_EP0_STAGE_SETUP;
 }
 
 /*


