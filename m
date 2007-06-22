Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbXFVNtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbXFVNtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbXFVNsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:48:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbXFVNsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:48:52 -0400
Date: Fri, 22 Jun 2007 06:41:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: rostedt@goodmis.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, johnstul@us.ibm.com,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-Id: <20070622064159.b762cb13.akpm@linux-foundation.org>
In-Reply-To: <20070622132622.GA21130@elte.hu>
References: <20070622040014.234651401@goodmis.org>
	<20070622070948.GA21291@infradead.org>
	<1182515542.5493.20.camel@localhost.localdomain>
	<20070622123805.GA9770@elte.hu>
	<1182517124.5493.38.camel@localhost.localdomain>
	<20070622061326.2e2d6d15.akpm@linux-foundation.org>
	<20070622132622.GA21130@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 22 Jun 2007 15:26:22 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I do think that would be a better approach.  Apart from the 
> > cleanliness issue, the driver-by-driver conversion would make it much 
> > easier to hunt down any regresions or various funnineses.
> 
> there are 120 tasklet_init()s in the tree and 224 tasklet_schedule()s. 

couple of hours?

> Pushing it into thread context should work just fine (Steve's patchset 
> certainly works on my testbox), as even today we can execute softirqs 
> (and hence tasklets) in ksoftirqd. In fact, -rt has been executing 
> tasklets in task context for over 2.5 years meanwhile. Do we really want 
> to upset the whole API? Realistically it just wont ever be removed, like 
> the BKL.

We can remove it.  It might need to remain deprecated for a year, but we
shouldn't plan on leaving the old interface hanging around for ever.

