Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZJZLVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZJZLVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZJZLVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:21:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60204 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbZJZLVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:21:18 -0400
Date: Mon, 26 Oct 2009 12:21:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Kill off -Wcast-align
Message-ID: <20091026112111.GA24010@elte.hu>
References: <20091026054000.GA13517@linux-sh.org> <20091026062520.GA29580@elte.hu> <20091026094729.GB13517@linux-sh.org> <84144f020910260308r106574e3vdd72e8697571bdc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020910260308r106574e3vdd72e8697571bdc2@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> * Paul Mundt <lethal@linux-sh.org> wrote:
> >> > The present use of -Wcast-align causes the build to blow up on SH due to
> >> > generating a "cast increases required alignment of target type" error on
> >> > each invocation of list_for_each_entry().
> >> >
> >> > It seems that this was previously reported and killed off in the ia64
> >> > support patch, but nothing seems to have happened with that. Presumably
> >> > the same problem still remains there, too.
> >> >
> >> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> On Mon, Oct 26, 2009 at 07:25:20AM +0100, Ingo Molnar wrote:
> >> Is this a GCC bug producing false positive warnings? The GCC manpage
> >> says:
> >>
> >>        -Wcast-align
> >>            Warn whenever a pointer is cast such that the required alignment of the
> >>            target is increased.  For example, warn if a "char *" is cast to an
> >>            "int *" on machines where integers can only be accessed at two- or
> >>            four-byte boundaries.
> >>
> >> Which looks moderately useful - if it works.
> 
> On Mon, Oct 26, 2009 at 11:47 AM, Paul Mundt <lethal@linux-sh.org> wrote:
>
> > Well, both ia64 and sh have hit this in the current compilers, and 
> > it doesn't seem to pose any code generation issues. In the areas 
> > where it is generated it seems to relate to 64-bit data types in the 
> > data structures, which in itself doesn't seem inherently 
> > problematic.
> >
> > I'll submit a bug report to the GCC folks, but for the time being 
> > given that multiple architectures are hitting this and it doesn't 
> > seem to be causing any issues, it would be better to have this flag 
> > dropped.
> 
> Can we disable the flag for affected architectures but keep it enabled 
> for x86?

For now i've applied Paul's fix - x86 doesnt have such type restrictions 
and i dont remember this warning having flagged some real data structure 
alignment bug anywhere.

	Ingo
