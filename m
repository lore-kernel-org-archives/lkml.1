Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYI3Qhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYI3Qhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYI3Qh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:37:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYI3QhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:37:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=S+lXT+TdvRj6aEnTkNnYZ30TEcFJcbqbZka1ZoCmGvhIRKu889yGwC4zOOfInLpZo
	1leY+3QHT3O89UNdE6iwQ==
Subject: Re: [PATCH 2.6.27-rc5 incremental re-resubmit] Fix itimer/many
	thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080930063313.GA23690@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu>
	 <1221502142.19012.35.camel@bobble.smo.corp.google.com>
	 <20080916084143.GC17287@elte.hu>
	 <1221678187.13420.17.camel@bobble.smo.corp.google.com>
	 <20080918102353.GD20967@elte.hu>
	 <1222114936.21579.20.camel@bobble.smo.corp.google.com>
	 <1222291416.30299.6.camel@bobble.smo.corp.google.com>
	 <20080930063313.GA23690@elte.hu>
Content-Type: text/plain
Organization: Google, Inc.
Date: Tue, 30 Sep 2008 09:36:30 -0700
Message-Id: <1222792590.18031.9.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 08:33 +0200, Ingo Molnar wrote:
> * Frank Mayhar <fmayhar@google.com> wrote:
> 
> >  /*
> >   * Return any ns on the sched_clock that have not yet been banked in
> >   * @p in case that task is currently running.
> > - *
> > - * Called with task_rq_lock() held on @rq.
> >   */
> > -static unsigned long long task_delta_exec(struct task_struct *p, struct rq *rq)
> > +unsigned long long task_delta_exec(struct task_struct *p)
> >  {
> > +	struct rq *rq;
> > +	unsigned long flags;
> > +	u64 ns = 0;
> > +
> >  	if (task_current(rq, p)) {
> >  		u64 delta_exec;
> 
> hmmm ... where do we get 'rq' from?
> 
> in v3 you did this:
> 
> -       rq = task_rq_lock(p, &flags);
> 
> which removed the deadlock but left us with a random uninitialized rq 
> variable ...

You know, I just knew I had a brain around here _somewhere_.

Weirdly, this didn't fall over on any of my testing.  The gods know what
it was actually doing, though.

I'm picking up tip/master right now and will test your fix for this
shortly.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

