Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZEFION@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZEFION (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZEFIMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:12:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51032 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379AbZEFIMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:12:52 -0400
Date: Wed, 6 May 2009 10:12:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, jdike@addtoit.com,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
Message-ID: <20090506081225.GD8098@elte.hu>
References: <20090503185537.GA17071@redhat.com> <20090504184951.623CEFC32F@magilla.sf.frob.com> <20090504193016.GA17076@redhat.com> <20090504194348.BC0EBFC32F@magilla.sf.frob.com> <20090504163154.f3672a83.akpm@linux-foundation.org> <20090505230642.GA980@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505230642.GA980@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 05/04, Andrew Morton wrote:
> >
> > On Mon,  4 May 2009 12:43:48 -0700 (PDT)
> > Roland McGrath <roland@redhat.com> wrote:
> >
> > > I guess we should take Andrew's advice on this.  To me, it 
> > > makes most sense just to order the -mm patches so utrace comes 
> > > later, and replace the utrace patch as necessary with a 
> > > compatible version.  Perhaps things would be simpler if we 
> > > made a separate standalone series or git tree (tip/ptrace?) 
> > > for ptrace cleanups.
> >
> > Staging the utrace patch at end-of-series would make sense if 
> > utrace is not on track for a 2.6.31 merge.
> >
> > And afaict, this is indeed the case - things seem to have gone a 
> > bit quiet on the utrace front lately.
> 
> The only goal of current ptrace cleanups is to simplify the 
> "ptrace over utrace" change (hopefully they make sense by 
> themselves though).
> 
> I am obviously biased, but imho the only real problem with 
> utrace-ptrace.patch is the current ptrace code which needs 
> cleanups.

Yes. But realize the fundamental reason for that: _without_ 
ptrace-over-utrace the utrace core code is a big chunk of dead code 
only used on the fringes. I see and agree with all the future uses 
of utrace, but it's easy to be problem-free if a facility is not 
used by anything significant.

So a clean ptrace-over-utrace plugin is absolutely needed for utrace 
to go upstream in v2.6.31. The ftrace plugin alone does not justify 
it. The real prize here is a (much!) cleaner ptrace code. Once 
ptrace is driven via utrace and it works, its value (and trust 
level) will skyrocket.

	Ingo
