Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYLMOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYLMOjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 09:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbYLMOjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 09:39:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:1875 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbYLMOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 09:38:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H9uVog/3VSWW+B8oqv8LUKPIkQJRNgfybuuM3wcaF5dyJlWmlL5YAuUn9bsn4CgFKP
         Ob/U+aMdqxrh0gTmiFSoGJMYPLDPdpW4+8Zqen7poAS9JleuiEzK3FqHZ+c3bTyGHMH0
         1BE2yssNoO5Gp5ANpg0/7KHvNxteSx/46qoSg=
Subject: Re: [ath5k-devel] Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
In-Reply-To: <1229179013.4936.20.camel@maxim-laptop>
References: <491506DB.1070000@gmail.com>
	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
	 <4918A8C5.3050607@gmail.com>
	 <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
	 <1229174904.4964.5.camel@maxim-laptop>
	 <40f31dec0812130608x73266375n7b3367938ad687b8@mail.gmail.com>
	 <1229179013.4936.20.camel@maxim-laptop>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 16:38:50 +0200
Message-Id: <1229179130.4936.22.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 16:36 +0200, Maxim Levitsky wrote:
> On Sat, 2008-12-13 at 16:08 +0200, Nick Kossifidis wrote:
> > 2008/12/13 Maxim Levitsky <maximlevitsky@gmail.com>:
> > >
> > > Hi,
> > >
> > > Indeed gpio #3 controls the led.
> > > I patched ath5k to use it, and led works now fine.
> > >
> > >
> > 
> > Please share your patch with the rest and also post an lspci -vnn for
> > your card so we can handle this in a generic way
> 
> This just a one liner hack
> 
> diff --git a/drivers/net/wireless/ath5k/base.c
> b/drivers/net/wireless/ath5k/base.c
> index 9d2c597..a447937 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2595,6 +2595,11 @@ ath5k_init_leds(struct ath5k_softc *sc)
>  		sc->led_pin = 1;
>  		sc->led_on = 1;  /* active high */
>  	}
> +
> +	__set_bit(ATH_STAT_LEDSOFT, sc->status);
> +	sc->led_pin = 3;
> +	sc->led_on = 1;
> +
>  	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
>  		goto out;
> 
> 
> 

> 
> Best regards,
> 	Maxim Levitsky
> 

Note: thus makes led to be off by default, otherwise set
sc->led_on = 0

this also works

Regards,
	Maxim Levitsky

