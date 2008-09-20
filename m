Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbYITBAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbYITBAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 21:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYITBAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 21:00:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:29284 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYITBAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 21:00:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=OGdHgl1Cpr/yIX1faCsEDqR2dPOdLsgVjqiJSejPFOVFDG+d+vFerwkOVhEfDhalnc
         NtKQeFRuhnNGk8a408PSk/rUTlrYnw1+iTATn9Mz1s7ahEYlVOk0xfjDft93Le3/V02r
         6GgjLThyios45FY6uoHOAVzCghF9iYGY/kTIQ=
Message-ID: <48D44B35.10105@gmail.com>
Date: Fri, 19 Sep 2008 21:00:37 -0400
From: sangsu <sangsu@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: stern@rowland.harvard.edu
CC: david-b@pacbell.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] USB: g_printer: fix handling zero-length packet
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

g_printer doesn't have to check whether the data size is a multiple of
MaxPacketSize, because device controller driver already make that check.

Signed-off-by: SangSu Park<sangsu@gmail.com>
---
drivers/usb/gadget/printer.c | 3++-
1 files changed, 2 insertion(+), 1 deletions(-)


--- a/drivers/usb/gadget/printer.c	2008-08-12 21:55:39.000000000 -0400
+++ b/drivers/usb/gadget/printer.c	2008-09-19 20:39:44.000000000 -0400
@@ -1264,8 +1264,7 @@
	/* respond with data transfer before status phase? */
	if (value >= 0) {
		req->length = value;
-		req->zero = value < wLength
-				&& (value % gadget->ep0->maxpacket) == 0;
+		req->zero = value < wLength;
		value = usb_ep_queue(gadget->ep0, req, GFP_ATOMIC);
		if (value < 0) {
			DBG(dev, "ep_queue --> %d\n", value);
