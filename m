Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbZCCHsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbZCCHsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZCCHsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:48:00 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:39712 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZCCHr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:47:59 -0500
Date: Tue, 3 Mar 2009 08:47:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: djwong@us.ibm.com, linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] lm90: Support the MAX6648/6692 chips
Message-ID: <20090303084746.14462e04@hyperion.delvare>
In-Reply-To: <20090302150426.b22100c1.akpm@linux-foundation.org>
References: <20090302210106.GD6550@plum>
	<20090302150426.b22100c1.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, 2 Mar 2009 15:04:26 -0800, Andrew Morton wrote:
> On Mon, 2 Mar 2009 13:01:06 -0800
> "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
> > @@ -776,7 +776,12 @@ static int lm90_detect(struct i2c_client *new_client, int kind,
> >  			 && (reg_config1 & 0x3f) == 0x00
> >  			 && reg_convrate <= 0x07) {
> >  				kind = max6646;
> > -			}
> > +			} else
> > +			/* The MAX6648/6692 chips have a working man/chip id
> > +			 * and the same register set as the 6657.
> > +			 */
> > +			if (chip_id == 0x59 && address == 0x4C)
> > +				kind = max6657;
> >  		}
> 
> gack, the indenting and layout there is totally busted.

This specific layout is consistently used through the whole function,
and checkpatch.pl doesn't complain about it. While unconventional, it
has its advantages, in particular it avoids extra indentation that
would make some lines too long. At any rate it doesn't make sense to
change this last chunk without changing all the rest if this layout is
deemed unacceptable.

> --- a/drivers/hwmon/lm90.c~lm90-support-the-max6648-6692-chips-fix
> +++ a/drivers/hwmon/lm90.c
> @@ -776,12 +776,14 @@ static int lm90_detect(struct i2c_client
>  			 && (reg_config1 & 0x3f) == 0x00
>  			 && reg_convrate <= 0x07) {
>  				kind = max6646;
> -			} else
> -			/* The MAX6648/6692 chips have a working man/chip id
> -			 * and the same register set as the 6657.
> -			 */
> -			if (chip_id == 0x59 && address == 0x4C)
> +			} else if (chip_id == 0x59 && address == 0x4C) {
> +				/*
> +				 * The MAX6648/6692 chips have a working
> +				 * man/chip id and the same register set as the
> +				 * 6657.
> +				 */
>  				kind = max6657;
> +			}
>  		}
>  
>  		if (kind <= 0) { /* identification failed */

I thus nack this change of yours.

-- 
Jean Delvare
