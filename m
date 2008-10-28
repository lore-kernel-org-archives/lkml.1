Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYJ1I3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYJ1I3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYJ1I3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:29:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33308 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbYJ1I3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:29:35 -0400
Date: Tue, 28 Oct 2008 09:29:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: sniper <s3c24xx@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LOCKDEP: minor fix for debug_show_all_locks()
Message-ID: <20081028082920.GK15734@elte.hu>
References: <9bd6b5360810271303teb198dejde3116f69cfffd46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bd6b5360810271303teb198dejde3116f69cfffd46@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1340]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* sniper <s3c24xx@gmail.com> wrote:

> When we failed to get tasklist_lock eventually (count equals 0),
> we should only print " ignoring it.\n", and not print
> " locked it.\n" needlessly.

well spotted!

Minor nit:

> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3417,10 +3417,12 @@ retry:
>  		}
>  		printk(" ignoring it.\n");
>  		unlock = 0;
> +		goto print_locks;
>  	}
>  	if (count != 10)
>  		printk(" locked it.\n");
> 
> +print_locks:
>  	do_each_thread(g, p) {

please move the "if (count != 10)" line into the else section of the 
trylock, instead of introducing a label and a goto.

	Ingo
