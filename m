Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZBKJxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZBKJxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZBKJxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:53:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58396 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZBKJxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:53:37 -0500
Date: Wed, 11 Feb 2009 10:53:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: git pull request for tip/tracing/urgent
Message-ID: <20090211095325.GD20518@elte.hu>
References: <alpine.DEB.1.10.0902101314440.23505@gandalf.stny.rr.com> <20090210183046.GA1342@nowhere> <alpine.DEB.1.10.0902101724190.23505@gandalf.stny.rr.com> <20090211012856.GA4921@nowhere> <20090211090229.GG21105@elte.hu> <49929763.3080608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49929763.3080608@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> Ingo Molnar wrote:
> > This bit:
> > 
> >   	".section .fixup, \"ax\"\n"
> >  	"4: movl $1, %[faulted]\n"
> >  	"   jmp 3b\n"
> >  	".previous\n"
> > 
> > Can be thought of as an 'embedded' or 'nested' section - the '.previous'
> > directive jumps back to whatever section we were in before. This can be
> > nested multiple times too:
> > 
> >    .section A
> >    [...]
> >      .section B
> >      [...]
> >         .section C
> >         [...]
> >         .previous
> >      [...]
> >      .previous
> >    [...]
> >    .previous
> 
> That will result in...
> 
>  A->B->C->B->C->B
> 
> .pushsection and .popsection should be used for nesting, right?
> 
> Thanks.

hm ... doh, yes. I think we even had a bug in this area.

Why is it implemented like this? These semantics seem to make no sense.

	Ingo
