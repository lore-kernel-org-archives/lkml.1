Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbZEGIUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbZEGIUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZEGIUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:20:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZEGIUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:20:13 -0400
Date: Thu, 7 May 2009 10:19:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090507081924.GC12285@elte.hu>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506203224.684C7FC39E@magilla.sf.frob.com> <20090506204700.GA24160@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506204700.GA24160@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, May 06, 2009 at 01:32:24PM -0700, Roland McGrath wrote:
> > > Something like the patch below allows the reuse of the locked 
> > > version of __ptrace_may_access and pushes the int->bool conversion 
> > > into an inline.
> > 
> > I think it would be cleaner and safe/simple enough to invert the public
> > ptrace_may_access() to just return the int and invert the ! on all the
> > callers (all one in fs/proc/task_mmu.c and all four in fs/proc/base.c).
> 
> Yeah.  And at the same time we might move it out of ptrace.c and 
> give it a more descriptive name given that most users aren't 
> related to ptrace in any way.  may_inspect_task maybe? [...]

That name (due to the 'may') signals/suggests a bool property as 
well, so if it has a retval==0 convention it's either incorrectly 
named, or the return convention need to stay a bool.

> [...]  I'm good at naming things..

not in this case ;-)

	Ingo
