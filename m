Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYFNTrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYFNTrq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 15:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYFNTrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 15:47:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31050 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbYFNTrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 15:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G5WLiu0HkLD4I5irMKjObLojGw9mbwMMkzX7JIqMqUlOiOmaJ+U3ouWbZbdpfaL259
         5ksI1K7KMDifEgrKtQJIHpH55SBcnQgE0Wh8VyB6FjiSSVmxS3utsL3r+u1SboQ0WUTF
         wuzTpovmoNBWlZSFBJn2zcAQ9v3RTYlm7GPmI=
Date: Sat, 14 Jun 2008 23:43:38 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080614194338.GA4820@martell.zuzino.mipt.ru>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.BVD.E3vSIB@albercik> <20080613135255.GB21341@cs181133002.pp.htv.fi> <20080614144200.GA26421@linux.vnet.ibm.com> <20080614145839.GA10523@tv-sign.ru> <20080614181212.GB26421@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614181212.GB26421@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 11:12:12AM -0700, Paul E. McKenney wrote:
> On Sat, Jun 14, 2008 at 06:58:39PM +0400, Oleg Nesterov wrote:
> > On 06/14, Paul E. McKenney wrote:
> > >
> > > On Fri, Jun 13, 2008 at 04:52:55PM +0300, Adrian Bunk wrote:
> > > > On Sat, Jun 07, 2008 at 10:42:57PM +0200, Rafael J. Wysocki wrote:
> > > > > This message has been generated automatically as a part of a report
> > > > > of recent regressions.
> > > > > 
> > > > > The following bug entry is on the current list of known regressions
> > > > > from 2.6.25.  Please verify if it still should be listed.
> > > > > 
> > > > > 
> > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10815
> > > > > Subject		: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
> > > > > Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> > > > > Date		: 2008-05-27 09:23 (12 days old)
> > > > > References	: http://lkml.org/lkml/2008/5/27/9
> > > > > Handled-By	: Oleg Nesterov <oleg@tv-sign.ru>
> > > > > 		  Linus Torvalds <torvalds@linux-foundation.org>
> > > > > 		  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > Patch		: http://lkml.org/lkml/2008/5/28/16
> > > > 
> > > > What happened with this issue?
> > > 
> > > The patch listed above works for me, passes rcutorture, &c.  However,
> > > I never have been able to reproduce the original problem, so cannot say
> > > whether it qualifies as a fix.
> > 
> > I doubt very much RCU was the reason of this problem.
> 
> Although I very much appreciate your confidence in my code, it is new
> code, so therefore under suspicion.
> 
> > Alexey, how did you trigger this problem?
> 
> One of them involved running LTP while doing 170 kernel builds in
> parallel.

My gut feeling is that find_pid_ns oops, __d_lookup oops and
__call_for_each_cic oops are the same bug.

And rcutorture failures I've mentioned to Paul privately.

Oleg, debugging you've posted never triggered.

kerneloops suggests that I'm alone. :-(

