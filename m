Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbYFOQ0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbYFOQ0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 12:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758341AbYFOQZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 12:25:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:57632 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321AbYFOQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 12:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=chAy0aaXQWqcllg2zEgeIO3aHQH5pVQKNKmU4xC9DlNjaGZwBYF+52Yu6eTswTCeSy
         LS8cOu5vzzEzGkP1Y6Lxw43iHntmr9Aokf4EK1Dahsum/I3iSUF7YLjLg6POTQLxBJ9u
         9f/A2yafA/IZXu4ISABPdgMueDxQwLP2oRnjI=
Date: Sun, 15 Jun 2008 20:21:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080615162150.GA8289@martell.zuzino.mipt.ru>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.BVD.E3vSIB@albercik> <20080613135255.GB21341@cs181133002.pp.htv.fi> <20080614144200.GA26421@linux.vnet.ibm.com> <20080614145839.GA10523@tv-sign.ru> <20080614181212.GB26421@linux.vnet.ibm.com> <20080614194338.GA4820@martell.zuzino.mipt.ru> <20080615033001.GE26421@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080615033001.GE26421@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 08:30:01PM -0700, Paul E. McKenney wrote:
> On Sat, Jun 14, 2008 at 11:43:38PM +0400, Alexey Dobriyan wrote:
> > On Sat, Jun 14, 2008 at 11:12:12AM -0700, Paul E. McKenney wrote:
> > > On Sat, Jun 14, 2008 at 06:58:39PM +0400, Oleg Nesterov wrote:
> > > > On 06/14, Paul E. McKenney wrote:
> > > > >
> > > > > On Fri, Jun 13, 2008 at 04:52:55PM +0300, Adrian Bunk wrote:
> > > > > > On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
> > > > > > > This message has been generated automatically as a part of a report
> > > > > > > of recent regressions.
> > > > > > > 
> > > > > > > The following bug entry is on the current list of known regressions
> > > > > > > from 2.6.25.  Please verify if it still should be listed.
> > > > > > > 
> > > > > > > 
> > > > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
> > > > > > > Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
> > > > > > > Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> > > > > > > Date		: 2008-05-27 09:23 (12 days old)
> > > > > > > References	: http://lkml.org/lkml/2008/5/27/9
> > > > > > > Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
> > > > > > > 		  Linus Torvalds <torvalds@linux-foundation.org>
> > > > > > > 		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > > > Patch		: http://lkml.org/lkml/2008/5/28/16
> > > > > > 
> > > > > > What happened with this issue?
> > > > > 
> > > > > The patch listed above works for me, passes rcutorture, &c.  However,
> > > > > I never have been able to reproduce the original problem, so cannot say
> > > > > whether it qualifies as a fix.
> > > > 
> > > > I doubt very much RCU was the reason of this problem.
> > > 
> > > Although I very much appreciate your confidence in my code, it is new
> > > code, so therefore under suspicion.
> > > 
> > > > Alexey, how did you trigger this problem?
> > > 
> > > One of them involved running LTP while doing 170 kernel builds in
> > > parallel.
> > 
> > My gut feeling is that find_pid_ns oops, __d_lookup oops and
> > __call_for_each_cic oops are the same bug.
> > 
> > And rcutorture failures I've mentioned to Paul privately.
> 
> Yep, running rcutorture in parallel with LTP, which didn't reproduce
> for me either.
> 
> Did the patch at http://lkml.org/lkml/2008/5/28/16 help?
> 
> > Oleg, debugging you've posted never triggered.
> > 
> > kerneloops suggests that I'm alone. :-(
> 
> Assuming that the above patch didn't help...  As a desperation measure,
> I could suggest the following patch.

> --- linux-2.6.26-rc4/kernel/rcupreempt.c
> +++ linux-2.6.26-rc4-alexey/kernel/rcupreempt.c
> @@ -77,7 +77,7 @@
>   *
>   * GP in GP_STAGES stands for Grace Period ;)
>   */
> -#define GP_STAGES    2
> +#define GP_STAGES    3
>  struct rcu_data {
>  	spinlock_t	lock;		/* Protect rcu_data fields. */
>  	long		completed;	/* Number of last completed batch. */

Both patches (independently) do not help with rcutortures failures:

[   58.968404] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval = 5
[  159.044524] rcu-torture: rtc: 0000000000000000 ver: 53859 tfle: 0 rta: 53859 rtaf: 18 rtf: 53797 rtmbe: 0
[  159.044527] rcu-torture: !!! Reader Pipe:  65565142 4275 1 0 0 0 0 0 0 0 0
[  159.044529] rcu-torture: Reader Batch:  65564196 5207 7 3 1 1 0 1 1 0 1
[  159.044530] rcu-torture: Free-Block Circulation:  53858 53853 53846 53843 53834 53825 53816 53808 53803 53797 0
[  159.044976] rcu-torture:--- End of test: FAILURE: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval = 5

