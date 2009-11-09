Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZKIMtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZKIMtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZKIMtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:49:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbZKIMty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:49:54 -0500
Date: Mon, 9 Nov 2009 13:49:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to
 preempt_count leakage in keventd
Message-ID: <20091109124937.GA21114@elte.hu>
References: <200911091250.31626.rjw@sisk.pl>
 <20091109120217.GB18399@elte.hu>
 <200911091324.37955.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911091324.37955.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday 09 November 2009, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > [ 2016.865041] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/29920                                                                                         
> > > [ 2016.865344] caller is vmstat_update+0x13/0x48                                          
> > > [ 2016.865522] Pid: 29920, comm: events/1 Not tainted 2.6.31-tst #158                     
> > > [ 2016.865700] Call Trace:                                                                
> > > [ 2016.865877]  [<ffffffff811608e8>] debug_smp_processor_id+0xc4/0xd4                     
> > > [ 2016.866052]  [<ffffffff810a9ae1>] vmstat_update+0x13/0x48                              
> > > [ 2016.866232]  [<ffffffff81051ee6>] worker_thread+0x18b/0x22a                            
> > > [ 2016.866409]  [<ffffffff810a9ace>] ? vmstat_update+0x0/0x48                             
> > > [ 2016.866578]  [<ffffffff810556a5>] ? autoremove_wake_function+0x0/0x38                  
> > > [ 2016.866749]  [<ffffffff81288803>] ? _spin_unlock_irqrestore+0x35/0x37                  
> > > [ 2016.866935]  [<ffffffff81051d5b>] ? worker_thread+0x0/0x22a                            
> > > [ 2016.867113]  [<ffffffff8105547d>] kthread+0x69/0x71                                    
> > > [ 2016.867278]  [<ffffffff8100c1aa>] child_rip+0xa/0x20                                   
> > > [ 2016.867450]  [<ffffffff81055414>] ? kthread+0x0/0x71                                   
> > > [ 2016.867618]  [<ffffffff8100c1a0>] ? child_rip+0x0/0x20                                 
> > 
> > a bug producing similar looking messages was fixed by:
> > 
> >   fd21073: sched: Fix affinity logic in select_task_rq_fair()
> > 
> > but that bug was introduced by:
> > 
> >   a1f84a3: sched: Check for an idle shared cache in select_task_rq_fair()
> 
> I guess these are tip commits?

yep, tip:sched/core ones.

> > Which is for v2.6.33, not v2.6.32.
> 
> The one I saw was in the Linus' tree, quite obviously.

ok, then my observation should not apply.

	Ingo
