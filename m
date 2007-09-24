Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbXIXKgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbXIXKgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXIXKgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:36:22 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:60437 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752839AbXIXKgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:36:22 -0400
Date: Mon, 24 Sep 2007 12:34:08 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: giometti@enneenne.com, i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       rpurdie@rpsys.net
Subject: Re: [Linux-fbdev-devel] [RFC] driving a LCD panel via I2C
Message-ID: <20070924123408.596a3c69@dhcp-255-175.norway.atmel.com>
In-Reply-To: <41784.213.84.50.107.1190624288.squirrel@webmail.enneenne.com>
References: <41784.213.84.50.107.1190624288.squirrel@webmail.enneenne.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 10:58:08 +0200 (CEST)
"Rodolfo Giometti" <giometti@enneenne.com> wrote:

> Hello,
> 
> I have an LCD panel on a custom PXA27x based board and it must be
> turned on/off by some special commands via a GPIO throught a I2C chip.
> 
> I'd like some suggestion about I can easily manage this situation.

I have a similar panel in the sense that it needs a bunch of SPI
commands to get started. I implemented a LCD driver
(drivers/video/backlight) for it so that it is automatically turned
on/off at bootup/shutdown, and can be manually turned on/off
through /sys/class/lcd/ltv350qv/power. AFAIK the driver is currently
sitting in the backlight tree scheduled for inclusion in 2.6.24.

> Maybe can I add a special I2C function to get i2c_client pointer and
> then using it to send on/off commands to the LCD?

Just implement it as a regular I2C chip driver which registers a device
with the LCD framework when it is successfully probed.

Håvard
