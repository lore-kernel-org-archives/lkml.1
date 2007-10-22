Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbXJVD5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbXJVD5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbXJVD5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:57:15 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:23947
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbXJVD5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:57:14 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Oct 2007 23:57:14 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAF65G0fLO4fZ/2dsb2JhbAA
X-IronPort-AV: E=Sophos;i="4.21,309,1188748800"; 
   d="vcf'?scan'208";a="220461287"
Message-ID: <471C1D3C.1080801@intellect.com.au>
Date: Mon, 22 Oct 2007 11:47:08 +0800
From: Richard Pearman <richard.pearman@intellect.com.au>
Organization: Intellect Australia
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, pberger@brimson.com, borchers@steinerpoint.com
CC: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 001] USB: Error handling bug fix for serial_open()
References: <4709B59F.3020307@intellect.com.au> <20071008220821.GA31234@kroah.com>
In-Reply-To: <20071008220821.GA31234@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------050504040005010202050105"
X-OriginalArrivalTime: 22 Oct 2007 03:47:08.0257 (UTC) FILETIME=[38357D10:01C8145E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050504040005010202050105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

From: Richard Pearman <richard.pearman@intellect.com.au>
From: Greg Breen <greg.breen@intellect.com.au>

When an error occurs in serial_open() ensure that port->tty and 
tty->driver_data are set  to NULL, if previously assigned a value in the 
function.

Signed-off-by: Richard S. Pearman <richard.pearman@intellect.com.au>
---
--- linux-2.6.17.1/drivers/usb/serial/usb-serial.c.orig    Mon Oct 22 
11:12:29 2007
+++ linux-2.6.17.1/drivers/usb/serial/usb-serial.c    Mon Oct 22 
11:12:23 2007
@@ -230,6 +230,8 @@ bailout_module_put:
     module_put(serial->type->driver.owner);
 bailout_mutex_unlock:
     port->open_count = 0;
+    port->tty = NULL;
+    tty->driver_data = NULL;   
     mutex_unlock(&port->mutex);
 bailout_kref_put:
     kref_put(&serial->kref, destroy_serial);

--------------050504040005010202050105
Content-Type: text/x-vcard; charset=utf-8;
 name="richard.pearman.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="richard.pearman.vcf"

begin:vcard
fn:Richard Pearman
n:Pearman;Richard
org:Intellect Australia;Embedded Systems Team
adr:EIR Building, Technology Park, Bentley;;Suite 11 and 12, 1 Sarich Way;Perth;WA;6102;Australia
email;internet:richard.pearman@intellect.com.au
title:Senior embedded systems  engineer
tel;work:+61 (08) 9472 2271
tel;fax:+61 (08) 9470 2584
x-mozilla-html:FALSE
url:http://www.intellect.be
version:2.1
end:vcard


--------------050504040005010202050105--
