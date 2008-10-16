Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYJPRMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYJPRMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYJPRMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:12:24 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7076 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751507AbYJPRMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:12:24 -0400
Date: Thu, 16 Oct 2008 21:12:22 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 0/7 RFC] Handle I2C GPIO controllers with the OF (was:
	pca9539 I2C gpio expander)
Message-ID: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Recently there was a question about I2C GPIO controllers and how should
we handle them with the OpenFirmware and such.

Here is the attempt to "connect" I2C GPIO controllers to the
"OpenFirmware" device tree, without writing an OF-specific bindings
for each driver.

The salt is in these two patches:

[PATCH 3/7] of: fill the archdata for I2C devices
^ Here we're storing the device tree node into the I2C device.

[PATCH 5/7] of/gpio: implement of_dev_gpiochip_{add,remove} calls
^ And here we extracting the the stored node to put the registered
  of_gpio_chip into that node.


How does it look?

p.s. The original question:

----- Forwarded message from "Steven A. Falco" <sfalco@harris.com> -----

Date: Tue, 14 Oct 2008 14:10:25 -0400
From: "Steven A. Falco" <sfalco@harris.com>
To: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: pca9539 I2C gpio expander
List-Id: Linux on PowerPC Developers Mail List <linuxppc-dev.ozlabs.org>

I am attempting to use a pca9539 I2C gpio driver on a PPC440EPx board.  The
driver is "drivers/gpio/pca953x.c".  I've added an entry to the .dts file:

IIC0: i2c@ef600700 {
	compatible = "ibm,iic-440epx", "ibm,iic";
	...
	pca9539@76 {
		compatible = "ti,pca9539";
		reg = <76>;
	};
};

of_register_i2c_devices sees this entry and calls i2c_new_device.
i2c_new_device copies info->platform_data to client->dev.platform_data, but
I think that this structure is empty (at least I don't see where
of_register_i2c_devices would set it).

pca953x_probe is eventually called, but it expects to find its "lowest gpio
number" in client->dev.platform_data->gpio_base, which has not been set.  So
pca953x_probe returns -ENODEV.

I don't understand where the disconnect is.  Should I be able to use the
pca953x.c driver, or is it somehow incompatible?

If it is incompatible, is there a strategy for making it compatible?

	Steve
_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc-dev

----- End forwarded message -----
