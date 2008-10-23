Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYJWRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYJWRVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYJWRVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:21:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43505 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYJWRVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:21:07 -0400
Date: Thu, 23 Oct 2008 19:20:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: linux-kernel@vger.kernel.org, ben-linux@fluff.org,
       Len Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: scx200_i2c driver fails to detect any i2c devices in 2.6.26
Message-ID: <20081023192056.49656653@hyperion.delvare>
In-Reply-To: <20081023165419.GA5682@csclub.uwaterloo.ca>
References: <20081023165419.GA5682@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lennart,

On Thu, 23 Oct 2008 12:54:19 -0400, Lennart Sorensen wrote:
> In 2.6.18, the scx200_i2c driver was working just fine.  Now while
> moving to 2.6.26 I find that the bus no longer locates any devices when
> drivers are loaded, even though i2cdetect has no problem locating
> devices on the bus.
> 
> After some searching, I discovered that the scx200_i2c driver doesn't
> have a .class parameter filled in, even though every other i2c driver
> does.  A small patch adding the .class parameter fixes the problem.

Correct. Not sure how we missed this for years.

> Not sure if it should be I2C_CLASS_ALL or I2C_CLASS_HWMON, or even
> I2C_CLASS_HWMON | I2C_CLASS_SPD (in current git tree).  Using
> I2C_CLASS_ALL works for me and works with my lm75, m41t81 and spd
> eeprom in 2.6.26.

I2C_CLASS_HWMON | I2C_CLASS_SPD please. I2C_CLASS_ALL is almost never
what people want, and actually I'm thinking of removing it to prevent
developers from getting it wrong.

> 
> --- a/drivers/i2c/busses/scx200_i2c.c	2008-07-13 17:51:29.000000000 -0400
> +++ b/drivers/i2c/busses/scx200_i2c.c	2008-10-23 12:41:02.000000000 -0400
> @@ -81,6 +81,7 @@
>  
>  static struct i2c_adapter scx200_i2c_ops = {
>  	.owner		   = THIS_MODULE,
> +	.class             = I2C_CLASS_ALL,
>  	.id		   = I2C_HW_B_SCX200,
>  	.algo_data	   = &scx200_i2c_data,
>  	.name	= "NatSemi SCx200 I2C",
> 


-- 
Jean Delvare
