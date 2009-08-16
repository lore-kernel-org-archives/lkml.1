Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbZHPPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbZHPPSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZHPPSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:18:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47056 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbZHPPSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:18:42 -0400
Date: Sun, 16 Aug 2009 17:18:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf: Enable more compiler warnings
Message-ID: <20090816151829.GA8116@elte.hu>
References: <tip-83a0944fa919fb2ebcfc1f8933d86e437b597ca6@git.kernel.org> <20090816141518.GC6031@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816141518.GC6031@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Sun, Aug 16, 2009 at 08:57:54AM +0000, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  83a0944fa919fb2ebcfc1f8933d86e437b597ca6
> > Gitweb:     http://git.kernel.org/tip/83a0944fa919fb2ebcfc1f8933d86e437b597ca6
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Sat, 15 Aug 2009 12:26:57 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sun, 16 Aug 2009 10:47:47 +0200
> > 
> > perf: Enable more compiler warnings
> > 
> > Related to a shadowed variable bug fix Valdis Kletnieks noticed
> > that perf does not get built with -Wshadow, which could have
> > helped us avoid the bug.
> > 
> > So enable -Wshadow and also enable the following warnings on
> > perf builds, in addition to the already enabled -Wall -Wextra
> > -std=gnu99 warnings:
> > 
> >  -Wcast-align
> >  -Wformat=2
> 
> 
> I also have code like the following from perf trace:
> 
> char format[32];
> [...]
> 
> memcpy(format, dynamic_built_format, ...)
> 
> printf(format, ....)
> 
> And that triggers warnings like that:
> 
> util/trace-event-parse.c:2280: error: format is not a literal string, argument types can't be checked
> 
> Do we also want these?
> 
> ftrace uses dynamic format definition, and it's a natural way to 
> copy them from debugfs and then used like that.
> 
> Especially here perf trace checked the format against bad things.

ok, lets turn the format warnings off.

	Ingo
