Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZDLKCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZDLKCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZDLKCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:02:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40438 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbZDLKCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:02:33 -0400
Date: Sun, 12 Apr 2009 12:02:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/7] tracing: bug fixes for tracing/filters
Message-ID: <20090412100205.GA3023@elte.hu>
References: <49E04C22.4040608@cn.fujitsu.com> <1239442248.8793.65.camel@tropicana> <20090411144823.GB5977@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411144823.GB5977@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sat, Apr 11, 2009 at 04:30:48AM -0500, Tom Zanussi wrote:
> > Hi,
> > 
> > On Sat, 2009-04-11 at 15:52 +0800, Li Zefan wrote:
> > > This patchset fixes some bugs in tracing/filters. Most of the change
> > > goes to the last patch, and others are small ones.
> > > 
> > 
> > At first glance, they look good and fix real problems - thanks for
> > fixing them.  Re patch 7, there's been some discussion about using rcu
> > for this.  See:
> > 
> > http://lkml.org/lkml/2009/4/5/46
> > 
> > >From that discussion, it seems some non-trivial changes to rcu would be
> > needed for this.  I'm playing around with a different idea now to
> > hopefully avoid the need for that, or the other approach mentioned, of
> > temporarily stopping tracing while removing/changing the filters.
> > 
> > Basically my thought is to avoid the problem by not allocating or
> > destroying the preds when removing filters but instead switch out the
> > pred->fns with a nop version while keeping the fields intact for awhile.
> > I think that will work for removing filters, but I still need to think
> > about how it would (or would not) work for replacing them.
> >  
> > Tom
> 
> 
> 
> It would be sort of reinventing rcu :-)
>
> Well, Paul proposed something recently, hmm I should 
> double check this discussion.
> 
> Anyway, the fixes from Li (other than 4 and 7 for which we 
> have comments) look very good!

Ok, i've applied 1,2,3,6 to tip/tracing/urgent (most of them 
are fixes needed for current mainline).

5 had dependency on 4 which is being discussed. 7 is being 
discussed as well, with Tom having promised a patch.

Thanks,

	Ingo
