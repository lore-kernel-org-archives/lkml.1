Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXFVNji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXFVNji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbXFVNja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:39:30 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:44276 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbXFVNja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:39:30 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, hch@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, johnstul@us.ibm.com,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       davem@davemloft.net, kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622061326.2e2d6d15.akpm@linux-foundation.org>
References: <20070622040014.234651401@goodmis.org>
	 <20070622070948.GA21291@infradead.org>
	 <1182515542.5493.20.camel@localhost.localdomain>
	 <20070622123805.GA9770@elte.hu>
	 <1182517124.5493.38.camel@localhost.localdomain>
	 <20070622061326.2e2d6d15.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 09:35:40 -0400
Message-Id: <1182519340.5493.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 06:13 -0700, Andrew Morton wrote:
> > On Fri, 22 Jun 2007 08:58:44 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2007-06-22 at 14:38 +0200, Ingo Molnar wrote:
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:

> > > > Honestly, I highly doubted that this would make it up to Linus's tree.
> > > 
> > > that's where it belongs - but it first needs the cleanups suggested by 
> > > Christoph.
> > 
> > I had the impression that he didn't want it in, but instead wanted each
> > driver to be changed separately.
> 
> I do think that would be a better approach.  Apart from the cleanliness
> issue, the driver-by-driver conversion would make it much easier to hunt
> down any regresions or various funnineses.
> 

Actually, I disagree with driver by driver ease of hunting down
regressions. Perhaps a regression is caused by having two different
drivers have their tasklets converted to work queues. Or where their
might be any case a tasklet is somehow related to another tasklet.

Switching all tasklets at once can pin point the problem rather quickly.
Then it's easy to find which driver was the culprit.

-- Steve


