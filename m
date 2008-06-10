Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbYFJKGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbYFJKGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYFJKGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:06:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35584 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYFJKGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:06:39 -0400
Date: Tue, 10 Jun 2008 12:06:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Zero based percpu: Infrastructure to rebase the
	per cpu area to zero
Message-ID: <20080610100610.GK27706@elte.hu>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.084427000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604003019.084427000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

>     * Support an option
> 
> 	CONFIG_HAVE_ZERO_BASED_PER_CPU
> 
>       to make offsets for per cpu variables to start at zero.
> 
>       If a percpu area starts at zero then:
> 
> 	-  We do not need RELOC_HIDE anymore
> 
> 	-  Provides for the future capability of architectures providing
> 	   a per cpu allocator that returns offsets instead of pointers.
> 	   The offsets would be independent of the processor so that
> 	   address calculations can be done in a processor independent way.
> 	   Per cpu instructions can then add the processor specific offset
> 	   at the last minute possibly in an atomic instruction.
> 
>       The data the linker provides is different for zero based percpu segments:
> 
> 	__per_cpu_load	-> The address at which the percpu area was loaded
> 	__per_cpu_size	-> The length of the per cpu area
> 
>     * Removes the &__per_cpu_x in lockdep. The __per_cpu_x are already
>       pointers. There is no need to take the address.
> 
>     * Updates kernel/module.c to be able to deal with a percpu area that
>       is loaded at __per_cpu_load but is accessed at __per_cpu_start.
> 
> Based on linux-2.6.tip

applied to tip/core/percpu, thanks.

	Ingo
