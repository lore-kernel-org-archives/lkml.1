Return-Path: <linux-kernel-owner+w=401wt.eu-S1762896AbXEUPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762896AbXEUPIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbXEUPIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:08:12 -0400
Received: from mail.bn-online.net ([217.76.96.46]:39698 "EHLO
	blatz006.blatzheim.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbXEUPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:08:11 -0400
X-Greylist: delayed 1010 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2007 11:08:10 EDT
Message-ID: <4651B1E2.3020801@colognechip.com>
Date: Mon, 21 May 2007 16:51:14 +0200
From: Martin Bachem <info@colognechip.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [Fwd: [PATCH] HiSax: fix error checking for hisax_register()]
Content-Type: multipart/mixed;
 boundary="------------060001040300050609090508"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060001040300050609090508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Martin Bachem <info@colognechip.com>
Acked-by: Karsten Keil <kkeil@suse.de>


--------------060001040300050609090508
Content-Type: message/rfc822;
 name="[PATCH] HiSax: fix error checking for hisax_register().eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="[PATCH] HiSax: fix error checking for hisax_register().eml"

Return-Path: <stern@rowland.harvard.edu>
Received: from mail ([unix socket])
	by mail (Cyrus v2.1.15) with LMTP; Mon, 26 Mar 2007 16:24:42 +0200
X-Sieve: CMU Sieve 2.2
Received: from localhost (localhost [127.0.0.1])
	by mail.ccag (Postfix) with ESMTP id 9966A2F0005
	for <colognechip@localhost.ccag>; Mon, 26 Mar 2007 16:24:42 +0200 (CEST)
Received: from mail.ccag ([127.0.0.1])
 by localhost (mail [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 06811-06 for <colognechip@localhost.ccag>;
 Mon, 26 Mar 2007 16:24:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.ccag (Postfix) with ESMTP id 6D6762F0028
	for <colognechip@localhost>; Mon, 26 Mar 2007 16:24:40 +0200 (CEST)
Delivered-To: info@colognechip.com
Received: from blatz006.bn-online.net [217.76.96.46]
	by localhost with POP3 (fetchmail-6.2.3)
	for colognechip@localhost (single-drop); Mon, 26 Mar 2007 16:24:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blatz006.blatzheim.com (Pstfx-gb-2.4-20070310-TLS) with ESMTP id A27A41FF0C7
	for <info@colognechip.com>; Mon, 26 Mar 2007 16:21:04 +0200 (MEST)
X-Virus-Scanned: amavisd-new at bn-online.net
Received: from blatz006.blatzheim.com ([127.0.0.1])
	by localhost (mail.bn-online.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id zTjuS0zWYOcA for <info@colognechip.com>;
	Mon, 26 Mar 2007 16:20:54 +0200 (MEST)
Received: from iolanthe.rowland.org (iolanthe.rowland.org [192.131.102.54])
	by blatz006.blatzheim.com (Pstfx-gb-2.4-20070310-TLS) with SMTP id 432EF1FF0C4
	for <info@colognechip.com>; Mon, 26 Mar 2007 16:20:54 +0200 (MEST)
Received: (qmail 4170 invoked by uid 2102); 26 Mar 2007 10:20:53 -0400
Date: Mon, 26 Mar 2007 10:20:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Karsten Keil <kkeil@suse.de>
Cc: Martin Bachem <info@colognechip.com>,
	<isdn4linux@listserv.isdn4linux.de>
Subject: [PATCH] HiSax: fix error checking for hisax_register()
In-Reply-To: <20070323181749.GB15701@pingi.kke.suse.de>
Message-ID: <Pine.LNX.4.44L0.0703261010580.4009-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Virus-Scanned: by amavisd-new at ccag

This patch (as875) adds error-checking to the callers of
hisax_register().  It also changes an error pathway in that routine,
making it return an error code rather than 0.

This fixes Bugzilla #7960.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/isdn/hisax/config.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/config.c
+++ usb-2.6/drivers/isdn/hisax/config.c
@@ -1551,7 +1551,7 @@ int hisax_register(struct hisax_d_if *hi
 	if (retval == 0) { // yuck
 		cards[i].typ = 0;
 		nrcards--;
-		return retval;
+		return -EINVAL;
 	}
 	cs = cards[i].cs;
 	hisax_d_if->cs = cs;
Index: usb-2.6/drivers/isdn/hisax/hfc_usb.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/hfc_usb.c
+++ usb-2.6/drivers/isdn/hisax/hfc_usb.c
@@ -1306,7 +1306,11 @@ usb_init(hfcusb_data * hfc)
 	}
 	/* default Prot: EURO ISDN, should be a module_param */
 	hfc->protocol = 2;
-	hisax_register(&hfc->d_if, p_b_if, "hfc_usb", hfc->protocol);
+	i = hisax_register(&hfc->d_if, p_b_if, "hfc_usb", hfc->protocol);
+	if (i) {
+		printk(KERN_INFO "HFC-S USB: hisax_register -> %d\n", i);
+		return i;
+	}
 
 #ifdef CONFIG_HISAX_DEBUG
 	hfc_debug = debug;
Index: usb-2.6/drivers/isdn/hisax/hisax_fcpcipnp.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/hisax_fcpcipnp.c
+++ usb-2.6/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -859,7 +859,11 @@ new_adapter(void)
 	for (i = 0; i < 2; i++)
 		b_if[i] = &adapter->bcs[i].b_if;
 
-	hisax_register(&adapter->isac.hisax_d_if, b_if, "fcpcipnp", protocol);
+	if (hisax_register(&adapter->isac.hisax_d_if, b_if, "fcpcipnp",
+			protocol) != 0) {
+		kfree(adapter);
+		adapter = NULL;
+	}
 
 	return adapter;
 }
Index: usb-2.6/drivers/isdn/hisax/st5481_init.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/st5481_init.c
+++ usb-2.6/drivers/isdn/hisax/st5481_init.c
@@ -107,12 +107,17 @@ static int probe_st5481(struct usb_inter
 	for (i = 0; i < 2; i++)
 		b_if[i] = &adapter->bcs[i].b_if;
 
-	hisax_register(&adapter->hisax_d_if, b_if, "st5481_usb", protocol);
+	if (hisax_register(&adapter->hisax_d_if, b_if, "st5481_usb",
+			protocol) != 0)
+		goto err_b1;
+
 	st5481_start(adapter);
 
 	usb_set_intfdata(intf, adapter);
 	return 0;
 
+ err_b1:
+	st5481_release_b(&adapter->bcs[1]);
  err_b:
 	st5481_release_b(&adapter->bcs[0]);
  err_d:




--------------060001040300050609090508
Content-Type: message/rfc822;
 name="[PATCH] HiSax: Fix USB API usage.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[PATCH] HiSax: Fix USB API usage.eml"

Return-Path: <stern@rowland.harvard.edu>
Received: from mail ([unix socket])
	by mail (Cyrus v2.1.15) with LMTP; Mon, 26 Mar 2007 16:24:44 +0200
X-Sieve: CMU Sieve 2.2
Received: from localhost (localhost [127.0.0.1])
	by mail.ccag (Postfix) with ESMTP id EAC222F0005
	for <colognechip@localhost.ccag>; Mon, 26 Mar 2007 16:24:43 +0200 (CEST)
Received: from mail.ccag ([127.0.0.1])
 by localhost (mail [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 13778-02 for <colognechip@localhost.ccag>;
 Mon, 26 Mar 2007 16:24:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.ccag (Postfix) with ESMTP id 991D92F0037
	for <colognechip@localhost>; Mon, 26 Mar 2007 16:24:40 +0200 (CEST)
Delivered-To: info@colognechip.com
Received: from blatz006.bn-online.net [217.76.96.46]
	by localhost with POP3 (fetchmail-6.2.3)
	for colognechip@localhost (single-drop); Mon, 26 Mar 2007 16:24:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blatz006.blatzheim.com (Pstfx-gb-2.4-20070310-TLS) with ESMTP id B04961FF0C0
	for <info@colognechip.com>; Mon, 26 Mar 2007 16:21:42 +0200 (MEST)
X-Virus-Scanned: amavisd-new at bn-online.net
Received: from blatz006.blatzheim.com ([127.0.0.1])
	by localhost (mail.bn-online.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id TvNi2QqEqYC4 for <info@colognechip.com>;
	Mon, 26 Mar 2007 16:21:35 +0200 (MEST)
Received: from iolanthe.rowland.org (iolanthe.rowland.org [192.131.102.54])
	by blatz006.blatzheim.com (Pstfx-gb-2.4-20070310-TLS) with SMTP id 3BCE51FF0C7
	for <info@colognechip.com>; Mon, 26 Mar 2007 16:21:35 +0200 (MEST)
Received: (qmail 4175 invoked by uid 2102); 26 Mar 2007 10:21:34 -0400
Date: Mon, 26 Mar 2007 10:21:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Karsten Keil <kkeil@suse.de>
Cc: Martin Bachem <info@colognechip.com>,
	<isdn4linux@listserv.isdn4linux.de>
Subject: [PATCH] HiSax: Fix USB API usage
In-Reply-To: <20070323181749.GB15701@pingi.kke.suse.de>
Message-ID: <Pine.LNX.4.44L0.0703261020570.4009-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Virus-Scanned: by amavisd-new at ccag

This patch (as876) improves the USB API usage in the HiSax drivers:

	Use usb_kill_urb() rather than usb_unlink_urb() when
	shutting down.

	Remove unnecessary checks for NULL pointers.

	Don't initialize urb->lock, because it is private to usbcore.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/isdn/hisax/hfc_usb.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/hfc_usb.c
+++ usb-2.6/drivers/isdn/hisax/hfc_usb.c
@@ -486,7 +486,6 @@ fill_isoc_urb(struct urb *urb, struct us
 {
 	int k;
 
-	spin_lock_init(&urb->lock);
 	urb->dev = dev;
 	urb->pipe = pipe;
 	urb->complete = complete;
@@ -579,16 +578,14 @@ stop_isoc_chain(usb_fifo * fifo)
 			    "HFC-S USB: Stopping iso chain for fifo %i.%i",
 			    fifo->fifonum, i);
 #endif
-			usb_unlink_urb(fifo->iso[i].purb);
+			usb_kill_urb(fifo->iso[i].purb);
 			usb_free_urb(fifo->iso[i].purb);
 			fifo->iso[i].purb = NULL;
 		}
 	}
-	if (fifo->urb) {
-		usb_unlink_urb(fifo->urb);
-		usb_free_urb(fifo->urb);
-		fifo->urb = NULL;
-	}
+	usb_kill_urb(fifo->urb);
+	usb_free_urb(fifo->urb);
+	fifo->urb = NULL;
 	fifo->active = 0;
 }
 
@@ -1631,11 +1628,9 @@ hfc_usb_probe(struct usb_interface *intf
 #endif
 			/* init the chip and register the driver */
 			if (usb_init(context)) {
-				if (context->ctrl_urb) {
-					usb_unlink_urb(context->ctrl_urb);
-					usb_free_urb(context->ctrl_urb);
-					context->ctrl_urb = NULL;
-				}
+				usb_kill_urb(context->ctrl_urb);
+				usb_free_urb(context->ctrl_urb);
+				context->ctrl_urb = NULL;
 				kfree(context);
 				return (-EIO);
 			}
@@ -1687,21 +1682,15 @@ hfc_usb_disconnect(struct usb_interface
 				    i);
 #endif
 			}
-			if (context->fifos[i].urb) {
-				usb_unlink_urb(context->fifos[i].urb);
-				usb_free_urb(context->fifos[i].urb);
-				context->fifos[i].urb = NULL;
-			}
+			usb_kill_urb(context->fifos[i].urb);
+			usb_free_urb(context->fifos[i].urb);
+			context->fifos[i].urb = NULL;
 		}
 		context->fifos[i].active = 0;
 	}
-	/* wait for all URBS to terminate */
-	mdelay(10);
-	if (context->ctrl_urb) {
-		usb_unlink_urb(context->ctrl_urb);
-		usb_free_urb(context->ctrl_urb);
-		context->ctrl_urb = NULL;
-	}
+	usb_kill_urb(context->ctrl_urb);
+	usb_free_urb(context->ctrl_urb);
+	context->ctrl_urb = NULL;
 	hisax_unregister(&context->d_if);
 	kfree(context);		/* free our structure again */
 }				/* hfc_usb_disconnect */
Index: usb-2.6/drivers/isdn/hisax/st5481_usb.c
===================================================================
--- usb-2.6.orig/drivers/isdn/hisax/st5481_usb.c
+++ usb-2.6/drivers/isdn/hisax/st5481_usb.c
@@ -407,7 +407,6 @@ fill_isoc_urb(struct urb *urb, struct us
 {
 	int k;
 
-	spin_lock_init(&urb->lock);
 	urb->dev=dev;
 	urb->pipe=pipe;
 	urb->interval = 1;




--------------060001040300050609090508--
