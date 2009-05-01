Return-Path: <linux-kernel-owner+w=401wt.eu-S1765330AbZEAUBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765330AbZEAUBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbZEAUB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:01:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59469 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764970AbZEAUBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:01:25 -0400
Date: Fri, 1 May 2009 21:59:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090501195941.GA28264@elte.hu>
References: <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com> <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430154255.GA3714@elte.hu> <alpine.DEB.1.10.0904301142140.4028@qirst.com> <20090430160606.GA5913@elte.hu> <alpine.LFD.2.00.0904300914110.3395@localhost.localdomain> <20090430172341.GA11865@elte.hu> <alpine.DEB.1.10.0904301406210.11923@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904301406210.11923@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 30 Apr 2009, Ingo Molnar wrote:
> 
> > So we introduced preemption-safety in the v2 version of that commit.
> >
> > This non-atomicity will 1) either not matter 2) will be 
> > irq-atomic by virtue of being within a critical section 3) can 
> > be made atomic in the few remaining cases.
> >
> > And maybe, at most, introduce an opt-in API: 
> > percpu_add_irqsafe().
> 
> Plus percpu_add_preemptsafe().

Ok - that would be easy. Would you be interested in doing that and 
would you be interested in resurrecting your old patches? They are 
genuinely useful IMHO.

	Ingo
