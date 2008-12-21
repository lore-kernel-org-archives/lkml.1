Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbYLUIrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbYLUIrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 03:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYLUIrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 03:47:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbYLUIrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 03:47:11 -0500
Date: Sun, 21 Dec 2008 09:46:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com,
       a.p.zijlstra@chello.nl, dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
       davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
       gregory.haskins@gmail.com, pavel@suse.cz,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-ID: <20081221084630.GD6395@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com> <20081218175622.29812.69201.stgit@drishya.in.ibm.com> <20081219135508.9c6217ba.akpm@linux-foundation.org> <20081220043638.GA24181@dirshya.in.ibm.com> <20081219204455.5f954823.akpm@linux-foundation.org> <20081220100228.GB24181@dirshya.in.ibm.com> <20081220103602.GC24181@dirshya.in.ibm.com> <20081220105652.GD24181@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220105652.GD24181@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-20 16:06:02]:
> 
> > * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-12-20 15:32:28]:
> > 
> > > * Andrew Morton <akpm@linux-foundation.org> [2008-12-19 20:44:55]:
> > > 
> > > > On Sat, 20 Dec 2008 10:06:38 +0530 Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > > 
> > > > > > kernel/sched.c: In function 'schedule':
> > > > > > kernel/sched.c:3679: warning: 'active_balance' may be used uninitialized in this function
> > > > > > 
> > > > > > This warning is correct - the code is buggy.
> > > > > 
> > > > > Yes this is my code bug.  I did not see the warning in sched.c.  Is
> > > > > there any build option that I need to pass in order to get -Wall
> > > > > effect?
> > > > 
> > > > That was just with plain old kbuild: `make allmodconfig;make'.
> > > > 
> > > > That warning was produced by gcc-4.0.2.  If you're using something more
> > > > recent then gcc has regressed.
> > > 
> > > This is an interesting problem.  I am unable to get that warning in the
> > > following GCC versions even with a combination of the following
> > > cmdline options: -Wall -Wextra -Wuninitialized
> > > 
> > > gcc version 4.1.2 20070502
> > > gcc version 4.2.3
> > > 
> > > I will look for older gcc and check this out.
> > 
> > I am able to get the above warning in 
> > gcc version 3.4.6 (Debian 3.4.6-9)
> > with default kbuild, no additional params.
> > 
> > Did not get the warning in 
> > gcc version 4.1.3 20080623
> > 
> > Hence there has been some change in GCC that prevented the
> > uninitialized warning.
> 
> Related GCC bug: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=179 Claimed 
> to have been fixed in GCC 4.4, but I don't know if we are ready to test 
> kernel compile with GCC 4.4.

4.4 is still way too noisy on x86 so not really practical.

> I have tested till gcc version 4.3.2 (Debian 4.3.2-1) and the bug is not 
> fixed.  I do not get the warning from sched.c.

neither did i get that warning. But Andrew did so thankfully, so we've got 
the fix :) We'll always need variance in testing.

	Ingo
