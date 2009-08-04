Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZHDULn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZHDULn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZHDULn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:11:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45078 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZHDULm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:11:42 -0400
Date: Tue, 4 Aug 2009 22:11:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/26] oprofile: Performance counter multiplexing
Message-ID: <20090804201109.GA21386@elte.hu>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com> <20090803112220.GA22936@elte.hu> <20090803072522.1d90f15c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803072522.1d90f15c@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 3 Aug 2009 13:22:20 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > This new oprofile multiplexing mechanism really overlaps the PMU 
> > abstractions that perfcounters already provide, and i disagree 
> > with this general direction. The code you wrote is clean though 
> > so i've
> 
> is there any way that the oprofile interfaces can be written on 
> top of the low level perf infrastructure?

Everything 'can' be done - the question is, is that the best 
approach? The technically best interface to utilize perfcounters is 
not to whack it into the oprofile kernel code, but to minimally 
update the oprofile user-space code (the sample collection daemon) 
to use the sys_perf_counter_open() system call.

It is by far the most elegant solution and needs no kernel changes 
at all:

The oprofile daemon should open percpu sampling counters and create 
oprofile-compatible sample files. That way the rest of the oprofile 
user-space does not have to be touched at all. The raw event ids 
that oprofile knows about can be used in perfcounter parameters 
directly.

In such a mode of operation both oprofilefs and the dcookies syscall 
can be omitted completely - all of the kernel side oprofile code 
becomes mooted and pushed into legacy mode.

Is there any reason or oprofile property that makes this impossible 
or undesirable to do?

	Ingo
