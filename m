Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZDENwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZDENwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 09:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZDENw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 09:52:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46514 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZDENw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 09:52:26 -0400
Date: Sun, 5 Apr 2009 15:51:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Len Brown <lenb@kernel.org>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM: Warn if interrupts are enabled during
	suspend-resume of sysdevs
Message-ID: <20090405135108.GC25250@elte.hu>
References: <200904042323.19866.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904042323.19866.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Sysdev have to be suspended and resumed with interrupts disabled 
> and things usually break in a way that's difficult to debug if one 
> of sysdev drivers enables interrupts by mistake during suspend or 
> resume.  Add extra checks that will generate warnings in such 
> cases.

no objections - but obviously the real solution would be to finish 
PeterZ's "detect assymetric kernel functions" patch:

That patch (Peter posted an initial version of it already on lkml) 
works the following way:

the ftrace function-graph-tracer plugin is utilized to instrument 
every function call in the kernel. That is extended with the 
following check: every function except __lockfunc and __sched 
functions must be 'balanced' - i.e. they must enter and exit with 
the same IRQ flags, preempt count and lock depth counter.

	Ingo
