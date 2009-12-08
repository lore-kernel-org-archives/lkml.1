Return-Path: <linux-kernel-owner+w=401wt.eu-S935602AbZLHEYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935602AbZLHEYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 23:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935079AbZLHEYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 23:24:16 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:39298 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934929AbZLHEYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 23:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TiCzxptFZF35J6bMa/pPkk46fk3yo1ZH/jQB3RIfeEzN1SDptmLT59tF1Q3Dii5pxb
         uTIo7wGFZeia75u2OsqxxiGhN4jpxbCb5JUsyV1LUduKTdfQv9U3Pg6KHlUAz3y+u0gB
         VjagbIWNmfd8Db3Y+Y84EdSB9kyKOUT139340=
Date: Mon, 7 Dec 2009 20:24:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Gary Stein <lordcnidarian@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver/input/ff-memless.c
Message-ID: <20091208042417.GD11147@core.coreip.homeip.net>
References: <fce72f9b0912071137i1f2d7952tf70b83d4ba5686f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fce72f9b0912071137i1f2d7952tf70b83d4ba5686f8@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary,

On Mon, Dec 07, 2009 at 02:37:30PM -0500, Gary Stein wrote:
> I was experiencing force feedback joystick issues in my Force 3D Pro and
> when developing a new driver for the new Logitech G940 after I
> recompiled my kernel.
> 
> I was able to track it down to a signed vs unsigned problem in
> ff-memless.c and gcc 4.4.2.
> The code in question did not seem to give a problem with gcc 4.2.4.
> 
> According to gitweb, a signed vs unsigned was changed on May 8th by
> Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Input: ff-memless - fix signed to unsigned bit overflow
> 
> to change the gain from a signed to an unsigned int to fix a rumble
> issue, but it appears to broke a the
> constant force section of the code.
> 
> It is a simple, cast to fix and should not have any ill effects.
> 

Could I please have your "Signed-off-by: ..."? Thanks.

> gary
> 
> 
> --- linux-2.6.31.orig/drivers/input/ff-memless.c	2009-09-09
> 17:13:59.000000000 -0500
> +++ linux-2.6.31.int/drivers/input/ff-memless.c	2009-12-07
> 15:09:22.000000000 -0500
> @@ -239,8 +239,8 @@
>  		level = fixp_new16(apply_envelope(state,
>  					new->u.constant.level,
>  					&new->u.constant.envelope));
> -		x = fixp_mult(fixp_sin(i), level) * gain / 0xffff;
> -		y = fixp_mult(-fixp_cos(i), level) * gain / 0xffff;
> +		x = (int)(fixp_mult(fixp_sin(i), level) * gain) / 0xffff;
> +		y = (int)(fixp_mult(-fixp_cos(i), level) * gain) / 0xffff;
>  		/*
>  		 * here we abuse ff_ramp to hold x and y of constant force
>  		 * If in future any driver wants something else than x and y

-- 
Dmitry
