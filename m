Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbXF2AUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbXF2AUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 20:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763655AbXF2AUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 20:20:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:55968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763876AbXF2AUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 20:20:06 -0400
To: Joshua Wise <jwise@google.com>
Cc: linux-kernel@vger.kernel.org, akpm@google.com, thockin@google.com,
       mikew@google.com, masouds@google.com
Subject: Re: [PATCH] Info dump on Oops or panic()
References: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Jun 2007 03:15:47 +0200
In-Reply-To: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
Message-ID: <p73r6nv4l30.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua Wise <jwise@google.com> writes:

You are aware that oops screen estate is very precious on standard
systems without serial console?

> +/*
> + * Dump out UTS info on oops / panic.
> + */
> + +static int dump_utsname(struct notifier_block *self, unsigned long
> v, void *p)
> +{
> +	printk ("%s %s %s %s %s %s\n",
> +		utsname()->sysname,
> +		utsname()->nodename,
> +		utsname()->release,
> +		utsname()->version,

release / version is already printed for oopses. I frankly don't see
the point of the rest of the UTS information because that should be
implicit in the log files (you surely know to which machine the log
belongs)

> +static int dump_uptime(struct notifier_block *self, unsigned long v, void *p)
> +{
> +	struct timespec uptime;
> +	/* The logic below is very much like how kernel +	 *
> prepares /proc/uptime. +	 */
> +	do_posix_clock_monotonic_gettime(&uptime);
> +	printk("Uptime(seconds): %lu.%02lu\n",
> +		(unsigned long) uptime.tv_sec,
> +		(uptime.tv_nsec / (NSEC_PER_SEC / 100)));

Wouldn't it be better to just print the time at boot up? If you 
have full log files you surely got the boot messages too and
then you can get it from there. Ok it might be tricky if you
don't know when the oops got logged, but surely that is a simple
exercise in text processing to handle this on the console server?

It can be already done with CONFIG_PRINTK_TIME BTW which
will event print it for every line.

-Andi
