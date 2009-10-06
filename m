Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZJFMPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZJFMPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbZJFMPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:15:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274AbZJFMPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:15:17 -0400
Date: Tue, 6 Oct 2009 14:14:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: find_busiest_group using lots of CPU
Message-ID: <20091006121425.GA24070@elte.hu>
References: <20090930081811.GP23126@kernel.dk> <1254745898.26976.52.camel@twins> <20091006075127.GF5216@kernel.dk> <20091006112006.GO5216@kernel.dk> <1254830661.21044.275.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254830661.21044.275.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-10-06 at 13:20 +0200, Jens Axboe wrote:
> > > > io_schedule() straight into find_busiest_group() leads me to think this
> > > > could be SD_BALANCE_NEWIDLE, does something like:
> > > > 
> > > > for i in /proc/sys/kernel/sched_domain/cpu*/domain*/flags; 
> > > > do 
> > > >     val=`cat $i`; echo $((val & ~0x02)) > $i; 
> > > > done
> > > > 
> > > > [ assuming SCHED_DEBUG=y ]
> > > > 
> > > > Cure things?
> > > 
> > > I can try,
> > 
> > It does, it's gone from the profiles.
> 
> Hrmm,. ok. I'll go prod at the NEWIDLE bits to see if anything stands
> out.
> 
> If only perf-annotate could generate annotated C... maybe I'll look at 
> that.

hey it can do that - build a vmlinux with DEBUG_INFO=y and it should 
just work :-)

	Ingo
