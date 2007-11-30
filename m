Return-Path: <linux-kernel-owner+w=401wt.eu-S1764342AbXK3DDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764342AbXK3DDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 22:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763863AbXK3DCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 22:02:55 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:28301 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759338AbXK3DCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 22:02:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jEBe6MzvURRbGZbAPYl0SB0RfHVRTqFczrAtVl5Ts+pFoycTpFqKe7pWEFQiZyHgVIlYV0cxYc+fTqq64VP57P3w+pKpwEjUet0Fj0HXh924t0+NyLNnUqm14CqQF8h6QGn8kheozplDJCzOCl6YjpPLmTO/oBsE+XOcPV7joZo=  ;
X-YMail-OSG: 9wLiMkYVM1nD7UnohN6MSK9qSQRwXYcPbjNWSoKnUYQzt2yUo7sPtPa6EvMJLdTWUfqMSFGHaQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Fri, 30 Nov 2007 14:02:36 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
References: <1196155985.25646.31.camel@ymzhang> <200711301346.22573.nickpiggin@yahoo.com.au> <20071129185144.209108dd@laptopd505.fenrus.org>
In-Reply-To: <20071129185144.209108dd@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301402.36851.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007 13:51, Arjan van de Ven wrote:
> On Fri, 30 Nov 2007 13:46:22 +1100
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > Todays kernel has a different behavior somewhat (and before people
> > > scream "regression"; sched_yield() behavior isn't really specified
> > > and doesn't make any sense at all, whatever you get is what you
> > > get.... it's pretty much an insane defacto behavior that is
> > > incredibly tied to which decisions the scheduler makes how, and no
> > > app can depend on that
> >
> > It is a performance regression. Is there any reason *not* to use the
> > "compat" yield by default? As you say, for SCHED_OTHER tasks, yield
> > can do almost anything. We may as well do something that isn't a
> > regression..
>
> it just makes OTHER tests/benchmarks regress.... this is one of those
> things where you just can't win.

OK, which ones? Because java is slightly important...


> > > in any way. In fact, I've proposed to make sched_yield() just do an
> > > msleep(1)... that'd be closer to what sched_yield is supposed to do
> > > standard wise than any of the current behaviors .... ;_
> >
> > What makes you say that? IIRC of all the things that sched_yeild can
> > do, it is not allowed to block. So this is about the only thing that
> > will break the standard...
>
> sched_yield OF COURSE can block.. it's a schedule call after all!

In unix, blocking ~= removed from runqueue, no?

OF COURSE it is allowed to cooperatively schedule another task, but
I don't see why you think it should so obviously be allowed to block
/ sleep.

It breaks the basically only invariant of sched_yeild in that the
task will no longer run when there is nothing else running.
