Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZJ1FnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZJ1FnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbZJ1FnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:43:11 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:55630 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbZJ1FnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hJYIkqfEkxshNnKDrc4YF7HDXYGIRvnsfHk6FZipQEU7IKlmf6fyK2IoYrD74+5FQB
         2QSQn2GNZIRiuOZRpFtSzncC+FIS6xnIBWZuK4DWo9rYQtBmSrtixk+CavId8pRT1UzY
         lJFjiQ2CGopsmJctA1qQxfcIipPAGUfElMNUI=
Date: Tue, 27 Oct 2009 22:43:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [PATCH][RFC] input: remove bios I8042_CTR_XLATE check to make
	keyboard usable
Message-ID: <20091028054309.GA2368@core.coreip.homeip.net>
References: <20091027053404.GA2241@darkstar.vlan7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027053404.GA2241@darkstar.vlan7>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, Oct 27, 2009 at 01:34:04PM +0800, Dave Young wrote:
> 
> Pressing somekey at early booting phase cause keyboard to be not usable
> (The hardware is DELL latitude e5400):
> 
> atkbd.c: Unknown key pressed (raw set 2, code 0xd3 on isa0060/serio0).
> atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> atkbd.c: Unknown key pressed (raw set 2, code 0x1d3 on isa0060/serio0).
> atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> 
> i8042.c set i8042_direct to true when the controller init. But the result
> is keyboard not usable, The only option is press the power button to shutdown. 
> 
> So here remove the bios check to fix it.
> 

I would be a little hesitant to force translation by default on all
architectures, although it may make sense on x86...

Vojtech, you wrote the thing, do you see any issues with forcing
translation? I think most of the x86 boxes work in translated mode and
the only time it is in raw is when BIOS screwed up initialization.

> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
>  drivers/input/serio/i8042.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> --- linux-2.6.orig/drivers/input/serio/i8042.c	2009-10-13 08:57:07.000000000 +0800
> +++ linux-2.6/drivers/input/serio/i8042.c	2009-10-27 13:15:13.000000000 +0800
> @@ -869,14 +869,6 @@ static int i8042_controller_init(void)
>  	spin_unlock_irqrestore(&i8042_lock, flags);
>  
>  /*
> - * If the chip is configured into nontranslated mode by the BIOS, don't
> - * bother enabling translating and be happy.
> - */
> -
> -	if (~i8042_ctr & I8042_CTR_XLATE)
> -		i8042_direct = true;
> -
> -/*
>   * Set nontranslated mode for the kbd interface if requested by an option.
>   * After this the kbd interface becomes a simple serial in/out, like the aux
>   * interface is. We don't do this by default, since it can confuse notebook

-- 
Dmitry
