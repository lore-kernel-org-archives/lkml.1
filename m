Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYHPVVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYHPVVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 17:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYHPVVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 17:21:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbYHPVVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 17:21:46 -0400
Date: Sat, 16 Aug 2008 14:21:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>, akpm@linuxfoundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave,
 write_trylock_irqsave
In-Reply-To: <20080816204855.GA5151@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.1.10.0808161417400.3324@nehalem.linux-foundation.org>
References: <20080816095951.GA19926@martell.zuzino.mipt.ru> <48A6D694.4070302@gmail.com> <20080816204855.GA5151@martell.zuzino.mipt.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 Aug 2008, Alexey Dobriyan wrote:

> On Sat, Aug 16, 2008 at 03:31:00PM +0200, Jiri Slaby wrote:
> >
> > Doesn't this break on sparc -- is it tested there?
> 
> What's so special about sparc?

Sparc _used_ to save/restore the whole processor flags word with the irq 
flags. That includes, iirc, things like the register window crap, so if 
you did a save/restore flags in a function, it would get all that wrong 
and things would blow up.

However, I don't think sparc has actually done that for a _loong_ time 
now, due to it always being problematic.

> >> +static inline int spin_trylock_irqsave(spinlock_t *lock, unsigned long  *flags)

However, I refuse to see this crap.

Like it or not, the 'flags' argument has always been pass-by-reference, 
and not a pointer. It does that because it used to make a huge difference 
for gcc code generation and for making it easy to do as a direct inline 
asm. We're not going to change that.

		Linus
