Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZKLPm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZKLPm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZKLPmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:42:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZKLPmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:42:23 -0500
Date: Thu, 12 Nov 2009 16:40:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fix granularity of task_u/stime(), v2
Message-ID: <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
References: <4AF8FD3C.2090008@jp.fujitsu.com> <4AF8FE76.406@jp.fujitsu.com> <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com> <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com> <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258038038.4039.467.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 04:00:38PM +0100, Peter Zijlstra wrote:
> On Thu, 2009-11-12 at 15:49 +0100, Stanislaw Gruszka wrote:
> >  I can not reproduce
> > the bug with below patch:
> > 
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index f7864ac..b85e384 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -110,8 +110,8 @@ static void __exit_signal(struct task_struct *tsk)
> >  		 * We won't ever get here for the group leader, since it
> >  		 * will have been the last reference on the signal_struct.
> >  		 */
> > -		sig->utime = cputime_add(sig->utime, task_utime(tsk));
> > -		sig->stime = cputime_add(sig->stime, task_stime(tsk));
> > +		sig->utime = cputime_add(sig->utime, tsk->utime); //task_utime(tsk));
> > +		sig->stime = cputime_add(sig->stime, tsk->stime); //task_stime(tsk));
> >  		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
> >  		sig->min_flt += tsk->min_flt;
> >  		sig->maj_flt += tsk->maj_flt;
> 
> Yes, this is the thing I suggested and makes sense.

Ok, I'm going to post this.

Spencer,

seems you have more test cases for utime decreasing issues,
could you send links to me ? Somehow I could not find them 
by my own. Particularly test case used in development this commit
is interested:

  commit 49048622eae698e5c4ae61f7e71200f265ccc529
  Author: Balbir Singh <balbir@linux.vnet.ibm.com>
  Date:   Fri Sep 5 18:12:23 2008 +0200
    sched: fix process time monotonicity

Stanislaw
