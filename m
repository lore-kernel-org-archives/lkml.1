Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXAaLwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXAaLwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933091AbXAaLwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:52:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933105AbXAaLwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:52:40 -0500
Date: Wed, 31 Jan 2007 12:50:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
Message-ID: <20070131115055.GD1847@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033807.427331295@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033807.427331295@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3818]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> -module_init(init_acpi_pm_clocksource);
> +/*
> + * This clocksource is removed from the clocksource_initcall
> + * macro since it's mandatory for it to be in fs_initcall as the
> + * highest initcall level, or else it doesn't work properly with
> + * it's PCI fix ups.
> + */
> +fs_initcall(init_acpi_pm_clocksource);

ugh - this bit looks quite interesting.

what's the purpose of this patch? Switching to high-res timers should be 
done late in the bootup - in case there's a problem it's more 
debuggable, etc.

	Ingo
