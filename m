Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbZIHGyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbZIHGyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 02:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZIHGyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 02:54:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42081 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbZIHGyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 02:54:04 -0400
Date: Tue, 8 Sep 2009 08:53:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] perf trace: Add filter support
Message-ID: <20090908065355.GB6505@elte.hu>
References: <4AA4C04D.1050201@cn.fujitsu.com> <20090908000219.GB6312@nowhere> <4AA5AE29.6020107@cn.fujitsu.com> <20090908021224.GD6312@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908021224.GD6312@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Sep 08, 2009 at 09:06:49AM +0800, Li Zefan wrote:
> > >> An example:
> > >>
> > >>  #./perf record -f -e irq:irq_handler_entry:irq==18:record
> > >>  or
> > >>  #./perf record -f -e irq:irq_handler_entry:irq==18 -R
> > >>  ^C
> > > 
> > > We may want to write complex filters. While looking at this patchset,
> > > that seems possible this way, but the raw line may become unreadable:
> > > 
> > > perf record -f -e irq:irq_handler_entry:"irq==18 && (name == 'foo' || bar == 'blah')":record
> > > 
> > > May be we should add an option to let one also set the filters seperately then
> > > we could do:
> > > 
> > > perf record -f -e -R irq:irq_handler_entry --filter "irq==18 && (name == 'foo' || bar == 'blah')"
> > > 
> > 
> > I had the same idea. ;)
> > 
> > But using this option, is it possible to specify different filters
> > for different events? like this:
> > 
> > perf record -f -e -R irq:irq_handler_entry --filter "irq==18"
> > -e irq:softirq_entry --filter "vec==1"
> > 
> 
> 
> Exactly how I was imagining it :)

Yes, that looks like a nice syntax. First the event, then the 
conditions that restrict its output.

	Ingo
