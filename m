Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZKTIRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZKTIRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZKTIRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:17:33 -0500
Received: from ns.tdt.de ([195.243.126.82]:58582 "EHLO ns.tdt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbZKTIRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:17:33 -0500
X-Greylist: delayed 84807 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 03:17:32 EST
Message-ID: <1C487791B6A047B7A26F2B3C54BE0A70@mschille2>
From: "Martin Schiller" <mschiller@tdt.de>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] hso: memory leak in hso_serial_common_free()
Date: Thu, 19 Nov 2009 09:43:57 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a memory leak in the hso_serial_common_free() function.
The tx_buffer of a serial device was never freed here.

Signed-off-by: Martin Schiller <mschiller@tdt.de>
---

--- linux-2.6.32-rc7-git3/drivers/net/usb/hso.c.orig 2009-11-19 08:54:08.000000000 +0100
+++ linux-2.6.32-rc7-git3/drivers/net/usb/hso.c 2009-11-19 09:04:29.000000000 +0100
@@ -2296,6 +2296,7 @@ static void hso_serial_common_free(struc
  /* unlink and free TX URB */
  usb_free_urb(serial->tx_urb);
  kfree(serial->tx_data);
+ kfree(serial->tx_buffer);
 }
 
 static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,


