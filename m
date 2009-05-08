Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbZEHMF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbZEHMF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZEHMFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:05:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZEHMFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:05:46 -0400
Date: Fri, 8 May 2009 14:05:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: clean up for ftrace_set_clr_event()
Message-ID: <20090508120531.GA18758@elte.hu>
References: <4A03998E.3020503@cn.fujitsu.com> <20090508105013.GA6417@nowhere> <4A041478.5070401@cn.fujitsu.com> <20090508112758.GD6417@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508112758.GD6417@nowhere>
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

> On Fri, May 08, 2009 at 07:16:08PM +0800, Li Zefan wrote:
> > Frederic Weisbecker wrote:
> > > On Fri, May 08, 2009 at 10:31:42AM +0800, Li Zefan wrote:
> > >> Add a helper function __ftrace_set_clr_event(), and replace some
> > >> ftrace_set_clr_event() calls with this helper, thus we don't need any
> > >> kstrdup() or kmalloc().
> > >>
> > >> As a side effect, this patch fixes an issue in self tests code, which is
> > >> similar to the one fixed in commit d6bf81ef0f7474434c2a049e8bf3c9146a14dd96
> > >> ("tracing: append ":*" to internal setting of system events")
> > >>
> > >> It's a small issue and won't cause any bug in fact, but we should do things
> > >> right anyway.
> > >>
> > >> [ Impact: clean up ]
> > > 
> > > If this fixes an issue like you described, then it's more than a cleanup :)
> > > 
> > 
> > That issue causes no bug, and that's why I call it a cleanup.
> > 
> > How about (mainly stealed from commit d6bf81ef0f7474434c2a049e8bf3c9146a14dd96):
> > 
> > [ Impact: prevent accidental enabling of events with same name as a system in self tests ]
> > 
> > But it excceeds 80 char..
> > 
> > I sometimes feel it hard to write Impact line (one of the reason is my limit
> > English skill). I've explained the impact of this patch in detail, but I'm
> > still required to add a one-line summary. :(
> 
> 
> Well, I also find hard to write straightforward and good matching
> impact lines.
> And I'm certainly not well suited to give any advices about how
> to write good impact lines.
> 
> But IMHO you can sum up your above impact line.
> 
> [ Impact: prevent spurious events enabling in tracing selftests ]

Thanks, i used this minor variant of it:

[ Impact: prevent spurious event-enabling in tracing self-tests ]

> They usually don't need more details, those details can be placed 
> in the changelog. It's more about the general pratical impact, not 
> a detailed one.

Yeah. There's two ends of the spectrum. The too terse:

 [ Impact: fix ]

that one is unhelpful beacause it's largely meaningless.

The too verbose:

 [ Impact: fix crash in foo while bar was setting baz to more
           than alice when charlie saw the full moon, by setting
           blah to bleh ]

Which is unhelpful because long impact lines tend to include 
implementational details while the goal is a 'quick practical impact 
on system summary'.

Best one is to find some middle ground. In any case, dont worry 
about getting it wrong either, it's an iterative process.

	Ingo
