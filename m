Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbXJEF5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbXJEF5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbXJEF4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:56:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50154 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbXJEF4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:56:54 -0400
Date: Fri, 5 Oct 2007 07:56:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20071005055636.GA31111@elte.hu>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org> <20070928092235.GA31180@shadowen.org> <20070928093902.GA28455@elte.hu> <20070928100024.GB18163@shadowen.org> <20070928104935.GA606@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928104935.GA606@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


here is an update wrt. the latest checkpatch.pl-next version 
(v11-to-be), about kernel/sched.c warnings:

>   size                          # warnings
>   ----------------------------------------
>   25383  checkpatch.pl.v6       5
>   26038  checkpatch.pl.v7       6
>   29603  checkpatch.pl.v8       65
>   31160  checkpatch.pl.v9       24
>   34950  checkpatch.pl.v10      28

    35948  checkpatch.pl.v11pre   11

so things are heading in the right direction :)

of those 11 warnings, 6 are correct warnings (4 will be solved via 
KERN_CONT, 1 will be solved via a proper include file, and 1 is an 
overlength line), 4 are borderline warnings (easily fixed) and only one 
is a false positive! So v11-to-be gets the "best checkpatch.pl ever" 
badge from me :)

The false positive is:

  ERROR: need consistent spacing around '*' (ctx:WxV)
  #5322: 
  +static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
                    ^

i think checkpatch.pl mistook this function definition as an arithmetic 
expression?

But, there's a cleanliness bug underlying this false positive: 
'ctl_table' is a typedef, and it would be cleaner to use 'struct 
ctl_table' thoughout the kernel. When running checkpatch.pl over 
include/linux/sysctl.h, it warns about the typedef:

  WARNING: do not add new typedefs
  #944: 
  +typedef struct ctl_table ctl_table;

(but mistaking that function for an arithmetic expression is still a bug 
i think.)

nice work Andy!

	Ingo
