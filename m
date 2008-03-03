Return-Path: <linux-kernel-owner+w=401wt.eu-S1759770AbYCCJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770AbYCCJYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYCCJYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:24:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbYCCJYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:24:40 -0500
Date: Mon, 3 Mar 2008 10:24:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SCHED_IDLE documentation
Message-ID: <20080303092422.GA18281@elte.hu>
References: <1203376368.275756.252634247263.1.gpush@pokey> <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de> <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu> <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
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


* Michael Kerrisk <mtk.manpages@googlemail.com> wrote:

> On Mon, Mar 3, 2008 at 8:33 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > > If we don't have any man page, what is the actual definition of
> > > SCHED_IDLE anyway?
> >
> > it's rather simple: "it's a priority level even lower priority than nice
> > +19".
> 
> Some other questions whose answers may be worth including in the man page:
> 
> * When was SCHED_IDLE added?  (Actually, who added it?)

"git-blame include/linux/sched.h" gives you that information, it was 
added by me as part of CFS:

  commit 0e6aca43e08a62a48d6770e9a159dbec167bf4c6
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Mon Jul 9 18:51:57 2007 +0200

      sched: add SCHED_IDLE policy
 
> * Why was it added?  (What are the particular benefits of the new 
> sceuling class as opposed to using a very low nice value for 
> SCHED_OTHER?)

because some people wanted even lower priorities than what nice +19 
gave, and extending nice levels wasnt possible for ABI reasons.

> * What's the difference between SCHED_IDLE and SCHED_BATCH?

SCHED_BATCH can still have nice levels from -20 to +19, it is a modified 
SCHED_OTHER/SCHED_NORMAL for "throughput oriented" workloads.

SCHED_IDLE overrides the nice settings and it means a "super idle" 
workload.

	Ingo
