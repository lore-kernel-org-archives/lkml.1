Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYHNJH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYHNJH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYHNJHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:07:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58149 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbYHNJHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:07:50 -0400
Date: Thu, 14 Aug 2008 11:07:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Message-ID: <20080814090737.GA11179@elte.hu>
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com> <20080813141629.GD19397@elte.hu> <b6a2187b0808131010u7481f663n94d8e005b9dac2d1@mail.gmail.com> <b6a2187b0808131033m25a7e147x98235a48abd3eb3c@mail.gmail.com> <20080813173940.GA32214@elte.hu> <86802c440808131046s4df84ba9va12d45897cf6affa@mail.gmail.com> <86802c440808131133o133e1dfftdfcc076a1100afb6@mail.gmail.com> <b6a2187b0808140016m63c7d9d9s960014ec5cd9f3c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0808140016m63c7d9d9s960014ec5cd9f3c5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Thu, Aug 14, 2008 at 2:33 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> >>>> > With 16 CPUs, it still hangs, but now the console is showing the
> >>>> > errors as intended.
> >>>> > ... but it is supposed to hang?
> 
> > please check the attached patch. it should fix the new regression and
> > will not hang.
> 
> Ok, booted up and not hanged, but those messages below don't show up
> anywhere. I've tested with CONFIG_NR_CPUS=16 and 8 as well. Just got 8
> cpus
> 
> More than 8 CPUs detected - skipping them.
> Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.
> 
> # cat /sys/devices/system/cpu/possible
> 0-7
> 
> CONFIG_X86_32=y
> CONFIG_X86_PC=y
> 
> 
> Looks like it's not going into this condition
> +        if (def_to_bigsmp && nr_cpu_ids > 8) {
> 
> 
> Shall this be put back so that it'll show the message?
> -       if (def_to_bigsmp && apicid > 8) {
> -               printk(KERN_WARNING
> -                       "More than 8 CPUs detected - skipping them.\n"
> -                       "Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.\n");
> -       }

could you post the full dmesg? And the modified patch that you've tested 
to both have 8 CPUs without bigsmp and which also shows the printk?

	Ingo
