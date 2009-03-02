Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZCBNoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZCBNoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbZCBNoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:44:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:19714 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZCBNod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:44:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fzST6jUpTrphcp6bnGLaMA1OPXEfFKgtDBZu9NraZtFaNeqtO3g8OxJhE9/XBV7l2I
         pHXzEJ5Jh1dHH4o5TQlzmtoafln2ChckXj2guwNkIUhH00wBWVplPVC+Og4z4HkjXHby
         Fh+B8+EMsZ5YwZiGVHtUmAQ+3pQ6FlQs4nczQ=
Message-ID: <49ABE2BC.9010401@gmail.com>
Date: Mon, 02 Mar 2009 14:44:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: Accelerated touchscreen support for Marvell
 Zylonite
References: <1236000228-13025-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1236000228-13025-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.3.2009 14:23, Mark Brown wrote:
> index 0000000..b016021
> --- /dev/null
> +++ b/drivers/input/touchscreen/zylonite-wm97xx.c
[...]
> +/*
> + * Pressure readback.
> + *
> + * Set to 1 to read back pen down pressure
> + */
> +static int pressure;
> +module_param(pressure, int, 1);

Weird permissions.

> +/* flush AC97 slot 5 FIFO machines */
> +static void wm97xx_acc_pen_up(struct wm97xx *wm)
> +{
> +	int count = 16;
> +	schedule_timeout_uninterruptible(1);

You meant ssleep(1)?

> +
> +	while (count<  16) {

Weird condition.
+ conding style

> +		MODR;
> +		count--;
> +	}
> +}
> +
> +static int wm97xx_acc_pen_down(struct wm97xx *wm)
> +{
> +	u16 x, y, p = 0x100 | WM97XX_ADCSEL_PRES;
> +	int reads = 0;
> +
> +	/* When the AC97 queue has been drained we need to allow time
> +	 * to buffer up samples otherwise we end up spinning polling
> +	 * for samples.  The controller can't have a suitably low
> +	 * threashold set to use the notifications it gives.
> +	 */
> +	schedule_timeout_uninterruptible(1);

ssleep

> +	if (tries>  5) {

Where is tries defined?

> +static int wm97xx_acc_startup(struct wm97xx *wm)
> +{
> +	int idx = 0;

No need to initialize.

> +static void wm97xx_irq_enable(struct wm97xx *wm, int enable)
> +{
> +	if (enable)
> +		enable_irq(wm->pen_irq);
> +	else
> +		disable_irq(wm->pen_irq);

sync?
