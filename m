Return-Path: <linux-kernel-owner+w=401wt.eu-S1762838AbZEGJei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838AbZEGJei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbZEGJ3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:29:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57174 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761326AbZEGJ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:29:21 -0400
Date: Thu, 7 May 2009 11:27:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] security: rename ptrace_may_access =>
	ptrace_access_check
Message-ID: <20090507092757.GA32526@elte.hu>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507084943.GB19133@elte.hu> <20090507091917.GA23110@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507091917.GA23110@redhat.com>
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

> On 05/07, Ingo Molnar wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > Subject: security: rename ptrace_may_access => ptrace_access_check
> > From: Ingo Molnar <mingo@elte.hu>
> >
> > The ->ptrace_may_access() methods are named confusingly - the real 
> > ptrace_may_access() returns a bool, while these security checks have 
> > a retval convention.
> > 
> > Rename it to ptrace_access_check, to reduce the confusion factor.
> 
> Great. Now we can rename (and fix the callers of) ptrace.c:ptrace_may_access()
> accordingly.
> 
> But,
> 
> > -static inline int security_ptrace_may_access(struct task_struct *child,
> > +static inline int security_ptrace_access_check(struct task_struct *child,
> >  					     unsigned int mode)
> 
> You seem to forgot to update the callers of this helper.

Did i mention that it's completely untested :) Yeah, i'd suggest to 
push this naming down the whole ptrace_may_access landscape, and 
eliminate the bool. In two separate patches: first the rename, then 
the bool-elimination (which is more dangerous).

	Ingo
