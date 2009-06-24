Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZFXOTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZFXOTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZFXOTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:19:37 -0400
Received: from ru.mvista.com ([213.79.90.228]:5399 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751238AbZFXOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:19:36 -0400
Date: Wed, 24 Jun 2009 18:18:34 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       linux kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] ds2782 battery gas gauge driver
Message-ID: <20090624141834.GA9035@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <4A371CDF.3070407@bluewatersys.com> <20090617110908.17b47a18@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090617110908.17b47a18@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 11:09:08AM +0200, Jean Delvare wrote:
> Hi Ryan,
> 
> On Tue, 16 Jun 2009 16:17:35 +1200, Ryan Mallon wrote:
> > Add support for the the ds2782 standalone I2C gas-gauge.
> > 
> > Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> 
> I suggest you send this patch to the maintainers of the power supply
> subsystem for review: Anton Vorontsov and David Woodhouse (Cc'd.)

Thanks for Cc'ing and for the review, Jean.

[...]
> > +static int ds2782_get_temp(struct ds2782_info *info)
> > +{
> > +	u16 raw;
> > +	s16 temp;
> > +
> > +	/* Temperature is measured in units of 0.125 degrees celcius */
> > +	raw = ds2782_read_reg16(info, DS2782_REG_TEMP_MSB);
> > +	temp = (raw >> 5) & 0x7ff;
> > +	if (raw & (1 << 15))
> > +		temp |= 0xf800;
> > +	return (temp * 125) / 100;
> > +}
> 
> I don't know if the power supply class has a standard to reporting
> temperature values, but the hwmon class does, and it says that
> temperatures should be reported in millidegrees C. That's not what you
> do here AFAICS. It might be convenient to register a hwmon class device
> and export the temperature there, so that libsensors picks it.

Hwmon feels like a good idea. But no, drivers should not bother
with registering hwmon classes. Instead, some day we might want to
create power_supply_hwmon.c interface (like _sysfs.c that we have
already), the interface would register all needed stuff. And all
drivers will benefit right away without any modifications.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
