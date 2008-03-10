Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbYCJJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYCJJO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 05:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYCJJOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 05:14:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:43674 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYCJJN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 05:13:59 -0400
In-Reply-To: <47D4EFC1.1050403@tiscali.nl>
References: <47D47B11.1000303@tiscali.nl>	 <20080310084633.5246ecfe@paperstreet.colino.net> <1205136413.8621.3.camel@pasglop> <47D4EFC1.1050403@tiscali.nl>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <64d5b5e6dfd0d1820d21db323ef88e25@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
Date: Mon, 10 Mar 2008 10:13:34 +0100
To: Roel Kluin <12o3l@tiscali.nl>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
> index 9587869..8ea7da2 100644
> --- a/drivers/hwmon/adt7473.c
> +++ b/drivers/hwmon/adt7473.c
> @@ -570,7 +570,7 @@ static ssize_t set_max_duty_at_crit(struct device 
> *dev,
>  	struct i2c_client *client = to_i2c_client(dev);
>  	struct adt7473_data *data = i2c_get_clientdata(client);
>  	int temp = simple_strtol(buf, NULL, 10);
> -	temp = temp && 0xFF;
> +	temp &= 0xFF;
>
>  	mutex_lock(&data->lock);
>  	data->max_duty_at_overheat = temp;

The & 0xff here is bogus anyway; temp is only ever used as an u8,
so just declare it as that, or do proper overflow/underflow checking
on it.  The patch will need testing on hardware too, since it changes
behaviour (it should be a bugfix, but who knows).


Segher

