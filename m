Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbXFWIdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbXFWIdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 04:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbXFWIdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 04:33:24 -0400
Received: from smtp-106-saturday.noc.nerim.net ([62.4.17.106]:1142 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752691AbXFWIdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 04:33:23 -0400
Date: Sat, 23 Jun 2007 10:34:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Vojtech Pavlik" <vojtech@ucw.cz>
Subject: Re: Writing a driver for a legacy serial device
Message-ID: <20070623103435.7c54d047@hyperion.delvare>
In-Reply-To: <d120d5000706221247g618fffadh2c4296aa62a39b9e@mail.gmail.com>
References: <20070619190502.05d4e0c8@hyperion.delvare>
	<d120d5000706191159w29ebd0dajbd6cb9ac78d4faa2@mail.gmail.com>
	<20070620105648.6d18ad66@hyperion.delvare>
	<200706202311.33326.dtor@insightbb.com>
	<20070621113358.1d65678d@hyperion.delvare>
	<d120d5000706221247g618fffadh2c4296aa62a39b9e@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Fri, 22 Jun 2007 15:47:43 -0400, Dmitry Torokhov wrote:
> On 6/21/07, Jean Delvare <khali@linux-fr.org> wrote:
> >
> > OK. This leads me to a question: is it OK for me to add support for my
> > non-input device to inputattach, or is a separate, dedicated helper
> > tool preferred? Both ways are fine with me, I don't know what the input
> > subsystem maintainers expect.
> 
> Your device does not need any initialization done by userspace, does
> it?

No, it doesn't. But it wants a specific serial line speed and mode.

> How widespread is this device?

Not widespread. It's a family of evaluation modules for I2C/SMBus
chips. They will mainly be used to develop and test chip drivers, I
suppose. But OTOH, I'm not sure how it matters. We're in year 2007, I
pretty much doubt that any of the devices supported by inputattach is
still in widespread use. As a matter of fact, inputattach has been
broken in Suse for half of the supported devices for almost two years
now, and I couldn't find any bug report about it.

> inputattach has "--dump" option
> which sets up a SERIO_RS232/0/0/0 serio port. You could mark your
> serio driver as manual bind driver and bind it trhough sysfs (echo -n
> "taos-evm" /sys/device/serio/devices/serioX/drvctl to bind it).

One problem I foresee is that the dump mode sets the port to 2400 bps,
while my evaluation module wants 1200 bps.

Another problem is that the dump mode of inputattach doesn't appear to
create a serio device. Probably not very surprising, as dump_init()
never returns. So I don't think I can use that.

-- 
Jean Delvare
