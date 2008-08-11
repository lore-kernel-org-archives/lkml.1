Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbYHKHER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbYHKHER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 03:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYHKHEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 03:04:07 -0400
Received: from mail.hevs.ch ([153.109.23.10]:48239 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbYHKHEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 03:04:06 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC,PATCH] i2c: fix device_init_wakeup place
Date: Mon, 11 Aug 2008 09:03:58 +0200
User-Agent: KMail/1.9.9
Cc: khali@linux-fr.org, linux-kernel@vger.kernel.org, i2c@lm-sensors.org
References: <200807291535.45689.marc.pignat@hevs.ch> <20080809185619.6211fbf3@hyperion.delvare> <20080810230404.B2943B2AB@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20080810230404.B2943B2AB@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808110903.58658.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

First, I would like to ask David to exuse me for saying something like "your
patch did nothing", it was crude.

David had a real good idea to add the flag I2C_CLIENT_WAKE.


On Monday 11 August 2008, David Brownell wrote:
> > > The current code calls device_init_wakeup() before device_register, but
...
> > Interesting point... David, what are you using this code for then? Same
> > question for you Marc.
...

I use it for an rtc chip (ds1374), but the board is not in tree (should be
soon).

> 
> 
> > > This patch also include a small functionnal change: the I2C_CLIENT_WAKE
> > > is no more removed from the client flags, but this should't hurt.
> >
> > Why do you want to change this?
> 
> It's kind of essential to making this patch work!  Else the flag
> won't be available when the i2c core gets control of that device
> node again, after device_initialize() code zeroes those flags.

Now the flag is used in the i2c_device_probe function and must be preserved
for future use (probe of another device or re-probe).

The downside is that it make this flag visible to the i2c_client.

To preserve the original behavior (hide the flag to the driver), the flag
should be saved, for instance in the i2c_device structure.
I think adding more code and adding a field in the i2c_device structure costs
more than making this flag visible (but if you think differently, I can fix the
patch).



> 
> 
...
> Better would be to preserve any existing settings:
> 
> 	if (!device_can_wakeup(&client->dev))
> 		device_init_wakeup(...)
> 
> That way the userspace policy setting is preserved unless the
> device itself gets removed ... instead of being clobbered by
> the simple act of (re)probing a driver.
Ok, will be fixed in version 2


Best regards

Marc
