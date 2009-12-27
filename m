Return-Path: <linux-kernel-owner+w=401wt.eu-S1751073AbZL0F5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbZL0F5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 00:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbZL0F5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 00:57:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbZL0F5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 00:57:07 -0500
Date: Sun, 27 Dec 2009 06:56:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Pavel Machek <pavel@ucw.cz>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, joe@perches.com,
       torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
Message-ID: <20091227055637.GA22315@elte.hu>
References: <1261315437.4314.6.camel@laptop>
 <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
 <20091225132642.GA1419@ucw.cz>
 <20091225184514.GA381@elte.hu>
 <5723.1261874741@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5723.1261874741@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Fri, 25 Dec 2009 19:45:14 +0100, Ingo Molnar said:
> 
> >  - in the last stable kernel, v2.6.32, still more new printk()s were 
> >    introduced than pr_*() lines:
> > 
> >      $ git log -p v2.6.31..v2.6.32 | grep '^+.*\<pr_' | wc -l
> >      2016
> >      $ git log -p v2.6.31..v2.6.32 | grep '^+.*\<printk' | wc -l
> >      3531
> 
> Ahem. That's not introduced, that's 'added or modified'.

'introduced or modified', yes. In those 5500 lines less than ~20% are 
'modifications' (the rest is newly introduced).

> % git log -p v2.6.31..v2.6.32 | grep -C 5 '^+.*\<pr_' | head
> -        * In case of failure continue with no timer. */
> +       /* Test if the external timer can be actually used.
> +        * In case of failure continue without timer. */
>         if (unlikely((stmmac_open_ext_timer(dev, priv->tm)) < 0)) {
> -               pr_warning("stmmaceth: cannot attach the HW timer\n");
> +               pr_warning("stmmaceth: cannot attach the external timer.\n");
>                 tmrate = 0;
>                 priv->tm->freq = 0;
>                 priv->tm->timer_start = stmmac_no_timer_started;
>                 priv->tm->timer_stop = stmmac_no_timer_stopped;
> 
> Meanwhile, the fact that there's only about a 2-to-1 difference in patches 
> when there's a 6-to-1 difference in existing code tells me that 
> proportionally, there is *more* activity with pr_foo variants than printk.

Yet there's more printks in the kernel than a cycle ago, so without the trend 
changing, we've got an infinite supply of future 'conversion' patches.

> printk:  3531 hits in 61126 uses = 5.7% churn
> pr_foo: 2016 hits in 10861 uses = 18.5% churn

Peter's complaint was precisely that there's a lot of 'churn' for pr_*().

> The numbers need much deeper analysis to make any sort of real statistical 
> conclusion here...

If you are convinced that there's something else going on as well feel free to 
do deeper analysis. So, until some contrary numbers are posted i stay by my 
main conclusions.

Thanks,

	Ingo
