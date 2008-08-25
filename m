Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYHYRxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYHYRxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbYHYRxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:53:08 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36167 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753955AbYHYRxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:53:05 -0400
Message-ID: <48B2F180.6050503@sgi.com>
Date: Mon, 25 Aug 2008 10:53:04 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/6] x86_64 UV: Use LED to indicate CPU is active
References: <20080808005639.505189000@polaris-admin.engr.sgi.com> <20080808005649.986660000@polaris-admin.engr.sgi.com> <20080811155318.GB4524@elte.hu> <20080813095643.GA27074@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080813095643.GA27074@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> +/*
>>> + * Illuminate "activity" LED when CPU is going "active",
>>> + * extinguish when going "idle".
>>> + */
>>> +static int uv_idle(struct notifier_block *nfb, unsigned long action, void *junk)
>>> +{
>>> +	if (action == IDLE_START)
>>> +		uv_set_led_bits(0, LED_CPU_ACTIVITY);
>>> +
>>> +	else if (action == IDLE_END)
>>> +		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
>>> +
>>> +	return NOTIFY_OK;
>>> +}
>>> +
>>> +static struct notifier_block uv_idle_notifier = {
>>> +	.notifier_call = uv_idle,
>>> +};
>>>  
>>> +/*
>>> + * Initialize idle led callback function
>>> + */
>>> +static __init void uv_init_led_idle_display(void)
>>> +{
>>> +	/* initialize timer for activity monitor */
>>> +	idle_notifier_register(&uv_idle_notifier);
>>> +}
>> hm, i think this is a bad idea. While putting it into the go-to-idle 
> 
> Plus this really should not be uv-specific. We already have generic
> triggers.
> 
> And you should really CC led maintainers!
> 									Pavel

Thanks for the pointers, I will definitely look into this.

(And sorry for not discovering the LED docs and maintainers earlier.)

Mike
