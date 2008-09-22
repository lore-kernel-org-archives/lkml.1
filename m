Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYIVPLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYIVPLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYIVPLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:11:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:41574 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYIVPLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:11:38 -0400
Message-ID: <f488382f0809220811y46e9daf3r5db5a7c76df87800@mail.gmail.com>
Date: Mon, 22 Sep 2008 08:11:30 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Senthilkumar Balasubramanian" 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080922080632.GA20446@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <1221944338.3023.8.camel@johannes.berg>
	 <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com>
	 <f488382f0809201422rdabeff4g435bf3d4a7e9fa3@mail.gmail.com>
	 <43e72e890809201426x61c94bfej2dcda1c178be81b@mail.gmail.com>
	 <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com>
	 <f488382f0809201848w1e59cc19i8235c7c74c44fc10@mail.gmail.com>
	 <20080922065453.GD19580@tesla>
	 <f488382f0809220026u9afa355g1ff2cc7a3fe88333@mail.gmail.com>
	 <20080922080632.GA20446@tesla>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 1:06 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Please test the following patch.
>
> diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
> index c262ef2..9a51739 100644
> --- a/drivers/net/wireless/ath9k/core.c
> +++ b/drivers/net/wireless/ath9k/core.c
> @@ -681,10 +681,12 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
>         * Enable MIB interrupts when there are hardware phy counters.
>         * Note we only do this (at the moment) for station mode.
>         */
> +#if 0
>        if (ath9k_hw_phycounters(ah) &&
>            ((sc->sc_ah->ah_opmode == ATH9K_M_STA) ||
>             (sc->sc_ah->ah_opmode == ATH9K_M_IBSS)))
>                sc->sc_imask |= ATH9K_INT_MIB;
> +#endif
>        /*
>         * Some hardware processes the TIM IE and fires an
>         * interrupt when the TIM bit is set.  For hardware
>

It didn't apply to -rc7, but I managed to apply it manually
(apparently you made this for wireless-testing?) and added the #if 0.
After 7 hours uptime with the driver, no apparent interrupt storm.

I'll do more thorough testing later, but I have a 3 hour drive today,
and some packing to do, so it'll need to wait a bit.

- Steven
