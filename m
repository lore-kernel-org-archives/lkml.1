Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbYKFG7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbYKFG7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYKFG7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:59:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43640 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYKFG7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:59:37 -0500
Date: Thu, 6 Nov 2008 07:59:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ken Chen <kenchen@google.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch] sched: fix single-depth wchan output
Message-ID: <20081106065925.GE15731@elte.hu>
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com> <20081106061125.GA6384@elte.hu> <b040c32a0811052216i4594a094gdcee3ae280cddec7@mail.gmail.com> <20081106063012.GA15731@elte.hu> <b040c32a0811052242q767302cbx2667a68a8e058b6e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0811052242q767302cbx2667a68a8e058b6e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ken Chen <kenchen@google.com> wrote:

> On Wed, Nov 5, 2008 at 10:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > are you interested in adding /proc/<PID>/stacktrace? If yes then we
> > could remove fp generation for 64-bit right now and add your
> > stacktrace patch when you are done with it.
> 
> Yes, we had a patch internally at google to dump task stack trace 
> via procfs just like what you suggested.  I will get that patch out.

very nice!

If it does stack walking manually then please update it to use 
save_stack_trace() instead - that is the standard API that will 
utilize the best possible stack walking machinery on the architecture 
level.

For security reasons we want it to be admin-only readable, and we also 
want a .config for it for the extra paranoid and for CONFIG_EMBEDDED.

	Ingo
