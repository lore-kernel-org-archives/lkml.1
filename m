Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbYHRD6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbYHRD6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 23:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYHRD55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 23:57:57 -0400
Received: from ozlabs.org ([203.10.76.45]:57096 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYHRD54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 23:57:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Date: Mon, 18 Aug 2008 11:09:42 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu>
In-Reply-To: <20080817173319.GA2450@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181109.43203.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 03:33:19 Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > Gag me now.
> >
> > Why not just do
> >
> >  #define __BBO(c)                sizeof(const char[1 - 2*!!(c)])
> >  #define __BBONC(c)              __BBO(!__builtin_constant_p(c))
> >  #define BUILD_BUG_ON_ZERO(c)    (__BBO(c) - __BBONC(c))
> >  #define BUILD_BUG_ON(c)         (void)BUILD_BUG_ON_ZERO(c)
> >
> > and be done with it?
>
> yeah, i first tried a few variants of that (compile-time warnings are
> much better than link time warnings), but none worked when i tested
> various failure modes.

Hey, I thought I was the "undisputed ruler of Ugly-land".

How about this instead:

#define BUILD_BUG_ON(condition)						\
do {									\
	static struct { char arr[1 - 2*!!(condition)]; } x __maybe_unused;	\
} while(0)

Cheers,
Rusty.
