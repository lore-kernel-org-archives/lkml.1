Return-Path: <linux-kernel-owner+w=401wt.eu-S1762851AbZDHJ7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851AbZDHJ7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZDHJ7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:59:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43146 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbZDHJ7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:59:32 -0400
Date: Wed, 8 Apr 2009 12:02:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] w35und: make led lookup tables static
Message-ID: <20090408100230.GC24848@elf.ucw.cz>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi> <1239178446-12893-11-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239178446-12893-11-git-send-email-penberg@cs.helsinki.fi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-04-08 11:14:06, Pekka Enberg wrote:
> Impact: cleanup
> 
> No need to keep read-only data on the stack.

It would be enough to just put static to the variables. They would
still be off-stack, but would be local...

Anyway that's a detail.

Whole series:

Acked-by: Pavel Machek <pavel@ucw.cz>

> diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
> index cffd732..dc7cc08 100644
> --- a/drivers/staging/winbond/wbusb.c
> +++ b/drivers/staging/winbond/wbusb.c
> @@ -171,14 +171,21 @@ static const struct ieee80211_ops wbsoft_ops = {
>  	.get_tsf		= wbsoft_get_tsf,
>  };
>  
> +static u8 LED_GRAY[20] = {
> +	0, 3, 4, 6, 8, 10, 11, 12, 13, 14, 15, 14, 13, 12, 11, 10, 8, 6, 4, 2
> +};
> +
> +static u8 LED_GRAY2[30] = {
> +	7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
> +	0, 15, 14, 13, 12, 11, 10, 9, 8
> +};
> +
>  static void hal_led_control(unsigned long data)
>  {
>  	struct wbsoft_priv *adapter = (struct wbsoft_priv *)data;
>  	struct hw_data *pHwData = &adapter->sHwData;
>  	struct wb35_reg *reg = &pHwData->reg;
>  	u32 LEDSet = (pHwData->SoftwareSet & HAL_LED_SET_MASK) >> HAL_LED_SET_SHIFT;
> -	u8 LEDgray[20] = { 0, 3, 4, 6, 8, 10, 11, 12, 13, 14, 15, 14, 13, 12, 11, 10, 8, 6, 4, 2 };
> -	u8 LEDgray2[30] = { 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 0, 0,
> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 14, 13, 12, 11, 10, 9, 8 };


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
