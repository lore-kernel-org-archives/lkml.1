Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbYCGOJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbYCGOJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 09:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbYCGOJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 09:09:05 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59390 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbYCGOJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 09:09:04 -0500
Date: Fri, 7 Mar 2008 06:08:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Jike Song <albcamus@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc4 rcupreempt.h WARNINGs while suspend/resume
Message-ID: <20080307140856.GG19183@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <a8e1da0803051920t586c7fbapadda70ae895f8893@mail.gmail.com> <a8e1da0803060308o690c1545l1eaffc0c40f2bc7e@mail.gmail.com> <20080306162724.GA9309@linux.vnet.ibm.com> <a8e1da0803061907k72785f10t2dcb98ca9829e2d8@mail.gmail.com> <20080307041940.GB19183@linux.vnet.ibm.com> <a8e1da0803062035o318bd843o22b561faa52fd19f@mail.gmail.com> <20080307065752.GF19183@linux.vnet.ibm.com> <a8e1da0803062331la1f38fei8303a46f9949ca23@mail.gmail.com> <a8e1da0803062343j1e9cf911q6c1e75b4cc4736dc@mail.gmail.com> <a8e1da0803062355v6d97e949u3dd89cbe3516aac4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0803062355v6d97e949u3dd89cbe3516aac4@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 03:55:41PM +0800, Dave Young wrote:
> On Fri, Mar 7, 2008 at 3:43 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> > On Fri, Mar 7, 2008 at 3:31 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >  > On Fri, Mar 7, 2008 at 2:57 PM, Paul E. McKenney
> >  >
> >  >
> >  > <paulmck@linux.vnet.ibm.com> wrote:
> >  >  >
> >  >  > On Fri, Mar 07, 2008 at 12:35:26PM +0800, Dave Young wrote:
> >  >  >  > On Fri, Mar 7, 2008 at 12:19 PM, Paul E. McKenney
> >  >  >  > <paulmck@linux.vnet.ibm.com> wrote:
> >  >  >  > > On Fri, Mar 07, 2008 at 11:07:48AM +0800, Dave Young wrote:
> >  >  >  > >  > On Fri, Mar 7, 2008 at 12:27 AM, Paul E. McKenney
> >  >  >  > >  > <paulmck@linux.vnet.ibm.com> wrote:
> >  >  >  > >  > > On Thu, Mar 06, 2008 at 07:08:55PM +0800, Dave Young wrote:
> >  >  >  > >
> >  >  >  > > > >  > My syslog became a 2G size big file yestoday due to the warnings.
> >  >  >  > >  > >  > How about change the WARN_ON to WARN_ON_ONCE?
> >  >  >  > >  > >
> >  >  >  > >  > >  Hello, Dave,
> >  >  >  > >  > >
> >  >  >  > >  > >  I might be convinced to make this change for 2.6.26, but the condition
> >  >  >  > >  > >  that the WARN_ON() is complaining about is quite serious, so I don't
> >  >  >  > >  > >  want to take a chance on it getting lost in the noise in the 2.6.25
> >  >  >  > >  > >  series.
> >  >  >  > >  > >
> >  >  >  > >  > >  Seem reasonable?
> >  >  >  > >  >
> >  >  >  > >  > IMHO, WARN_ON_ONCE is enough for my eyes :)
> >  >  >  > >
> >  >  >  > >  I could believe that, but my experience has been that many others
> >  >  >  > >  need the condition to be obvious...
> >  >  >  > >
> >  >  >  > >
> >  >  >  > >  > >  Better yet, is there some sort of time-limited WARN_ON that kicks out
> >  >  >  > >  > >  a message at most once per second or some such?  Enough to definitely
> >  >  >  > >  > >  be noticed, but not enough to bring the machine to its knees?
> >  >  >  > >  >
> >  >  >  > >  > Seems there's no such functions/macros, but is is really needed?
> >  >  >  > >
> >  >  >  > >  If everyone reports errors when they see isolated WARN_ON()s in their
> >  >  >  > >  logfiles, then no.  But...
> >  >  >  >
> >  >  >  > Ok, I agree with you.
> >  >  >  >
> >  >  >  > Maybe something like WARN_ON_HZ(condition) or
> >  >  >  > WARN_ON_PERIOD(condition, period_value)?
> >  >  >
> >  >  >  Makes sense to me!  The other benefit of this sort of thing is that
> >  >  >  it lets you know whether the problem was a one-off or whether it
> >  >  >  continued happening -- but without too much log bloat.
> >  >  >
> >  >  >  I was thinking in terms of once every ten seconds, but am not all
> >  >  >  that hung up on the exact value of the period.
> >  >  >
> >  >  >  Thoughts?
> >  >
> >  >  Then, WARN_ON_SECS(condition, seconds) ?
> >
> >  Sorry, seconds must be a fixed number here, so your 10 secs maybe
> >  suitable for it.
> 
> Or the secs number could be a config option/cmmand line param?

Any of these options could work from my viewpoint:

o	WARN_ON_SECS() would allow someone to tune a particular
	warning to log more or less often.

o	A config option or command-line parameter would mean less
	typing in the source code, and would allow global control.

						Thanx, Paul
