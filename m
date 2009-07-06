Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZGFIPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZGFIPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbZGFIPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:15:05 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40504 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbZGFIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C/UwgwIu93/DnX+bGhLVhNFpsb11gZlUZAktDZ6hLpIZDX6Zxj30qmgDLYJ6ZStcko
         XSGIMfOcgURLzeNBNs8VvqTD4YEu2doMJHgTyIMpKO7cflrTYdeZqM6Rz7GRv7cTcQnR
         ctXf9H/8w+YCxLq1kf5C7ctfzQL6J8jmQ+OH4=
Date: Mon, 6 Jul 2009 10:14:32 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: Andres Freund <andres@anarazel.de>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090706081432.GA3065@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <20090704151855.GA21896@ami.dom.local> <a5d9929e0907052153x2db851bcj26f1433c716c8a90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d9929e0907052153x2db851bcj26f1433c716c8a90@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 05:53:51AM +0100, Joao Correia wrote:
> Hello
Hi,

> System freezes immediatly after grub, no init processing at all, after
> applying those patches on top of vanilla 2.6.30 on my box.
> 
> Also, 2nd patch, this piece:
> 
> +#ifdef CONFIG_SCHED_DEBUG
> +static inline unsigned int get_sysctl_timer_migration(void)
> +{
> +       return sysctl_timer_migration;
> +}
> +#else
> +static inline unsigned int get_sysctl_timer_migration(void)
> +{
> +       return 1;
> +}
> +#endif
> 
> doesnt work on top of 2.6.30. It complains, while compiling, that
> sysctl_timer_migration is not defined. So i just replaced that call
> with return 1, like on the not debug case. Hope this doesnt defeat
> your test case, but it wouldnt compile otherwise. Probably that was
> just introduced after 2.6.30?

Yes, it would be too easy if it had worked just like this... (I only
test-compiled it, without such warnings, but without CONFIG_SCHED_DEBUG.)
I'll look at this again.

> 
> (Have also tried latest .31-rc2, original bug still exists.)

Btw., could you send your .config? Do you have lockdep enabled (if so
did you try without it)? Is it 'a real' box or something virtual?

Thanks,
Jarek P.
