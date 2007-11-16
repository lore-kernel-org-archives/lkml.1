Return-Path: <linux-kernel-owner+w=401wt.eu-S936389AbXKPX1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936389AbXKPX1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964975AbXKPX0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:26:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:20124 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964958AbXKPX0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:26:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=foibOBvytAeuUNquWZreC5JH9+XOMTuJVVkbhjMnVnU6eNT4p1fPqmTdnHb8XqMhg+60niOIUjSDM3vyaUtUwadXq3fjEgbpJPvEkEHzGrddzOQxzy6G1wwAWTij1nk1CoG/celgCvvWQrmdTlvLdO71zpxpk0Ysnp0suv6gbLU=
Message-ID: <b647ffbd0711161526p2faf5abt2457084f1996c735@mail.gmail.com>
Date: Sat, 17 Nov 2007 00:26:41 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Micah Dowty" <micah@vmware.com>
Subject: Re: High priority tasks break SMP balancer?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, "Cyrus Massoumi" <cyrusm@gmx.net>,
       "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Mike Galbraith" <efault@gmx.de>,
       "Paul Menage" <menage@google.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>
In-Reply-To: <20071116221404.GC31527@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com>
	 <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com>
	 <20071115202425.GC4914@vmware.com>
	 <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com>
	 <20071115213510.GA16079@vmware.com>
	 <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com>
	 <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu>
	 <b647ffbd0711160248v444d8f64ic72a17fcb56adc6d@mail.gmail.com>
	 <20071116221404.GC31527@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/11/2007, Micah Dowty <micah@vmware.com> wrote:
> [ ... ]
> > or just remove bit #3 (which is responsible for 8 == 1000) here:
> >
> > cat /proc/sys/kernel/sched_features
> >
> > (this one is enabled by default in 2.6.23.1)
>
> Aha. Turning off bit 3 appears to instantly fix my problem while it's
> occurring in an existing process, and I can't reproduce it on any new
> processes afterward.

humm... ok, but considering your recent summary for various kernels...
I guess, it doesn't qualify as the primary suspect... it just likely
affects something else.

>
> > cpu_1 : 2-3 nice(0) cpu-hog tasks ;
> >
> > both cpus may be seen with similar rq->load_cpu[]...
>
> When I try this, cpu0 has a cpu_load[] of over 10000 and cpu1 has a
> load of 2048 or so.

yeah, one of the options for 2048 would be presence of 2 nice(0)
cpu-hogs (1024 is the weight for a nice(0) task).


> > yeah, one would
> > argue that one of the cpu hogs could be migrated to cpu_0 and consume
> > remaining 'time slots' and it would not "disturb" the nice(-20) task
> > as :
> > it's able to preempt the lower prio task whenever it want (provided,
> > fine-grained kernel preemption) and we don't care that much of
> > trashing of caches here.
>
> Yes, that's the behaviour I expected to see (and what my application
> would prefer).

yep, that's what load_balance_newidle() is about... so maybe there are
some factors resulting in its inconsistency/behavioral differences on
different kernels.

Let's say we change a pattern for the niced task: e.g. run for 100 ms.
and then sleep for 300 ms. (that's ~25% of cpu load) in the loop. Any
behavioral changes?


>
> Thanks much,
> --Micah
>

-- 
Best regards,
Dmitry Adamushko
