Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbYCJIHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbYCJIHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYCJIH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:07:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:42320 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYCJIH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:07:28 -0400
Subject: Re: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Colin Leroy <colin@colino.net>
Cc: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080310084633.5246ecfe@paperstreet.colino.net>
References: <47D47B11.1000303@tiscali.nl>
	 <20080310084633.5246ecfe@paperstreet.colino.net>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 19:06:53 +1100
Message-Id: <1205136413.8621.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-10 at 08:46 +0100, Colin Leroy wrote:
> On Mon, 10 Mar 2008 01:04:33 +0100, Roel Kluin wrote:
> 
> Hi,
> 
> > logical-bitwise & confusion
> 
> Looks good to me, but I'm not really maintaining that anymore :-)
> I'm not sure who does, Cc:ing Benjamin as he'll probably know.

Nobody is U suspect...

Send it to the list linuxppc-dev@ozlabs.org, it should be picked up
anyway.

Ben.

> > Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> > ---
> > diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
> > index 9587869..8ea7da2 100644
> > --- a/drivers/hwmon/adt7473.c
> > +++ b/drivers/hwmon/adt7473.c
> > @@ -570,7 +570,7 @@ static ssize_t set_max_duty_at_crit(struct device
> > *dev, struct i2c_client *client = to_i2c_client(dev);
> >  	struct adt7473_data *data = i2c_get_clientdata(client);
> >  	int temp = simple_strtol(buf, NULL, 10);
> > -	temp = temp && 0xFF;
> > +	temp &= 0xFF;
> >  
> >  	mutex_lock(&data->lock);
> >  	data->max_duty_at_overheat = temp;
> > 
> 

