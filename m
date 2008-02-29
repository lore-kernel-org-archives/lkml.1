Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbYB2Vax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbYB2Vax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbYB2V3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:29:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591AbYB2V3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:29:36 -0500
Date: Fri, 29 Feb 2008 22:29:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Jackson <pj@sgi.com>, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-ID: <20080229212908.GM27212@elte.hu>
References: <20080227222103.673194000@chello.nl> <1204311351.6243.130.camel@lappy> <20080229145516.4d96aeaa.pj@sgi.com> <1204319674.6243.145.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204319674.6243.145.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > Do these irqs have any special hardware affinity?  Or are they just 
> > consumers of CPU cycles that can be jammed onto whatever CPU(s) 
> > we're willing to let be interrupted?
> 
> Depends a bit, the genirq layer seems to allow for irqs that can't be 
> freely placed. But most of them can be given a free mask - /me looks @ 
> tglx/ingo.

yes - and when they cannot be arbitrarily migrated we just dont move 
them (but still keep them attached to that cpuset). The affinity calls 
will just fail in that case. Might want to emit a kernel warning but 
that's all. (if then it's a hardware constraint)

	Ingo
