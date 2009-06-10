Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbZFJMva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbZFJMva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbZFJMvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:51:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967AbZFJMvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:51:22 -0400
Date: Wed, 10 Jun 2009 14:51:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, oleg@redhat.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] x86, bts: reenable ptrace branch trace
	support
Message-ID: <20090610125108.GA13506@elte.hu>
References: <20090424094448.A30216@sedona.ch.intel.com> <tip-7e0bfad24d85de7cf2202a7b0ce51de11a077b21@git.kernel.org> <1244637843.13761.11786.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244637843.13761.11786.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-05-07 at 09:25 +0000, tip-bot for Markus Metzger wrote:
> > Commit-ID:  7e0bfad24d85de7cf2202a7b0ce51de11a077b21
> > Gitweb:     http://git.kernel.org/tip/7e0bfad24d85de7cf2202a7b0ce51de11a077b21
> > Author:     Markus Metzger <markus.t.metzger@intel.com>
> > AuthorDate: Fri, 24 Apr 2009 09:44:48 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 24 Apr 2009 10:18:51 +0200
> > 
> > x86, bts: reenable ptrace branch trace support
> > 
> > The races found by Oleg Nesterov have been fixed.
> > 
> > Reenable branch trace support.
> > 
> > Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> > Acked-by: Oleg Nesterov <oleg@redhat.com>
> > LKML-Reference: <20090424094448.A30216@sedona.ch.intel.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> OK, this whole BTS thing worries me because it seems to expose too 
> much of the Intel Debug Store thingy to the outside world.
> 
> The thing is, once we do PEBS from inside the kernel, we'll have 
> to share the debug store, and the way this thing sets it up isn't 
> really going to work.
> 
> So what I'd like to see is having this debug store removed from 
> the interface and abstracted away as cpu resource -- a single page 
> when in use should suffice I think.
> 
> If you want to expose a buffer to userspace, use the regular 
> mmap() interface and fill those pages from the DS interrupt 
> handler.

hm, that makes sense indeed. We are in the merge window now - 
Markus, what's your suggestion?

	Ingo
