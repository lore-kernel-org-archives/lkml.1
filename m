Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbXLGLl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbXLGLl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXLGLlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:41:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34750 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbXLGLlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:41:17 -0500
Date: Fri, 7 Dec 2007 12:40:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bob Tracy <rct@frus.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mcree@orcon.net.nz,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org,
       kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Message-ID: <20071207114048.GB14598@elte.hu>
References: <20071206163305.c3587675.akpm@linux-foundation.org> <20071207050709.110D2DBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207050709.110D2DBA2@gherkin.frus.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bob Tracy <rct@frus.com> wrote:

> > I'm struggling to see how any of those could have broken block 
> > device mounting on alpha.  Are you sure you bisected right?
> 
> Based on what's in that commit, it *does* appear something went wrong 
> with bisection.  If the implicated commit is the next one in time 
> sequence relative to
> 
> # good: [2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
> 
> then the test of whether I bisected correctly is as simple as applying 
> the commit and seeing if things break, because I'm running on the 
> kernel corresponding to 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 right 
> now.  Let me give that a try and I'll report back.  Worst case, I'll 
> have to start over and write off the past four days...

generally it's easier to just go "back in time" and re-try the last 
known "good" and last-known "bad" commit IDs to establish that they are 
indeed correctly identified. if they are not then step back one more in 
the bisection log. No need to spend another 4 days on this, if most of 
the bisection is OK. You can replay a corrected git bisection log 
quickly, by doing:

  git-bisect reset
  git-bisect < bisect.log

	Ingo
