Return-Path: <linux-kernel-owner+w=401wt.eu-S1763214AbYDPM5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763214AbYDPM5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbYDPM5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:57:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYDPM5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:57:41 -0400
Date: Wed, 16 Apr 2008 14:57:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: ppc fixes for find_first_bit
Message-ID: <20080416125724.GC6304@elte.hu>
References: <1208191719.12568.1247788911@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208191719.12568.1247788911@webmail.messagingengine.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0016]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> Hello Thomas,
> 
> I see Ingo has applied three fixes to the x86-tree:
>     find_first_bit() ppc fix
>     powerpc: fix powerpc build
>     find_next_bit() fix
> 
> Could you please give some insight in what went wrong with
> ppc and powerpc?
> 
> "find_first_bit() ppc fix" disables the use of find_first_bit
> for every user of GENERIC_FIND_NEXT_BIT=y. It replaces it by a
> macro to call find_next_bit with offset=0. It should be possible
> for an arch to use GENERIC_FIND_NEXT_BIT=y and implement 
> find_first_bit by itself.
> 
> "powerpc: fix powerpc build" removes the private 'implementation'
> of asm-generic/bitops/find.h. It seems correct code to me. What
> was the problem here? If it is duplicate declarations, then
> I would suggest putting #ifndef GENERIC_FIND_NEXT_BIT around
> them.
> 
> "find_next_bit() fix" changes asm-generic/bitops/find.h to
> declare find_next_bit only if CONFIG_GENERIC_FIND_NEXT_BIT=n.
> That is indeed a good change. It would be better if this
> file disappeared completely, though.

we had trouble making ppc64 defconfig build fine with your bitops 
changes applied (Thomas might still have the build failure logs). The 
fixes are ad-hoc band-aids to get it to build. We used crosscompilers to 
build on ppc64.

	Ingo
