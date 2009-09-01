Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZIAQGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZIAQGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 12:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZIAQGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 12:06:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZIAQGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 12:06:35 -0400
Date: Tue, 1 Sep 2009 18:00:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] kthreads: Fix startup synchronization boot crash
Message-ID: <20090901160043.GA6708@redhat.com>
References: <20090829182718.10f566b1@leela> <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org> <20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com> <20090901155427.GA18078@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901155427.GA18078@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > But I must admit, now I don't understand what happens,
> >
> > 	The modification of that variable is protected by the BKL, but
> > 	the _ordering_ of the initial task (which becomes the idle
> > 	thread of CPU0) and the init task (which is spawned by the
> > 	initial task) is not synchronized.
> >
> > 	So we can occasionally end up init running sooner than
> > 	rest_init()
> >
> > How? rest_init() can't be preempted and it holds BKL. And
> > kernel_init() takes BKL before anything else. Confused...
>
> it cannot be preempted but it can schedule anywhere - and the BKL
> will be dropped silently.
>
> This is one of the biggest dangers of the BKL

Yes I see. But rest_init() runs under preempt_disable(). If it was
rescheduled, schedule_debug() should complain. No?

Oleg.

