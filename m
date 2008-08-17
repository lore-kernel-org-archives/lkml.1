Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYHQSk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYHQSk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 14:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYHQSkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 14:40:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbYHQSkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 14:40:35 -0400
Date: Sun, 17 Aug 2008 11:39:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
In-Reply-To: <20080817173319.GA2450@elte.hu>
Message-ID: <alpine.LFD.1.10.0808171129350.3324@nehalem.linux-foundation.org>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <200808162055.45136.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808161305170.3324@nehalem.linux-foundation.org> <20080817103241.GB21303@elte.hu> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org>
 <20080817173319.GA2450@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 Aug 2008, Ingo Molnar wrote:
> 
> try the patch below - it only gives this error during build:

Well, you didn't do it right:

> +#define __BBO(c)                sizeof(const char[1 - 2*!!(c)])
> +#define __BBONC(c)              __BBO(!__builtin_constant_p(c))
> +#define BUILD_BUG_ON_ZERO2(c)    (__BBO(c) - __BBONC(c))
> +#define BUILD_BUG_ON2(c)         (void)BUILD_BUG_ON_ZERO(c)

Look at the #define of BUILD_BUG_ON2 a bit more.

Hint: you're using the _wrong_ BUILD_BUG_ON_ZERO. The old one, not the v2 
one!

That said, with that fixed, there's still something wrong. It does seem 
like gcc has some very odd interaction there with __builtin_constant_p. 
Odd.

			Linus
