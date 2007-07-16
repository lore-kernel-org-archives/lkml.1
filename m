Return-Path: <linux-kernel-owner+w=401wt.eu-S1765529AbXGPPvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765529AbXGPPvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbXGPPvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:51:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:61251 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbXGPPvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:51:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=j63bqsTmrsCESGAFAj/TwlOvHRPuZEiCAVhTzMUduKVPsXFFqPZaPkh0Ie/DjHFC9NkGClUrU1rwQMA9ZKckgNp63Z0h6pwvMBi6RqDqSd/H17FnATuaG0ItmIGaq8Bu9FX8+WYf7/hgfv6NpgBQfHk2RLAsvz3W8OLTyZg9B+E=
Message-ID: <469B93DD.3090003@gmail.com>
Date: Mon, 16 Jul 2007 11:50:53 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: gregkh@suse.de
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] mos7720, mos7840: remove redundant urb check
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity (1709, 1710, 1711, 1712, 1713) actually flagged these as 
REVERSE_INULLs (NULL check performed after dereference). But looking at 
the other drivers I can't see any similar tests and the USB core already 
makes sure urb is non-null - so might as well get rid of the checks.


Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 drivers/usb/serial/mos7720.c |    5 -----
 drivers/usb/serial/mos7840.c |   19 -------------------
 2 files changed, 24 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 231b584..01e811b 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -110,11 +110,6 @@ static void mos7720_interrupt_callback(struct urb *urb)
 
 	dbg("%s"," : Entering\n");
 
-	if (!urb) {
-		dbg("%s","Invalid Pointer !!!!:\n");
-		return;
-	}
-
 	switch (status) {
 	case 0:
 		/* success */
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 37f41f5..f76480f 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -436,11 +436,6 @@ static void mos7840_control_callback(struct urb *urb)
 	int result = 0;
 	int status = urb->status;
 
-	if (!urb) {
-		dbg("%s", "Invalid Pointer !!!!:\n");
-		return;
-	}
-
 	mos7840_port = (struct moschip_port *)urb->context;
 
 	switch (status) {
@@ -525,10 +520,6 @@ static void mos7840_interrupt_callback(struct urb *urb)
 	int status = urb->status;
 
 	dbg("%s", " : Entering\n");
-	if (!urb) {
-		dbg("%s", "Invalid Pointer !!!!:\n");
-		return;
-	}
 
 	switch (status) {
 	case 0:
@@ -676,11 +667,6 @@ static void mos7840_bulk_in_callback(struct urb *urb)
 	struct tty_struct *tty;
 	int status = urb->status;
 
-	if (!urb) {
-		dbg("%s", "Invalid Pointer !!!!:\n");
-		return;
-	}
-
 	if (status) {
 		dbg("nonzero read bulk status received: %d", status);
 		return;
@@ -753,11 +739,6 @@ static void mos7840_bulk_out_data_callback(struct urb *urb)
 	int status = urb->status;
 	int i;
 
-	if (!urb) {
-		dbg("%s", "Invalid Pointer !!!!:\n");
-		return;
-	}
-
 	mos7840_port = (struct moschip_port *)urb->context;
 	spin_lock(&mos7840_port->pool_lock);
 	for (i = 0; i < NUM_URBS; i++) {

