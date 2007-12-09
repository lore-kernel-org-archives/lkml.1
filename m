Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXLIHr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXLIHr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 02:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXLIHrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 02:47:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXLIHrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 02:47:19 -0500
Date: Sun, 9 Dec 2007 08:46:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>, Gautham R Shenoy <ego@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Message-ID: <20071209074647.GE22981@elte.hu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu> <475B24F4.3090904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475B24F4.3090904@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 12/08/2007 04:24 PM, Ingo Molnar wrote:
> > i'm wondering why it had no effect now
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index e0d3a4f..a46c252 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -47,15 +47,21 @@ void __init cpu_hotplug_init(void)
>  }
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> -
> +#include <asm/io.h>
>  void get_online_cpus(void)
>  {
> +       outb(0x20, 0x80);
>         might_sleep();
> +       outb(0x21, 0x80);

ah. If you comment out get_online_cpus()/put_online_cpus() from 
kernel/softlockup.c, does it start working?

Gautham, any ideas?

	Ingo
