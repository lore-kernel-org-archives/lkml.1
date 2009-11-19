Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZKTIRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZKTIRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZKTIRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:17:36 -0500
Received: from ns.tdt.de ([195.243.126.82]:58582 "EHLO ns.tdt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbZKTIRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:17:34 -0500
X-Greylist: delayed 84807 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 03:17:32 EST
Message-ID: <FBC3AE2CA6DC458FAE6A54AE13793373@mschille2>
From: "Martin Schiller" <mschiller@tdt.de>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] hso: Fix interface order/creation when disabled_net=1
Date: Thu, 19 Nov 2009 09:44:24 +0100
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


This patch stops the useless creation of an serial ttyHS<x> for the
Network Port, when disable_net=1 is set. By that, the order of the
ttyHS<x> is always the same, regardless if disable_net is set or not.

Signed-off-by: Martin Schiller <mschiller@tdt.de>
---

--- linux-2.6.32-rc7-git3/drivers/net/usb/hso.c.orig 2009-11-19 09:08:17.000000000 +0100
+++ linux-2.6.32-rc7-git3/drivers/net/usb/hso.c 2009-11-19 09:10:36.000000000 +0100
@@ -2984,9 +2984,10 @@ static int hso_probe(struct usb_interfac
 
  case HSO_INTF_BULK:
   /* It's a regular bulk interface */
-  if (((port_spec & HSO_PORT_MASK) == HSO_PORT_NETWORK)
-      && !disable_net)
+  if ((port_spec & HSO_PORT_MASK) == HSO_PORT_NETWORK) {
+      if (!disable_net)
    hso_dev = hso_create_net_device(interface, port_spec);
+  }
   else
    hso_dev =
        hso_create_bulk_serial_device(interface, port_spec);


