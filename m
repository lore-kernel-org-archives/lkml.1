Return-Path: <linux-kernel-owner+w=401wt.eu-S966398AbXIBM27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966398AbXIBM27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966225AbXIBM2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:28:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56985 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966173AbXIBM2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:28:45 -0400
Date: Sun, 2 Sep 2007 14:28:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm][resend] softlockup-improve-debug-output.patch fix
Message-ID: <20070902122835.GA27438@elte.hu>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <alpine.LFD.0.999.0709020439290.20781@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0709021803060.24993@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709021803060.24993@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Satyam Sharma <satyam@infradead.org> wrote:

> 
> 
> On Sun, 2 Sep 2007, Satyam Sharma wrote:
> > 
> > --- kernel/softlockup.c~fix	2007-09-02 04:23:49.000000000 +0530
> > +++ kernel/softlockup.c	2007-09-02 04:34:45.000000000 +0530
>   ^^^^^^^^^^
> 
> Ick, I botched a trivial patch, it doesn't even apply. Updated one below
> (with indentation fix as added bonus :-)
> 
> 
> [PATCH -mm] softlockup-improve-debug-output.patch fix (v2)
> 
> kernel/softlockup.c: In function 'softlockup_tick':
> kernel/softlockup.c:125: warning: 'regs' is used uninitialized in this function
> 
> is a genuine bug (will cause an oops in all probability, or cause 
> wrong info to be printed, if we're lucky). So let's fix the 
> softlockup-improve-debug-output.patch to actually work as intended.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>

Thanks! Not sure how that bug slipped in, in my tree it does this:

 +       struct pt_regs *regs;
 ...
 +       regs = get_irq_regs();

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
