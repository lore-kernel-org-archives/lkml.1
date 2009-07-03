Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZGCHiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZGCHiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZGCHiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:38:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39351 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZGCHiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:38:07 -0400
Date: Fri, 3 Jul 2009 09:38:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Kilroy <kilroyd@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] check spinlock_t/rwlock_t argument type on non-SMP
	builds
Message-ID: <20090703073801.GA10191@elte.hu>
References: <1246560291-8104-1-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246560291-8104-1-git-send-email-kilroyd@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* David Kilroy <kilroyd@googlemail.com> wrote:

> When writing code for UP without CONFIG_DEBUG_SPINLOCK it's easy 
> to get the first argument to the spinlock/rwlock functions wrong. 
> This is because the parameter is not actually used in this 
> configuration.
> 
> Typically you will only find out it's wrong
>  * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
>  * after you've submitted your beautiful patch series.
> 
> The first means a long wait, and the latter is a bit late.
> 
> Add typechecking on the first argument of these macro functions. 
> Note that since the typecheck now references the variable, the 
> explicit read is redundant and can be removed.
> 
> This change causes compiler warnings in net/ipv4/route.c, as this 
> passes NULL as the first argument in the UP configuration. Simply 
> cast this.

Wondering - can the wrappers be moved from CPP land to C land by 
turning them into inlines? (i havent checked all usages so there 
might be some surprises, but by and large it ought to be possible.)

	Ingo
