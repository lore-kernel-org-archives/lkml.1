Return-Path: <linux-kernel-owner+w=401wt.eu-S936905AbZDJNLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936905AbZDJNLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbZDJNLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:11:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47043 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604AbZDJNLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:11:10 -0400
Date: Fri, 10 Apr 2009 15:10:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>, stable@kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [BUG 2.6.29] NMI watchdog triggered in rb_insert_color called
	from enqueue_hrtimer
Message-ID: <20090410131051.GD31307@elte.hu>
References: <18908.27242.966881.409415@pilspetsen.it.uu.se> <20090408092452.GA26121@elte.hu> <18908.35477.227662.637308@pilspetsen.it.uu.se> <18909.58298.579959.482372@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18909.58298.579959.482372@pilspetsen.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Mikael Pettersson writes:
>  > Ingo Molnar writes:
>  >  > 
>  >  > * Mikael Pettersson <mikpe@it.uu.se> wrote:
>  >  > 
>  >  > > Less than an hour after updating a dual Opteron 8384 box from 
>  >  > > 2.6.29-rc6 (which it had been running for weeks) to 2.6.29 final 
>  >  > > it died with the following watchdog-detected lockup:
>  >  > 
>  >  > Could you please check whether this is the bug fixed by:
>  >  > 
>  >  >   7f1e2ca: hrtimer: fix rq->lock inversion (again)
>  > 
>  > I am testing this now and will let you know how it goes.
> 
> The machine has now been running 2.6.29 plus that fix for more 
> than 24 hours with no problems. Previously it oopsed and hung 
> within an hour on two separate attempts to run 2.6.29 vanilla.

ok, thanks for testing. The fix is now upstream:

  7f1e2ca: hrtimer: fix rq->lock inversion (again)

-stable team, please pick it up - i just checked, it cherry-picks 
fine on v2.6.29.

	Ingo
