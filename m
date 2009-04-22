Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZDVV0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZDVV0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZDVV0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:26:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbZDVV0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:26:22 -0400
Date: Wed, 22 Apr 2009 14:19:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re:
 New x86 warning
In-Reply-To: <20090422211501.GD13896@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0904221417110.3101@localhost.localdomain>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org> <alpine.LFD.2.00.0904221354320.3101@localhost.localdomain> <20090422211501.GD13896@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Apr 2009, Andi Kleen wrote:
> 
> AFAIK it's all true on 3.2+ when it can figure out the alignment
> (but some gcc versions had problems passing the alignment around e.g.
> through inlining), under the assumption that out of line can do
> a better job with unaligned data. That's not true with my patch,
> but could be true in theory.

Maybe it was the unaligned case that I remember.

Because it's definitely not true that out-of-line code can do any better 
with unaligned data, at least not for small constants. And the case I 
remember was for some silly 8-byte case or similar.

> Quick test here:

How about you just compile the kernel with gcc-3.2 and compare the number 
of calls to memcpy before-and-after instead? That's the real test.

		Linus
