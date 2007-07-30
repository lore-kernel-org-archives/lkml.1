Return-Path: <linux-kernel-owner+w=401wt.eu-S937745AbXG3JWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937745AbXG3JWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765937AbXG3JWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:22:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46480 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765851AbXG3JWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:22:23 -0400
Date: Mon, 30 Jul 2007 11:22:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 1/9] preempt rcu: check for underflow
Message-ID: <20070730092211.GA25640@elte.hu>
References: <20070730024534.369897977@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730024534.369897977@mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> +	/*
> +	 * If our rcu_read_lock_nesting went negative, likely
> +	 * something is wrong..
> +	 */
> +	WARN_ON(current->rcu_read_lock_nesting < 0);

have you actually caught any rcu locking problem this way? Double 
unlocks should be caught by lockdep already, at a higher level.

in any case i've added a slightly different form of this change to the 
-rt queue that will also check for counter overflows. But i'm not sure 
we want to litter the code with trivial checks like this, so i'm keeping 
it separate and if it does not trigger anything real i'll remove it.

	Ingo
