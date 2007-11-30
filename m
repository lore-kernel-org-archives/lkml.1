Return-Path: <linux-kernel-owner+w=401wt.eu-S933021AbXK3Cww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbXK3Cww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761708AbXK3Cwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:52:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36087 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbXK3Cwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:52:38 -0500
Date: Thu, 29 Nov 2007 18:51:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071129185144.209108dd@laptopd505.fenrus.org>
In-Reply-To: <200711301346.22573.nickpiggin@yahoo.com.au>
References: <1196155985.25646.31.camel@ymzhang>
	<20071127145747.5f4d0aca@laptopd505.fenrus.org>
	<200711301346.22573.nickpiggin@yahoo.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 13:46:22 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > Todays kernel has a different behavior somewhat (and before people
> > scream "regression"; sched_yield() behavior isn't really specified
> > and doesn't make any sense at all, whatever you get is what you
> > get.... it's pretty much an insane defacto behavior that is
> > incredibly tied to which decisions the scheduler makes how, and no
> > app can depend on that
> 
> It is a performance regression. Is there any reason *not* to use the
> "compat" yield by default? As you say, for SCHED_OTHER tasks, yield
> can do almost anything. We may as well do something that isn't a
> regression..

it just makes OTHER tests/benchmarks regress.... this is one of those
things where you just can't win.

> 
> 
> > in any way. In fact, I've proposed to make sched_yield() just do an
> > msleep(1)... that'd be closer to what sched_yield is supposed to do
> > standard wise than any of the current behaviors .... ;_
> 
> What makes you say that? IIRC of all the things that sched_yeild can
> do, it is not allowed to block. So this is about the only thing that
> will break the standard...

sched_yield OF COURSE can block.. it's a schedule call after all!



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
