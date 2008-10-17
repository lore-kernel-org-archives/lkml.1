Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYJQUb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYJQUb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 16:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYJQUbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 16:31:48 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:34623 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752569AbYJQUbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 16:31:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Vr17/Kdg/Njcpsywbp5TE7UVJrddfUH9Mv5adxCp9nwn+UIJc4WKhRcTVZxDE3j49eClAJfb0PBhyabAI+MYGsN/cjai7hi78zejA91bHh6uEELBExRtdURzcP/hIDUm4gBeTnBmCM6vu62v/p6T24/d0XthfhYEuUoIaRrSmJw=  ;
X-YMail-OSG: .NVSMQoVM1lhaBUa8pv83jp5F6DXT5er3DDUOeCJ7_CjOtuqvFCK2zbM3dSteNbJRkR6QQNEz1wvlDQWKMLtuoJgXHbdvqIWS.wX3UZWKyI3kZNCJklW9GRhYifpfHzyZ0rwsGy37dhoPoKrc_Df_n8rFZp_NVWqNIBToGs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Date: Fri, 17 Oct 2008 13:24:42 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081016171259.GD5515@oksana.dev.rtsoft.ru>
In-Reply-To: <20081016171259.GD5515@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810171324.42650.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008, Anton Vorontsov wrote:
> +/*
> + * Platforms can define their own __dev_ versions to glue gpio_chips with the
> + * architecture-specific code.
> + */
> +#ifndef __dev_gpiochip_add
> +#define __dev_gpiochip_add __dev_gpiochip_add
> +static inline int __dev_gpiochip_add(struct device *dev,
> +                                    struct gpio_chip *chip)
> +{
> +       chip->dev = dev;
> +       return gpiochip_add(chip);
> +}
> +#endif /* __dev_gpiochip_add */

This is pretty ugly, especially the implication that *EVERY* gpio_chip
provider needs modification to use these calls.

Surely it would be a lot simpler to just add platform-specific hooks
to gpiochip_{add,remove}(), so that no providers need to be changed??


> +#ifndef __dev_gpiochip_remove
> +#define __dev_gpiochip_remove __dev_gpiochip_remove
> +static inline int __dev_gpiochip_remove(struct device *dev,
> +                                       struct gpio_chip *chip)
> +{
> +       return gpiochip_remove(chip);
> +}
> +#endif /* __dev_gpiochip_remove */


