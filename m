Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbZANLWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbZANLWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 06:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZANLWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 06:22:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41999 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbZANLWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 06:22:33 -0500
Date: Wed, 14 Jan 2009 12:21:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Message-ID: <20090114112158.GA8625@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231901899.1709.18.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231901899.1709.18.camel@think.oraclecorp.com>
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


* Chris Mason <chris.mason@oracle.com> wrote:

> v10 is better that not spinning, but its in the 5-10% range.  So, I've 
> been trying to find ways to close the gap, just to understand exactly 
> where it is different.
> 
> If I take out:
> 	/*
> 	 * If there are pending waiters, join them.
> 	 */
> 	if (!list_empty(&lock->wait_list))
> 		break;
> 
> 
> v10 pops dbench 50 up to 1800MB/s.  The other tests soundly beat my 
> spinning and aren't less fair.  But clearly this isn't a good solution.

i think since we already decided that it's ok to be somewhat unfair (_all_ 
batching constructs introduce unfairness, so the question is never 'should 
we?' but 'by how much?'), we should just take this out and enjoy the speed 
...

	Ingo
