Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYCIU4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYCIU4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYCIU4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:56:23 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:40284 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751002AbYCIU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:56:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JqJ5wUUs0S+lPlHktryKgyztT93mXru4xHrmV3n8phukt/pNUK7JND2MLYfAfmQLyKZHK+2AHoYMlOE/TpinH07iy67yme/vzdQ+ppB++SrWJTLCOiZraadL2auc4jUjkLtWwIuPMb4niMM271Q7wfmMPoZCGppFIaAFK1m53oM=  ;
X-YMail-OSG: YPjbhiEVM1mXfsTcvKm1hE80Cv0p1DWSakKWYkXArdWX8JadV9tgLFl.GBrJMxpfWf.1D8cnvA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc4] gpio/pca953x bugfix: mark as can_sleep
Date: Sun, 9 Mar 2008 12:56:19 -0800
User-Agent: KMail/1.9.6
Cc: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>,
       eric miao <eric.y.miao@gmail.com>, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091356.20024.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pca953x driver is an I2C driver so gpio_chip->can_sleep should be set.
This lets upper layers know they should use the gpio_*_cansleep() calls
to access values, and may not access them from nonsleeping contexts.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Merge before 2.6.25-final, please.  This will for example prevent
leds-gpio from issuing blocking I2C calls from timer/irq contexts.

 drivers/gpio/pca953x.c |    1 +
 1 file changed, 1 insertion(+)

--- g26.orig/drivers/gpio/pca953x.c	2008-03-08 11:17:22.000000000 -0800
+++ g26/drivers/gpio/pca953x.c	2008-03-09 13:51:13.000000000 -0700
@@ -184,6 +184,7 @@ static void pca953x_setup_gpio(struct pc
 	gc->direction_output = pca953x_gpio_direction_output;
 	gc->get = pca953x_gpio_get_value;
 	gc->set = pca953x_gpio_set_value;
+	gc->can_sleep = 1;
 
 	gc->base = chip->gpio_start;
 	gc->ngpio = gpios;
