Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYAPPb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYAPPb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYAPPbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:31:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53788 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYAPPbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:31:51 -0500
Date: Wed, 16 Jan 2008 16:31:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pete Wyckoff <pw@osc.edu>
Cc: dean gaudet <dean@arctic.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nosmp/maxcpus=0 or 1 -> TSC unstable
Message-ID: <20080116153137.GA18553@elte.hu>
References: <alpine.DEB.0.999999.0801121142370.11727@twinlark.arctic.org> <20080115225039.GA25701@osc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115225039.GA25701@osc.edu>
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


* Pete Wyckoff <pw@osc.edu> wrote:

> > pretty sure this is the culprit is that num_possible_cpus() > 1, 
> > which would mean cpu_possible_map contains the second cpu... but i'm 
> > not quite sure what the right fix is... or perhaps this is all 
> > intended.
> 
> We've seen the same problem.  We use gettimeofday() for timing of 
> network-ish operations on the order of 10-50 us.  But not having the 
> TSC makes gettimeofday() itself very slow, on the order of 30 us.

30 usecs is too much - even with pmtimer it's typically below 5 usecs. 
Could you run this on your box:

  http://people.redhat.com/mingo/time-warp-test/time-warp-test.c

and send back what it reports? (run it for a few minutes)

	Ingo
