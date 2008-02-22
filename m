Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbYBVQbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbYBVQbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYBVQbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:31:06 -0500
Received: from tapsys.com ([72.36.178.242]:36352 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYBVQbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:31:04 -0500
X-Greylist: delayed 1095 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2008 11:31:04 EST
Message-ID: <47BEF47B.1020502@madrabbit.org>
Date: Fri, 22 Feb 2008 08:12:43 -0800
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20080214)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: [patch] Remove unneeded null tty check in drivers/usb/serial/io_ti.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker (and Adrian Bunk) spotted an inconsistent
NULL check of port->tty (it's blindly dereferenced later without
the check).

Alan Cox confirmed the check can go.

Signed-off-by: Ray Lee <ray-lk@madrabbit.org>

cc: linux-usb@vger.kernel.org
cc: Greg KH <gregkh@suse.de>
cc: Adrian Bunk <bunk@kernel.org>
cc: linux-kernel@vger.kernel.org
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

Index: linux-2.6/drivers/usb/serial/io_ti.c
===================================================================
--- linux-2.6.orig/drivers/usb/serial/io_ti.c	2008-02-22 07:26:47.000000000 -0800
+++ linux-2.6/drivers/usb/serial/io_ti.c	2008-02-22 07:28:12.000000000 -0800
@@ -1944,8 +1944,7 @@ static int edge_open (struct usb_serial_
  	if (edge_port == NULL)
  		return -ENODEV;

-	if (port->tty)
-		port->tty->low_latency = low_latency;
+	port->tty->low_latency = low_latency;

  	port_number = port->number - port->serial->minor;
  	switch (port_number) {

-- 


