Return-Path: <linux-kernel-owner+w=401wt.eu-S965679AbXCLLUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679AbXCLLUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965676AbXCLLUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:20:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965646AbXCLLUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:20:23 -0400
Date: Mon, 12 Mar 2007 12:19:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, drepper@redhat.com, oleg@tv-sign.ru,
       sebastien.dugue@bull.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312111958.GA14573@elte.hu>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <20070312091628.GE28546@wotan.suse.de> <20070312110204.GD2231@elte.hu> <20070312111331.GF28546@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312111331.GF28546@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > even if this means more work for you (i'm sorry about that!) i'm 
> > quite sure we should take Sebastien's hrtimers based implementation 
> > of futex_wait(), and use the nanosleep method to restart it. There's 
> > no point in further tweaking the imprecise approach: whenever some 
> > timeout needs to be restarted, it's a candidate for hrtimers.
> 
> Absolute timeout is needed, sure. But once that is done, hrtimers does 
> not fix a bug, does it?

the issue is this: your fix reduces the effects of the bug but it is 
still fundamentally incomplete because of the use of timer_list. So 
instead of trying to fix the bug the wrong way, please try to fix it the 
right way, ontop of an already existing and tested patch, ok? That also 
enables the other neat stuff Thomas talked about.

> > until then, glibc already handles timeouts and restarts it manually.
> 
> It isn't timeout handling that is buggy, but EINTR behaviour. And 
> glibc does not handle that here.

hm. I'm wondering how this wasnt noticed sooner - this futex_wait 
behavior has been there for like forever.

	Ingo
