Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0BMNyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:54:52 -0500
Received: from mail-bw0-f216.google.com ([209.85.218.216]:61319 "EHLO
	mail-bw0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab0BMNyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:54:51 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2010 08:54:51 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=deAR/trR//27RLp0F7xTQXFKKCVMLn3oMGCu/KFUi+qcTNwffGB1X49gWgBrd/Erqw
         08uH5WMTPPpRNF/m83un48unPpBwUB80XcUZ0Z57o8foyzCsC69ZsJY5Qvz8jsRmx4tK
         jydxBaFhiQ2DTaNpDqy5XBXn35fwmzJd9rcJ0=
MIME-Version: 1.0
In-Reply-To: <dc6d3181002122148v6451ebffka164de288738485d@mail.gmail.com>
References: <dc6d3181002122148v6451ebffka164de288738485d@mail.gmail.com>
Date: Sat, 13 Feb 2010 14:48:22 +0100
Message-ID: <63386a3d1002130548y7c839072y85097a9bcdf66cad@mail.gmail.com>
Subject: Re: [spi-devel-general] SPI-ADC
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: arjun rath <rath.arjun@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net,
       linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/13 arjun rath <rath.arjun@gmail.com>:

> can anybody share how to start a spi based ADC linux driver.I am having a
> MAXIM 1242 ADC chip.

The ḱernel does not contain any generic ADC subsystem abstraction (I
think it would be good if it did), instead most drivers using ADC have
their ADC portions stored inside a driver for something else, e.g.
drivers/hwmon for ADCs used in temperature monitoring, or
drivers/power for ADCs used in monitoring of currents and voltages
for power supplies/batteries.

This is a bit bad for driving a generic ADC like this using spidev and,
even if it was to be accessed from userspace only, having it under
drivers/spi is rather counterintuitive, what happens when the next ADC
using I2C turns up? drivers/i2c/chips?

I would suggest creating subsystem drivers/adc if you have time and
energy, other ideas?

Linus Walleij
