Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbXKTNW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbXKTNW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 08:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbXKTNWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 08:22:21 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:58268 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755840AbXKTNWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 08:22:20 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 08:22:20 EST
From: Damien Wyart <damien.wyart@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
References: <20071119151756.GA25446@elte.hu>
	<20071120112459.GA2884@localhost.localdomain>
	<20071120125557.GB8355@elte.hu>
Date: Tue, 20 Nov 2007 14:22:19 +0100
In-Reply-To: <20071120125557.GB8355@elte.hu> (Ingo Molnar's message of "Tue,
	20 Nov 2007 13:55:57 +0100")
Message-ID: <87zlx9vypg.fsf@free.fr>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Testing sched-cfs-v2.6.24-rc3-v24.patch on top of 2.6.24-rc3-git1
> > (ignored the two "already applied" messages coming from git1
> > commits), I get a 1.00 minimum load in top, coming from the
> > load_balance_mo thread staying in D-state. I get this on 2 different
> > computers with similar configs, so I am attaching one of them here.

* Ingo Molnar <mingo@elte.hu> [071120 13:55]:
> does the patch below fix that problem for you?

Yes, it does. Thanks for your answer.

Damien

> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -7138,7 +7138,7 @@ static int load_balance_monitor(void *un
>  		else if (timeout < sysctl_sched_max_bal_int_shares)
>  			timeout *= 2;
>  
> -		msleep(timeout);
> +		msleep_interruptible(timeout);
>  	}
>  
>  	return 0;
>
