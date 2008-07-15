Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbYGOGEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbYGOGEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbYGOGEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:04:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:25206 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYGOGEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=uKO+IVyYzo1lPeg/4hzCdh9DOh2WoJADy4rr9tNGwFEYgaJ6DHEGHNwmEICQr3bzka
         g14JjJLD1QRaUXg1GRH1UPTLQuO2KCeVOomW99uvonAG5QYXz3reQAabqSzJnU3H4isj
         ffQjTId0U59Eo/FUpXmJZc8IjCbSFOV+/cgho=
Message-ID: <aecf5e530807142304m60ef0cb2pe1c3592ae1abc7eb@mail.gmail.com>
Date: Tue, 15 Jul 2008 11:34:23 +0530
From: "sasa sasa" <sasak.1983@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Set_up irq problem while using gpio
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have query that the below patch has to applied on irq/manage.c file or not.
--- kernel_old/irq/manage.c 2008-02-07 22:11:14.000000000 +0530
+++ kernel_new/irq/manage.c 2008-02-07 22:19:14.000000000 +0530
@@ -349,8 +349,14 @@
        /* Setup the type (level, edge polarity) if configured: */
        if (new->flags & IRQF_TRIGGER_MASK) {
            if (desc->chip && desc->chip->set_type)
-               desc->chip->set_type(irq,
-                       new->flags & IRQF_TRIGGER_MASK);
+           {
+               if((desc->chip->set_type(irq,
+                       new->flags & IRQF_TRIGGER_MASK)))
+               {
+                   spin_unlock_irqrestore(&desc->lock, flags);
+                   return -ESPIPE;
+               }
+           }
            else
                /*
                 * IRQF_TRIGGER_* but the PIC does not support

The reason is that in case of gpio pins used as interrupt pin but that
pin has already been ocuupied in other mode (like alternate function
mode or in software mode) by other device. In that case, some error
mechanism must be there, if we are requesting that gpio pin as
interrupt through request_irq function.

Regards
Sasa
