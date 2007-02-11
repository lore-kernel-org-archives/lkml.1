Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbXBKKRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbXBKKRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 05:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXBKKRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 05:17:33 -0500
Received: from viefep18-int.chello.at ([213.46.255.21]:11315 "EHLO
	viefep22-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753167AbXBKKRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 05:17:32 -0500
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Feb 2007 05:17:31 EST
Message-ID: <45CEE9AB.2020208@freemail.hu>
Date: Sun, 11 Feb 2007 11:02:19 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.0.6) Gecko/20060730 SeaMonkey/1.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] input: extend EV_LED
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Extend EV_LED handling code so that it can handle not
only two states (on/off) but also others. For example
a LED can blink using hardware acceleration. The code
changed so that it is similar to the code at EV_SND.

Signed-off-by: Márton Németh <nm127@freemail.hu>

---
diff -uprN linux-2.6.20.orig/drivers/input/input.c 
linux/drivers/input/input.c
--- linux-2.6.20.orig/drivers/input/input.c	2007-02-04 
19:44:54.000000000 +0100
+++ linux/drivers/input/input.c	2007-02-10 15:20:28.000000000 +0100
@@ -141,10 +141,11 @@ void input_event(struct input_dev *dev,

  		case EV_LED:

-			if (code > LED_MAX || !test_bit(code, dev->ledbit) || 
!!test_bit(code, dev->led) == value)
+			if (code > LED_MAX || !test_bit(code, dev->ledbit))
  				return;

-			change_bit(code, dev->led);
+			if (!!test_bit(code, dev->led) != !!value)
+				change_bit(code, dev->led);

  			if (dev->event)
  				dev->event(dev, type, code, value);
