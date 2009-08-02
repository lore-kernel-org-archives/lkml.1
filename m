Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZHBUZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZHBUZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZHBUZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:25:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55137 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbZHBUZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:25:32 -0400
Date: Sun, 2 Aug 2009 22:25:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090802202522.GK24486@elte.hu>
References: <20090729112509.GN4148@kernel.dk> <20090802.131705.81498579.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802.131705.81498579.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, 29 Jul 2009 13:25:10 +0200
> 
> > -#define NR_SYSCALLS		327
> > +#define NR_SYSCALLS		328
> 
> When you increase this value, you have to add entries to all of 
> the syscall tables.  The syscall dispatch checks against this as a 
> limit, so if you don't explicitly add an entry to all the tables, 
> it's possible to deref garbage past the end of the table and try 
> to jump to it as a syscall.
> 
> And if you somehow arrange for adding a compat syscall entry here 
> for this, and build the perf tools 32-bit, you can forego all of 
> these rediculious issues with trying to get a 64-bit BFD library.  
> If the perf tools are written portably and use types like u64 etc. 
> for holding addresses and similar things, this should not be an 
> issue.
> 
> The 32-bit sparc BFD library has full support for all the 64-bit 
> binary formats and whatnot.

That would work too. On x86 perf works all across the compatibility 
spectrum, and we do use strict u32/u64 typing and ABIs.

Note that we'll also solve (remove) the binutils-devel dependency, 
it creates a way too large set of external build constraints for 
perf. But in any case both 32-bit and 64-bit perf should work just 
fine.

	Ingo
