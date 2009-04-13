Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbZDMRmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbZDMRmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZDMRm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:42:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZDMRm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:42:27 -0400
Date: Mon, 13 Apr 2009 19:41:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Message-ID: <20090413174104.GA856@elte.hu>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain> <20090413171853.GA4601@elte.hu> <20090413102749.4ca3a217.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413102749.4ca3a217.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > I think Andrew has a stack of fixes queued up, one of which 
> > should solve this problem too - which Mike tested - as the 
> > commit from Andrew has caused another regression as well.
> > 
> > There's no sha1 - the patch is in this thread on lkml:
> > 
> >   sysbench(oltp)+mysql 10% regression with 2.6.30-rc1
> > 
> > | From: Andrew Morton <akpm@linux-foundation.org>
> > |
> > | Atttempting to rid us of the problematic work_on_cpu().  Just use
> > | smp_call_fuction_single() here.
> > |
> > | This repairs a 10% sysbench(oltp)+mysql regression which Mike 
> > | reported,
> > 
> 
> Yup.  It's presently in Len's hands.  And Rusty's.
> 
> Vladis, perhaps you can verify?

I have not tested it but it looks good and the use of a much more 
atomic primitive can only improve the situation - so unless there's 
something suspicious about it i'd suggest for Linus to pick this up 
from email, before -rc2.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
