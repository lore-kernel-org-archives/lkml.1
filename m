Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZGRW2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZGRW2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 18:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZGRW2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 18:28:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:49196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbZGRW2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 18:28:31 -0400
Date: Sat, 18 Jul 2009 15:30:11 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@tglx.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, nikolag@ca.ibm.com,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
Message-ID: <20090718153011.1de3af8e@infradead.org>
In-Reply-To: <1247954978.14494.19.camel@work-vm>
References: <1247873945.8334.67.camel@localhost.localdomain>
	<alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
	<1247954978.14494.19.camel@work-vm>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jul 2009 15:09:38 -0700
john stultz <johnstul@us.ibm.com> wrote:

> After talking with some application writers who want very fast, but
> not fine-grained timestamps, I decided to try to implement a new
> clock_ids to clock_gettime(): CLOCK_REALTIME_COARSE and
> CLOCK_MONOTONIC_COARSE which returns the time at the last tick. This
> is very fast as we don't have to access any hardware (which can be
> very painful if you're using something like the acpi_pm clocksource),
> and we can even use the vdso clock_gettime() method to avoid the
> syscall. The only trade off is you only get low-res tick grained time
> resolution.

Does this tie us to having a tick? I still have hope that we can get
rid of the tick even when apps are running .... since with CFS we don't
really need the tick for the scheduler anymore for example....




> me_lock, seq));
> +
> +	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
> +				now.tv_nsec + mono.tv_nsec);
> +	return now;
> +}
> +EXPORT_SYMBOL(get_monotonic_coarse);
> +

why does this need to be exported ?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
