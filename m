Return-Path: <linux-kernel-owner+w=401wt.eu-S932766AbZIDHib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbZIDHib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZIDHia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:38:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45795 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZIDHia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:38:30 -0400
Date: Fri, 4 Sep 2009 09:37:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, arjan@infradead.org,
       jeremy@goop.org, mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill
	kthreadd_task_init_done
Message-ID: <20090904073749.GB20598@elte.hu>
References: <20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu> <20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu> <20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu> <20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com> <m13a76xnbw.fsf@fess.ebiederm.org> <20090902091340.GA5173@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902091340.GA5173@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> On 09/01, Eric W. Biederman wrote:
> >
> > Oleg Nesterov <oleg@redhat.com> writes:
> >
> > > On 09/01, Oleg Nesterov wrote:
> > >>
> > >> On 09/01, Ingo Molnar wrote:
> > >> >
> > >> > * Oleg Nesterov <oleg@redhat.com> wrote:
> > >> >
> > >> > > On 09/01, Ingo Molnar wrote:
> > >> > > >
> > >> > > > * Oleg Nesterov <oleg@redhat.com> wrote:
> > >> > > >
> > >> > > > > Yes, this should work. But I _think_ we can make the better fix...
> > >> > > > >
> > >> > > > > I'll try to make the patch soon. Afaics we don't need
> > >> > > > > kthreadd_task_init_done.
> > >> > > >
> > >> > > > ok.
> > >> > >
> > >> > > Just in case, the patch is ready. [...]
> > >> >
> > >> > yes - that's roughly the cleanup i referred to in the commit log.
> > >> >
> > >> > way too late for -rc8 though - the minimal fix i did _might_ be
> > >> > eligible.
> > >> >
> > >> > agreed?
> > >>
> > >> Agreed. Then I will sent the patch on top of this change.
> > >
> > > OK, I am sending the patch on top of your fix. Not sure how to really
> > > test it, but at least the kernel works when I apply the debugging patch
> > > below on top.
> >
> > Stupid question.  How is it that we wind up trying to start kernel threads
> > before it is safe to do so?
> >
> > Races should be impossible because the scheduler isn't running until a few
> > lines later.
> 
> Yes, I am confused too.
> 
> At first I thought I understand the race, now I don't. Please see 
> the whole thread: http://marc.info/?t=125180592500005

I dont understand it either - and the .config being !SMP excludes 
any sort of SMP race as well.

Lets delay this until i can debug it more fully.

	Ingo
