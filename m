Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYDFLWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYDFLWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 07:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYDFLWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 07:22:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53782 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYDFLWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 07:22:30 -0400
Date: Sun, 6 Apr 2008 13:22:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "H. Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix booting pentium+ with dodgy TSC
Message-ID: <20080406112207.GA26510@elte.hu>
References: <200804061723.38766.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804061723.38766.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Linus please apply.  Almost by definition this patch can't make things 
> worse.

well, while i agree with the patch it could make things worse. In this 
case it can cause code that has been compiled to rely on TSC to 
malfunction. For if sched_clock() was using cpu_has_tsc it could return 
0 all the time, breaking the scheduler without the user having a clear 
idea why it broke. It isnt, and sched_clock() will work fine, but still, 
your "this cant make things worse" statement is not completely correct. 

In any case:

 Acked-by: Ingo Molnar <mingo@elte.hu>

and i've also queued it up into the for-.25 queue of x86.git.

	Ingo
