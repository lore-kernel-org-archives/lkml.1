Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZJUUUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZJUUUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZJUUUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:20:50 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33557 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZJUUUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pRhmiohKs6DlgLRYF3OuKSMjokK/Y+9+CdCaf+TxWcO7bZt7XApXQjsYoPVSoFYbPI
         Af2geZThAtaCuAlAoxLJW48HpiJnDoisGSqYpCrp+H6zvlybUYVjNZw6dLYRk5EmiuMT
         viHvFSwAuwHYYTgx4yfoWt9APRB5+F/7n8+dY=
MIME-Version: 1.0
In-Reply-To: <20091019213751.GC1482@ucw.cz>
References: <20091019213751.GC1482@ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 22 Oct 2009 04:20:34 +0800
Message-ID: <f17812d70910211320s29d3aaa5tad3206df1e99e03b@mail.gmail.com>
Subject: Re: spitz backlight: fix brightness limiting
To: Richard Purdie <rpurdie@rpsys.net>, Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a little bit weird it's called 'limit_mask' when I first converted it
to a spi driver. There must be some reasons, Richard, you've got
any ideas?

On Tue, Oct 20, 2009 at 5:37 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> On spitz (& similar) machines, if battery is running low, backlight
> needs to be limited to lower step. Unfortunately, current code uses &=
> for limiting, turning backlight off completely for some backlight
> settings. Fix that.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> --- linux-rc/drivers/video/backlight/corgi_lcd.c        2009-10-18 18:11:36.000000000 +0200
> +++ linux-rc/drivers/video/backlight/corgi_lcd.c        2009-10-16 02:10:13.000000000 +0200
> @@ -433,8 +434,9 @@
>
>        if (corgibl_flags & CORGIBL_SUSPENDED)
>                intensity = 0;
> -       if (corgibl_flags & CORGIBL_BATTLOW)
> -               intensity &= lcd->limit_mask;
> +
> +       if ((corgibl_flags & CORGIBL_BATTLOW) && intensity > lcd->limit_mask)
> +               intensity = lcd->limit_mask;
>
>        return corgi_bl_set_intensity(lcd, intensity);
>  }
>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
