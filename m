Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbYGIU6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbYGIU6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757100AbYGIU44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:56:56 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:59422 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079AbYGIU4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:56:55 -0400
Message-ID: <4875266B.4020504@keyaccess.nl>
Date: Wed, 09 Jul 2008 22:58:19 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [patch] x86 BIOS interface for RTC on SGI UV
References: <20080709202719.GB22744@sgi.com>
In-Reply-To: <20080709202719.GB22744@sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-07-08 22:27, Russ Anderson wrote:

> [patch] x86 BIOS interface for RTC on SGI UV

[ ... ]

> +# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
> +	do {								\
> +		/* XXX - the real call goes here */			\
> +		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
> +		isrv.v0 = 0;						\
> +		isrv.v1 = 0;						\

isrv? should be "result" I guess?

[ ... ]

> +extern long
> +x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
> +		   unsigned long *drift_info);

[ ... ]

> +unsigned long sn_rtc_cycles_per_second;
> +EXPORT_SYMBOL(sn_rtc_cycles_per_second);
> +

> +static __init void uv_rtc_init(void)
> +{
> +	long status, ticks_per_sec, drift;
> +
> +	status =
> +	    x86_bios_freq_base(BIOS_FREQ_BASE_REALTIME_CLOCK, &ticks_per_sec,
> +					&drift);
> +	if (status != 0 || ticks_per_sec < 100000) {
> +		printk(KERN_WARNING
> +			"unable to determine platform RTC clock frequency, "
> +			"guessing.\n");
> +		/* BIOS gives wrong value for clock freq. so guess */
> +		sn_rtc_cycles_per_second = 1000000000000UL / 30000UL;
> +	} else
> +		sn_rtc_cycles_per_second = ticks_per_sec;
> +}

It seems ticks_per_sec and drift should be "unsigned long"...


> +const char *
> +x86_bios_strerror(long status)

[ ... ]

> +long
> +x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
> +		   unsigned long *drift_info)
> +{
> +	struct uv_bios_retval isrv;

... and wouldn't uv_bios_strerror/uv_bios_freq_base be better names?

Rene.
