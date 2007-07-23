Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbXGWIB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbXGWIB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbXGWIBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:01:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:36861 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXGWIBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:01:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=dGIy0xW3j21M1mf1LiCVAH7vEGxjz93TBzVybz0Ok0eJAcXBTPkOI3X0NTsMgwjnrajuqF9GzhNlWQorntNnrFjopxzUAzUtev1D5r8RyM7CcXz3NI6CamOOJJ8Bbsdl7IK/tIjoOhaSOaD0+3nHdbA7mnCITGbLvB8hoyJjDKo=
Message-ID: <46A46160.9080508@gmail.com>
Date: Mon, 23 Jul 2007 16:05:52 +0800
From: Micah Gruber <micah.gruber@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: petkan@users.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] [2.6.22] Fix a potential NULL pointer dereference in write_bulk_callback()
 in drivers/net/usb/pegasus.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a potential null dereference bug where we dereference 
pegasus before a null check. This patch simply moves the dereferencing 
after the null check.

Signed-off-by: Micah Gruber <micah.gruber@gmail.com>

---

--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -768,11 +768,13 @@
 static void write_bulk_callback(struct urb *urb)
 {
        pegasus_t *pegasus = urb->context;
-       struct net_device *net = pegasus->net;
+       struct net_device *net;

        if (!pegasus)
                return;

+       net = pegasus->net;
+
        if (!netif_device_present(net) || !netif_running(net))
                return;
