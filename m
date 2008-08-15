Return-Path: <linux-kernel-owner+w=401wt.eu-S1760559AbYHOPzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbYHOPzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYHOPzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:55:35 -0400
Received: from mail2.shareable.org ([80.68.89.115]:39171 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbYHOPze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:55:34 -0400
Date: Fri, 15 Aug 2008 16:54:57 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       briangrant@google.com, cgd@google.com, mbligh@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit 64b context switch optimization?
Message-ID: <20080815155457.GA5210@shareable.org>
References: <20080813104445.GA24632@elte.hu> <20080813063533.444c650d@infradead.org> <48A2EE07.3040003@redhat.com> <20080813142529.GB21129@elte.hu> <48A2F157.7000303@redhat.com> <20080813151007.GA8780@elte.hu> <48A2FC17.9070302@redhat.com> <20080813154043.GA11886@elte.hu> <48A303EE.8070002@redhat.com> <20080813160218.GB18037@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813160218.GB18037@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> As unimplemented flags just get ignored by the kernel, if this flag goes 
> into v2.6.27 as-is and is ignored by the kernel (i.e. we just use a 
> plain old 64-bit [47-bit] allocation), then you could do the glibc 
> change straight away, correct? So then if people complain we can fix it 
> in the kernel purely.
> 
> how about this then?

> +#define MAP_64BIT_STACK 0x20000         /* give out 32bit addresses on old CPUs */

I think the flag makes sense but it's name is confusing - 64BIT for a
flag which means "maybe request 32-bit stack"!  Suggest:

+#define MAP_STACK       0x20000         /* 31bit or 64bit address for stack, */
+                                        /* whichever is faster on this CPU */

Also, is this _only_ useful for thread stacks, or are there other
memory allocations where 31-bitness affects execution speed on old P4s?

-- Jamie
