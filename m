Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbZD1PEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbZD1PEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761272AbZD1PDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:03:53 -0400
Received: from ru.mvista.com ([213.79.90.228]:3658 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761047AbZD1PDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:03:53 -0400
Date: Tue, 28 Apr 2009 19:03:52 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Evgeniy Polyakov <zbr@ioremap.net>, Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 3/3] w1: ds2760_battery: add support for sleep mode
	feature
Message-ID: <20090428150352.GB14209@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1240908902-24646-1-git-send-email-daniel@caiaq.de> <1240908902-24646-2-git-send-email-daniel@caiaq.de> <1240908902-24646-3-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1240908902-24646-3-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 10:55:02AM +0200, Daniel Mack wrote:
> This adds support for ds2760's sleep mode feature. With this feature
> enabled, the chip enters a deep sleep mode and disconnects from the
> battery when the w1 line is held down for more than 2 seconds.
> 
> This new behaviour can be switched on and off using a new module
> parameter.
> 
> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> Cc: Matt Reimer <mreimer@vpop.net>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> ---
[...]
> --- a/drivers/power/ds2760_battery.c
> +++ b/drivers/power/ds2760_battery.c
[...]
> diff --git a/drivers/w1/slaves/w1_ds2760.h b/drivers/w1/slaves/w1_ds2760.h
> index ea39419..58e7741 100644
> --- a/drivers/w1/slaves/w1_ds2760.h
> +++ b/drivers/w1/slaves/w1_ds2760.h
> @@ -25,6 +25,10 @@
>  
>  #define DS2760_PROTECTION_REG		0x00
>  #define DS2760_STATUS_REG		0x01
> +	#define DS2760_STATUS_IE	(1 << 2)
> +	#define DS2760_STATUS_SWEN	(1 << 3)
> +	#define DS2760_STATUS_RNAOP	(1 << 4)
> +	#define DS2760_STATUS_PMOD	(1 << 5)

The single patch touch battery and w1 trees.

So, Evgeniy, would you mind if I take this patch?


Thanks!

>  #define DS2760_EEPROM_REG		0x07
>  #define DS2760_SPECIAL_FEATURE_REG	0x08
>  #define DS2760_VOLTAGE_MSB		0x0c
> @@ -38,6 +42,7 @@
>  #define DS2760_EEPROM_BLOCK0		0x20
>  #define DS2760_ACTIVE_FULL		0x20
>  #define DS2760_EEPROM_BLOCK1		0x30
> +#define DS2760_STATUS_WRITE_REG		0x31
>  #define DS2760_RATED_CAPACITY		0x32
>  #define DS2760_CURRENT_OFFSET_BIAS	0x33
>  #define DS2760_ACTIVE_EMPTY		0x3b
> -- 
> 1.6.2.1

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
