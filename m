Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYCKJ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYCKJ5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYCKJ4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:56:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49602 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYCKJ4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:56:51 -0400
Date: Tue, 11 Mar 2008 10:56:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] x86: Optimize find_next_(zero_)bit for small
	constant-size bitmaps
Message-ID: <20080311095631.GT25110@elte.hu>
References: <20080309200103.GA895@mailshack.com> <20080309201152.GB28454@elte.hu> <1205094704.6430.1241420859@webmail.messagingengine.com> <20080309205132.GA9021@elte.hu> <20080310231724.GA8370@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310231724.GA8370@mailshack.com>
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> x86: Optimize find_next_(zero_)bit for small constant-size bitmaps

thanks, looks nice, except for a small detail:

> +#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
> +unsigned long __find_next_bit(const unsigned long *addr,
> +		unsigned long size, unsigned long offset);
> +
> +static __always_inline unsigned long
> +find_next_bit(const unsigned long *addr, unsigned long size,
> +		unsigned long offset)

> +#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */

there should be an #else here i think, which maps find_next_bit to 
__find_next_bit / etc.

small syntactic nit:

> +unsigned long __find_next_bit(const unsigned long *addr,
> +		unsigned long size, unsigned long offset);

should be explicitly "extern", so that we see that it's a prototype 
declaration.

	Ingo
