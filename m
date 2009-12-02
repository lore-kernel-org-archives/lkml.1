Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZLBSzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZLBSzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZLBSzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:55:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbZLBSzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:55:24 -0500
Date: Wed, 2 Dec 2009 19:49:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091202184938.GB14799@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259697242.1697.1075.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Peter Zijlstra wrote:
>
> > +void utrace_resume(struct task_struct *task, struct pt_regs *regs)
> > +{
> > +	struct utrace *utrace = task_utrace_struct(task);
> > +	INIT_REPORT(report);
> > +	struct utrace_engine *engine;
> > +
> > +	/*
> > +	 * Some machines get here with interrupts disabled.  The same arch
> > +	 * code path leads to calling into get_signal_to_deliver(), which
> > +	 * implicitly reenables them by virtue of spin_unlock_irq.
> > +	 */
> > +	local_irq_enable();
>
> Hrmm, I would much prefer to fix up the calling conventions of
> tracehook_notify_resume() than to bury something like this in the guts
> of a tracehook user.

Missed this part too.

May be, I dunno...

But in any case, imho it would be better to do this after we merge utrace,
otherwise we need more subtle arch-dependent changes before.

Oleg.

