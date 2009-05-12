Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbZELJmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbZELJmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbZELJma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:42:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:61000 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZELJm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:42:29 -0400
Date: Tue, 12 May 2009 11:42:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: leemgs1@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       tglx <tglx@linutronix.de>, williams <williams@redhat.com>
Subject: Re: [PATCH]sched: fix typo in sched-rt-group.txt file
Message-ID: <20090512094210.GD32292@elte.hu>
References: <1242117459.31161.11.camel@centos51> <1242119738.11251.322.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242119738.11251.322.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-05-12 at 17:37 +0900, GeunSik Lim wrote:
> > 
> > 
> > Dear Ingo,
> > 
> > I found typo about the range of static priority ( = realtime priority )
> > in "./Documentation/scheduler/sched-rt-group.txt" file.
> > 
> > If I don't understand static priority levels, Correct me.
> 
> Right, that 'confusion' stems from the fact that our in-kernel priority
> lists do consider all 140 priorities.
> 
> The patch looks good though.
> 
> > commit d6af702008117ca489a2f5476239d1688a517e98
> > Author: GeunSik,Lim <leemgs1@gmail.com>
> > Date:   Tue May 12 17:20:32 2009 +0900
> > 
> >     sched: fix typo in sched-rt-group.txt file
> >     
> >     Fix typo about static priority's range.
> >      Kernel Space priority: 0   to 99   --> User Space RT priority 99 to 0
> >      Kernel Space priority: 100 to 139  --> User Space nice -20 to 19
> >     
> >     Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
> > 
> > diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
> > index 5ba4d3f..1537146 100644
> > --- a/Documentation/scheduler/sched-rt-group.txt
> > +++ b/Documentation/scheduler/sched-rt-group.txt
> > @@ -169,7 +169,7 @@ get their allocated time.
> >  
> >  Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
> >  the biggest challenge as the current linux PI infrastructure is geared towards
> > -the limited static priority levels 0-139. With deadline scheduling you need to
> > +the limited static priority levels 0-99. With deadline scheduling you need to

SCHED_FIFO goes from 1 to 99. So it's either 0-98 or 1-99. From 
sched_setscheduler(2):

       Processes scheduled under one of  the  real-time  policies  (SCHED_FIFO,
       SCHED_RR) have a sched_priority value in the range 1 (low) to 99 (high).

	Ingo
