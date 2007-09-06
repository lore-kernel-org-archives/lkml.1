Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbXIFRxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbXIFRxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 13:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbXIFRxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 13:53:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbXIFRxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 13:53:03 -0400
Message-ID: <46E03E40.80801@redhat.com>
Date: Thu, 06 Sep 2007 12:52:00 -0500
From: Clark Williams <williams@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070813)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steven Rostedt <rostedt@goodmis.org>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT] convert RCU Preempt tasklet into softirq.
References: <1181180051.18444.31.camel@localhost.localdomain> <20070607041411.GB1783@linux.vnet.ibm.com> <1181226138.18444.54.camel@localhost.localdomain> <20070607161754.GA11941@linux.vnet.ibm.com> <1181240819.10408.14.camel@localhost.localdomain> <20070607210247.GA9390@linux.vnet.ibm.com> <1181316428.10408.30.camel@localhost.localdomain> <20070608193655.GA18399@linux.vnet.ibm.com> <1181331828.10408.34.camel@localhost.localdomain> <20070608200058.GC18399@linux.vnet.ibm.com>
In-Reply-To: <20070608200058.GC18399@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Paul E. McKenney wrote:
> On Fri, Jun 08, 2007 at 03:43:48PM -0400, Steven Rostedt wrote:
>> On Fri, 2007-06-08 at 12:36 -0700, Paul E. McKenney wrote:
>>> On Fri, Jun 08, 2007 at 11:27:08AM -0400, Steven Rostedt wrote:
>>>> The first time I compiled it, I forgot the ';' and got a warning there.
>>>> But the warning also included "declaring structure softirq_action in
>>>> prototype", so I fixed both the ';' and added the struct. I can try
>>>> compile without it. But I also know that adding #include <interrupt.h>
>>>> in rcupreempt.h caused issues too.
>>> If I leave out both the "struct softirq_action" and the
>>> rcu_process_callbacks() declaration,, it compiles for me.
>>>
>>> So I guess the rcu_process_callbacks() should be declared static...
>> OK, I can update the patch to reflect that. Remember, I didn't learn
>> anything from doing this patch, so I have no idea why
>> rcu_procell_callbacks was global. I was just keeping to the norm. :-)
> 
> Hey, -I- learned something from your doing the patch -- namely that
> rcu_process_callbacks() was needlessly non-static.  ;-)
> 
>> Actually, I'll make a separate patch for this change. This is a
>> different issue.
> 
> Sounds good!
> 

Paul,

I had a test run of a kernel using Steven's patch (RCU using tasklets) going over the
weekend. It looks like it made it through running racer for 24hrs without a panic,
but I'm not entirely convinced (since my reservation of the test system expired on
Saturday and I didn't look at it until Wednesday; bad Clark, no doughnut).

I've got another test running now and I'll be able to poke around on the system
tomorrow morning to see if in fact there were no RCU related Oops'en. I'll let you
know what we find.

Clark


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFG4D5AHyuj/+TTEp0RAkfxAKDmGHLgTEaVrclCPQfytJZbF9hf3QCfZdct
Hjr1PgUP6U8X4dLAdd3vXQk=
=T7lw
-----END PGP SIGNATURE-----
