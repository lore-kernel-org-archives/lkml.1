Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbZLMCvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbZLMCvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZLMCvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:51:53 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:55176 "HELO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752483AbZLMCvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:51:53 -0500
Date: Sat, 12 Dec 2009 14:52:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fix 2.6.33 x86 regression to kgdb hw breakpoints - due to
 perf API changes
Message-ID: <20091212135216.GA18597@elte.hu>
References: <4B227F2C.7050403@windriver.com>
 <20091212132428.GB22389@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091212132428.GB22389@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Hm, the kgdb hw-breakpoint changes freshly put into v2.6.33 look 
> pretty broken: [...]

Sorry - i thought for a moment that it was introduced by this recent 
change:

  7f8b7ed: kgdb: Always process the whole breakpoint list on activate or deactivate

but it's deeper than that indeed.

Basically we have two options:

 A- change kgdb to use the hw-breakpoints highlevel APIs (i'd prefer 
    that)

 B- or keep what we had so far: kgdb overrides existing GDB (and now 
    perf) breakpoints

I havent noticed that hw-breakpoints lock up under kgdb.

	Ingo
