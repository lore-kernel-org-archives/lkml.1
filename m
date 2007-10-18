Return-Path: <linux-kernel-owner+w=401wt.eu-S1762760AbXJRLOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760AbXJRLOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbXJRLOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:14:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbXJRLOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:14:09 -0400
Date: Thu, 18 Oct 2007 13:13:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: latest checkpatch
Message-ID: <20071018111352.GA17039@elte.hu>
References: <20071015182118.GA4459@shadowen.org> <200710161759.l9GHxnkK012590@agora.fsl.cs.sunysb.edu> <20071017163916.GO21136@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017163916.GO21136@shadowen.org>
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


latest checkpatch.pl works really well on sched.c.

there's only one problem left, this bogus false positive warning 
reappeared:

  WARNING: braces {} are not necessary for single statement blocks
  #5710: FILE: sched.c:5710:
  +       if (parent->groups == parent->groups->next) {
  +               pflags &= ~(SD_LOAD_BALANCE |
  +                               SD_BALANCE_NEWIDLE |
  +                               SD_BALANCE_FORK |
  +                               SD_BALANCE_EXEC |
  +                               SD_SHARE_CPUPOWER |
  +                               SD_SHARE_PKG_RESOURCES);
  +       }

(there's another place in sched.c that trips this up too.)

i think it has been pointed out numerous times that it is perfectly fine 
to use curly braces for multi-line single-statement blocks. That 
includes simple cases like this too:

	if (x) {
		/* do y() */
		y();
	}

it's perfectly legitimate, in fact more robust. So if checkpatch.pl 
wants to make any noise about such constructs it should warn about the 
_lack_ of curly braces in every multi-line condition block _except_ the 
only safe single-line statement:

	if (x)
		y();

thanks,

	Ingo
