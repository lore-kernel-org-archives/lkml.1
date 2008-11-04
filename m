Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYKDJ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYKDJ3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 04:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYKDJ3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 04:29:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50828 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYKDJ3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 04:29:02 -0500
Date: Tue, 4 Nov 2008 10:28:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: add sanity check in partition_sched_domains()
Message-ID: <20081104092848.GM23790@elte.hu>
References: <491005C7.2080608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491005C7.2080608@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> It's wrong to make dattr_new = NULL if doms_new == NULL, it introduces
> memory leak if dattr_new != NULL. Fortunately dattr_new is always NULL
> in this case. So remove the code and add a sanity check.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied to tip/sched/core, thanks!

a small detail, i changed this:

> +		BUG_ON(dattr_new);

to WARN_ON_ONCE().

If there's a rare setup-time memory leak we dont want to crash the box 
via a BUG_ON(), as that only results in unhappy users. We want a 
WARN_ON_ONCE() so that we get nice bugreports and kerneloops.org 
coverage as well instead.

We use BUG_ON() in new code only in the rarest of circumstances: if we 
absolutely want to bring down the box right there - because there's a 
serious risk of data corruption, security breach, etc.

	Ingo
