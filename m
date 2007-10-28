Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXJ1K0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXJ1K0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXJ1K0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:26:37 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:57589 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbXJ1K0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:26:35 -0400
Message-ID: <472470FD.90604@freemail.hu>
Date: Sun, 28 Oct 2007 12:22:37 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Rodrigo Pereira <rodripe@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] leds-clevo-mail: extend naming convention of leds subsystem
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Extend the leds subsystem naming convention with the "function"
property. For example a LED can indicate if a new mail has arrived.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN linux-2.6.24-rc1.a/Documentation/leds-class.txt linux-2.6.24-rc1.b/Documentation/leds-class.txt
--- linux-2.6.24-rc1.a/Documentation/leds-class.txt	2007-10-28 09:01:56.000000000 +0100
+++ linux-2.6.24-rc1.b/Documentation/leds-class.txt	2007-10-28 09:20:07.000000000 +0100
@@ -39,7 +39,9 @@ LED Device Naming

 Is currently of the form:

-"devicename:colour"
+"devicename:colour" or
+"devicename:colour:function" or
+"devicename::function"

 There have been calls for LED properties such as colour to be exported as
 individual led class attributes. As a solution which doesn't incur as much
diff -uprN linux-2.6.24-rc1.a/drivers/leds/leds-clevo-mail.c linux-2.6.24-rc1.b/drivers/leds/leds-clevo-mail.c
--- linux-2.6.24-rc1.a/drivers/leds/leds-clevo-mail.c	2007-10-28 10:18:42.000000000 +0100
+++ linux-2.6.24-rc1.b/drivers/leds/leds-clevo-mail.c	2007-10-28 10:18:56.000000000 +0100
@@ -93,7 +93,7 @@ static void clevo_mail_led_set(struct le
 }

 static struct led_classdev clevo_mail_led = {
-	.name			= "clevo",
+	.name			= "clevo::mail",
 	.brightness_set		= clevo_mail_led_set,
 };

