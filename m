Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbYALG7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbYALG7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 01:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYALG7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 01:59:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40576 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbYALG7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 01:59:42 -0500
Date: Sat, 12 Jan 2008 07:59:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86_64 save_i387_ia32 snafu
Message-ID: <20080112065921.GB9572@elte.hu>
References: <4786A9CA.2090008@zytor.com> <20080111004422.2B3F926F9A6@magilla.localdomain> <4786BE15.6040604@zytor.com> <20080111024929.37FDB26F9A9@magilla.localdomain> <4786DB3B.8070808@zytor.com> <20080111104357.8364826F9A9@magilla.localdomain> <20080111104932.GA1589@elte.hu> <20080111213147.EBE0C26F9A9@magilla.localdomain> <5212.1200117118@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5212.1200117118@turing-police.cc.vt.edu>
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Fri, 11 Jan 2008 13:31:47 PST, Roland McGrath said:
> > > thanks, applied. Does this explain the crash/hang problems with 32-bit 
> > > apps on 64-bit kernels? What was the exact failure mode?
> > 
> > It does.  Any 32-bit process trying to run a signal handler when it had
> > used the FPU, would clobber "current" with FP bits.  The observed failure
> > mode was shortly after this in the signal handler setup code, when it
> > crashed due to current->mm being zero (current->pid also being zero, and
> > the whole first 512 bytes of the task_struct being garbage).
> 
> For what it's worth, this patch fixes a problem I had in 24-rc6-mm1 
> with kernel panics when certain X programs exited (Eterm being the 
> biggest cause), that I had bisected to "somewhere in 
> git-x86.patch"....

ok, good. Yesterday's x86.git update has this fix included so the next 
-mm iteration should have the fix as well.

	Ingo
