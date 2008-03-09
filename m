Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYCIUvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYCIUvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYCIUvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:51:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbYCIUvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:51:46 -0400
Date: Sun, 9 Mar 2008 21:51:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
Message-ID: <20080309205132.GA9021@elte.hu>
References: <20080309200103.GA895@mailshack.com> <20080309201152.GB28454@elte.hu> <1205094704.6430.1241420859@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205094704.6430.1241420859@webmail.messagingengine.com>
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


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> > >  #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
> > > +#undef find_next_bit
> > > +#undef find_next_zero_bit
> > 
> > this bit looks weird - did you need it for testing?
> 
> Worse, it's needed to get x86_64 to compile.
> 
> They are defined in include/asm-x86/bitops_64.h (which gets included). 
> They are used to optimize the case where the bitmap size is known at 
> compile time and not larger than BITS_PER_LONG. Undeffing them here is 
> the easiest way to get things to compile, here.

ok - but this needs to be solved in a cleaner way. That build-time 
optimization needs to be pushed into generic code so that 32-bit x86 and 
other architectures can make use of it as well. The lib/find_next_bit.c 
functions should be named __find_next_bit() or so.

	Ingo
