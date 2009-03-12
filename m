Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZCLMTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZCLMTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZCLMTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:19:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51607 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZCLMTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:19:36 -0400
Date: Thu, 12 Mar 2009 13:19:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] eliminate spurious pointless WARN_ON()s
Message-ID: <20090312121928.GA15972@elte.hu>
References: <49B90B31.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B90B31.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Namely during early boot, the panic() or BUG() paths may end 
> up in smp_call_function_*() with just a single online CPU. In 
> that situation the warnings generated are not only 
> meaningless, but also result in relevant output being 
> cluttered.
> 
> Therefore, defer the WARN_ON() checks until after the 
> (unaffected from the problem that is being attempted to be 
> detected here) cases have been handled.

Makes sense probably - but please send a patch against -tip as 
we've got quite many changes queued up in that area and your 
patch does not apply cleanly:

 patching file kernel/smp.c
 Hunk #1 FAILED at 222.
 Hunk #2 FAILED at 229.
 Hunk #3 FAILED at 325.
 Hunk #4 FAILED at 344.
 4 out of 4 hunks FAILED -- rejects in file kernel/smp.c

Thanks,

	Ingo
