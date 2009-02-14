Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZBNEAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZBNEAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 23:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZBNEAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 23:00:01 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:60203 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZBNEAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 23:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jLbhnnvFqfmMfrwilLU7G+xYNvHaiZsXqTML2xoS/okRT9Yb+NnN3Y/dtqEVOsHRyY
         F5LndwOf9F3mFkvZXEtu1S/oq72IZDBbalxNNBGLEE9h3i3urZTjELtPh+l5+xEraGyI
         ffteabOquhqtbCInU1WEfSqOSeIo9yq/FZNMM=
MIME-Version: 1.0
Date: Sat, 14 Feb 2009 09:59:58 +0600
Message-ID: <b9df5fa10902131959r4f9b9aa6mc00389011b7ce8a1@mail.gmail.com>
Subject: [PATCH -mm] mfd: Fix section mismatch in sm501.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: sameo@openedhand.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch fixes the following warning, caused due to a call from
function sm501_register_gpio() to a function
sm501_gpio_register_chip() which is marked as __devinit function.

  LD      drivers/mfd/built-in.o
WARNING: drivers/mfd/built-in.o(.text+0x16ca): Section mismatch in
reference from the function sm501_register_gpio() to the function
.devinit.text:sm501_gpio_register_chip()
The function sm501_register_gpio() references
the function __devinit sm501_gpio_register_chip().
This is often because sm501_register_gpio lacks a __devinit
annotation or the annotation of sm501_gpio_register_chip is wrong.

WARNING: drivers/mfd/built-in.o(.text+0x1706): Section mismatch in
reference from the function sm501_register_gpio() to the function
.devinit.text:sm501_gpio_register_chip()
The function sm501_register_gpio() references
the function __devinit sm501_gpio_register_chip().
This is often because sm501_register_gpio lacks a __devinit
annotation or the annotation of sm501_gpio_register_chip is wrong.

Thanks.
---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/mfd/sm501.c	2009-02-13 11:26:48.000000000 +0600
+++ rakib/drivers/mfd/sm501.c	2009-02-13 23:34:06.317833808 +0600
@@ -1050,7 +1050,7 @@ static int __devinit sm501_gpio_register
 	return gpiochip_add(gchip);
 }

-static int sm501_register_gpio(struct sm501_devdata *sm)
+static int __devinit sm501_register_gpio(struct sm501_devdata *sm)
 {
 	struct sm501_gpio *gpio = &sm->gpio;
 	resource_size_t iobase = sm->io_res->start + SM501_GPIO;
