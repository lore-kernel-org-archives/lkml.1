Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZCMJbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZCMJbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZCMJba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:31:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35579 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZCMJb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:31:29 -0400
Date: Fri, 13 Mar 2009 10:31:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/ipi] generic-ipi: eliminate spurious pointless
	WARN_ON()s
Message-ID: <20090313093109.GE2571@elte.hu>
References: <49B91A7E.76E4.0078.0@novell.com> <tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org> <1236934491.5188.209.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236934491.5188.209.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-03-13 at 01:39 +0000, Jan Beulich wrote:
> > Commit-ID:  6a09dfa870ba0ed21b1124539968a36b42660661
> > Gitweb:     http://git.kernel.org/tip/6a09dfa870ba0ed21b1124539968a36b42660661
> > Author:     Jan Beulich <jbeulich@novell.com>
> > AuthorDate: Thu, 12 Mar 2009 13:21:50 +0000
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 13 Mar 2009 02:14:41 +0100
> > 
> > generic-ipi: eliminate spurious pointless WARN_ON()s
> > 
> > Namely during early boot, the panic() or BUG() paths may end up in
> > smp_call_function_*() with just a single online CPU. In that situation
> > the warnings generated are not only meaningless, but also result in
> > relevant output being cluttered.
> > 
> > Therefore, defer the WARN_ON() checks until after the (unaffected from
> > the problem that is being attempted to be detected here) cases have
> > been handled.
> > 
> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > LKML-Reference: <49B91A7E.76E4.0078.0@novell.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> I don't really like this,.. it moves the WARN_ON to weird 
> locations without an explanatory comment.

ok, i've reverted it for now.

	Ingo
