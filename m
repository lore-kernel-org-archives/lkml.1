Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbYAWUCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbYAWUCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 15:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYAWUB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 15:01:56 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:44415 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYAWUBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 15:01:55 -0500
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
	disabled
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <1201114213.13596.29.camel@imap.mvista.com>
References: <20080123160236.969334052@goodmis.org>
	 <20080123160441.236562634@goodmis.org>
	 <1201107978.13596.16.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>
	 <1201110185.13596.22.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0801231315500.6127@gandalf.stny.rr.com>
	 <1201112899.13596.25.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0801231336540.9982@gandalf.stny.rr.com>
	 <1201114213.13596.29.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 11:59:44 -0800
Message-Id: <1201118384.13596.31.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-23 at 10:50 -0800, Daniel Walker wrote:
> On Wed, 2008-01-23 at 13:43 -0500, Steven Rostedt wrote:
> > On Wed, 23 Jan 2008, Daniel Walker wrote:
> > 
> > >
> > > On Wed, 2008-01-23 at 13:18 -0500, Steven Rostedt wrote:
> > >
> > > > The wakeup hook in schedule is when we find out that we hit our max. I
> > > > could postpone that somehow, but that would require more glue code than I
> > > > would like to add.
> > >
> > > Which hook specifically ?
> > 
> > The wakeup tracer does a print on max when the new task is about to be
> > switched to (in context_switch).
> 
> You can't move that hook to when the task actually starts running (i.e.
> at the end of schedule() )..

I mean , why can't you?

Daniel

