Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbYL3Mn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbYL3Mn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYL3Mnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:43:45 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37333 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYL3Mnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:43:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ffpf+98ErGcx/nP9XO4uioYineyE4CoquuXrXDLcxeKAZf78ORbXw32FTTWOSTOyYi
         wwOOp9V3cwGKfUbhBYi81X9SwhWSExjxEuPWMo1Cj0sd37XS96dv0nbjCkG6iR3u22NZ
         QpCk8Wss0wO2NF1GpJy5eYOmX/hFkMA3+VSQc=
Subject: Re: [ath5k-devel] Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
In-Reply-To: <20081230042630.GA13664@hash.localnet>
References: <491506DB.1070000@gmail.com>
	 <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com>
	 <4918A8C5.3050607@gmail.com>
	 <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com>
	 <1229174904.4964.5.camel@maxim-laptop>
	 <20081213142444.GA19852@hash.localnet>
	 <20081230042630.GA13664@hash.localnet>
Content-Type: text/plain
Date: Tue, 30 Dec 2008 14:43:36 +0200
Message-Id: <1230641016.5770.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 23:26 -0500, Bob Copeland wrote:
> On Sat, Dec 13, 2008 at 09:24:45AM -0500, Bob Copeland wrote:
> > > Indeed gpio #3 controls the led.
> > > I patched ath5k to use it, and led works now fine.
> 
> Sorry for the delay, can you test this patch?
> 
> From: Bob Copeland <me@bobcopeland.com>
> Date: Mon, 29 Dec 2008 23:14:24 -0500
> Subject: [PATCH] ath5k: support LEDs on aspire one laptop
> 
> Add vendor ID for Foxconn and use it to set the ath5k LED gpio and
> polarity for Acer branded laptops.
> 
> base.c:
> Changes-licensed-under: 3-Clause-BSD
> 
> Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.c |    7 +++++++
>  include/linux/pci_ids.h           |    2 ++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 40c0155..eb0675f 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2595,6 +2595,13 @@ ath5k_init_leds(struct ath5k_softc *sc)
>  		sc->led_pin = 1;
>  		sc->led_on = 1;  /* active high */
>  	}
> +	/* Pin 3 on Foxconn chips used in Aspire One A150 (0x105b:e008) */
> +	if (pdev->subsystem_vendor == PCI_VENDOR_ID_FOXCONN) {
> +		__set_bit(ATH_STAT_LEDSOFT, sc->status);
> +		sc->led_pin = 3;
> +		sc->led_on = 1;  /* active high */
> +	}
> +
>  	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
>  		goto out;
>  

Sure, will test, I am also sure that this will work.

Unfortunely mac8211 is broken in regard to led handling.

Since ath5k doesn't do timers, led blinks very often, thus usually I
don't even see it, and moreover sometimes it gets 'inverted' and I
tested and this looks like software issue, just writing numbers to /sys
led interface works but triggers from mac8211, they are inverted.

This issue is masked on my iwl3945 since they use mac led triggers only
as a "suggestion" and blink the leds according to their own traffic
measurement, and timers (and still the code that should blink led at
different rates doesn't work, still led ether blinks or not at constant
rate)

Best regards,
	Maxim Levitsky

