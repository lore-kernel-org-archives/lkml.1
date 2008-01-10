Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbYAJNqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbYAJNqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbYAJNqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:46:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39101 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028AbYAJNqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:46:10 -0500
Date: Thu, 10 Jan 2008 14:45:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
Message-ID: <20080110134539.GD5886@elte.hu>
References: <1199759244.26343.35.camel@localhost.localdomain> <20080108033329.GI2998@bingen.suse.de> <1199911330.975.3.camel@localhost.localdomain> <1199916725.975.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199916725.975.6.camel@localhost.localdomain>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2008-01-09 at 15:42 -0500, Steven Rostedt wrote:
> > This patch is different than the first patch I sent out.
> > This one just sends an IPI to all CPUS that don't check in after 1 sec.
> > 
> > 
> > Sometimes cpu_idle_wait gets stuck because it might miss CPUS that are
> > already in idle, have no tasks waiting to run and have no interrupts
> > going to them.  This is common on bootup when switching cpu idle
> > governors.
> > 
> > This patch gives those CPUS that don't check in an IPI kick.
> 
> FYI, I just hit this hang on 2.6.24-rc6 without any extra patches. So, 
> unless 2.6.24-rc7 did anything to fix this issue, this is a high 
> priority bug (IMHO).

i'm wondering why this only triggered now. Is this something new in 
2.6.24?

	Ingo
