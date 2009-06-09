Return-Path: <linux-kernel-owner+w=401wt.eu-S1760532AbZFIWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532AbZFIWGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZFIWG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:06:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56368 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750810AbZFIWG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:06:28 -0400
Date: Tue, 9 Jun 2009 23:06:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: regulator_register() API
Message-ID: <20090609220629.GA13204@opensource.wolfsonmicro.com>
References: <20090609135947.GB18591@gundam.enneenne.com> <20090609151834.GA30774@rakim.wolfsonmicro.main> <20090609155235.GK18591@gundam.enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609155235.GK18591@gundam.enneenne.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 05:52:35PM +0200, Rodolfo Giometti wrote:

> Great! However this resolve one issue, the caller still needs to
> allocate a device struct by itsown. On the other hand, doing like
> led_classdev_register() does will resolve it also!

The regulator driver does not need to allocate a struct device.  The
struct device that is passed in is for the chip as a whole and would
normally be something like the struct device for the I2C client.  As
I say it's there mostly for the benefit of printk().

The regulator API returns a pointer to the class device that is
allocated and ensures that that class device is parented by the device
that was passed in.

> As you can see in this case I simply can do:
> 
>         /* Register the led devices */
>         for (i = 0; i < 6; i++)
>                 if (pdata->led[i].name) {
>                         data->led[i].dev.name = pdata->led[i].name;

The code in, for example, the lp3971 driver looks pretty much the same
as this except instead of copying data into the struct it passes data
into the registration API.
