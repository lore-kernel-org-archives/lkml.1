Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbXLGGSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbXLGGSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 01:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXLGGSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 01:18:36 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:36263 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751223AbXLGGSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 01:18:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zDDuEjh0S9XL4DKUaVjcPYtSXlBfw/L0eNxfljWsbH+d1LzBD9NyFHzeOKx2ht5K7BqTjqh1fZI3Co5pVOrd/zYzwk2rZu9PHGYuVOkIBL2xbubtCwp7D9M1GeHx7sbDgpuHvdrJxOwzz6ujgZsZ1G/t2FQJGRQYKPMv9q2+U+8=  ;
X-YMail-OSG: 3425.2UVM1lS12OqJIyHnn2fQyZ6IvtTSJqBCUNmr88FrqLZJGXEcwVU_Ixg3Q9P_rILCFeV9g--
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch/rfc 2/4] pcf857x I2C GPIO expander driver
Date: Thu, 6 Dec 2007 20:02:17 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       "eric miao" <eric.y.miao@gmail.com>, Kevin Hilman <khilman@mvista.com>,
       Paul Mundt <lethal@linux-sh.org>, Ben Dooks <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200712051903.13932.david-b@pacbell.net> <20071207001703.44cbee94@hyperion.delvare>
In-Reply-To: <20071207001703.44cbee94@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712062002.17914.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007, Jean Delvare wrote:

> 	Also, I don't quite see what
> is supposed to make compatibility with the legacy drivers easier, nor
> how, not why it matters in the first place.

There's a clear either/or disjunction.  No fuzzy/confusing middle ground.


> > +static int pcf857x_get8(struct gpio_chip *chip, unsigned offset)
> > +{
> > +	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> > +	s32		value;
> > +
> > +	value = i2c_smbus_read_byte(gpio->client);
> > +	return (value < 0) ? 0 : (value & (1 << offset));
> 
> This is no longer a boolean value, is that OK? I guess that it doesn't
> matter but maybe it should be documented (what GPIO drivers are allowed
> to return in these callback functions.)

Already documented -- as zero/nonzero, the original boolean model for C.
Anything else would be at least tristate, not boolean.  :)


> > +	/* Let platform code set up the GPIOs and their users.
> > +	 * Now is the first time anyone can use them.
> > +	 */
> > +	if (pdata->setup) {
> > +		status = pdata->setup(client,
> > +				gpio->chip.base, gpio->chip.ngpio,
> > +				pdata->context);
> > +		if (status < 0)
> > +			dev_err(&client->dev, "%s --> %d\n",
> > +					"setup", status);
> 
> Shouldn't this be degraded to dev_warn? The probe still succeeds. Or
> keep dev_err but make the probe fail (in which case you'll probably
> want to swap this block of code with the dev_info above.)

Good point.


> The rest looks fine to me.

Thanks for the comments.  I'll send this in with the next batch
of gpiolib patches.

- Dave

