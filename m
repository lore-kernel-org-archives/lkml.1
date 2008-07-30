Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbYG3LK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbYG3LK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYG3LKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:10:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYG3LKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:10:19 -0400
Date: Wed, 30 Jul 2008 13:10:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86: 2.6.27-rc1 does not build with gcc-3.2.3 any more
Message-ID: <20080730111003.GA23933@elte.hu>
References: <200807301102.m6UB2AiI022512@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807301102.m6UB2AiI022512@harpo.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> static inline __attribute__((always_inline))
> unsigned char readb(const volatile void *addr)
> {
> 	unsigned char ret;
> 	asm volatile("mov" "b" " %1,%0"
> 		     : "=" "q" (ret)
> 		     : "m" (*(volatile unsigned char *)addr)
> 		     : "memory");
> 	return ret;
> }
> 
> The problem is that "=q" has been broken up into two adjacent
> string literals, and apparently gcc-3.2.3 hasn't done string
> literal concatenation at the time it processes the asm().
> Hence the syntax error. (This is clearly a gcc bug.)
> 
> Switching to gcc-3.3.6 or newer fixes the problem.
> 
> The question is, should the kernel be fixed to compile with 3.2.3
> again (by generating "=q" not "=" "q"), or should the minimum supported
> gcc version be bumped to 3.3.6?
> 
> I have no strong feeling about this, except that I want to use the
> oldest (== least bloated) gcc possible on my 486 test box.

yeah, please send a fix. We could move the '=' from build_mmio_read into 
the argument (explicitly).

	Ingo
