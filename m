Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbZARACx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbZARACx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 19:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZARACo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 19:02:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbZARACo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 19:02:44 -0500
Date: Sun, 18 Jan 2009 11:01:44 +1100 (EST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Kyle McMartin <kyle@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3
 warnings
In-Reply-To: <49726C56.6080905@zytor.com>
Message-ID: <alpine.LFD.2.00.0901181045550.3006@localhost.localdomain>
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se> <20090117161817.GA10825@elte.hu> <49723912.6020108@zytor.com> <20090117204421.GA1700@bombadil.infradead.org> <alpine.LFD.2.00.0901181032350.3006@localhost.localdomain> <49726C56.6080905@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 Jan 2009, H. Peter Anvin wrote:
> 
> At least on x86, the two ops should be the same cost?

Not with the code Kyle had, which forces a memory load.

But yes, with a constant address, it at least comes close. But with a 
small explicit constant value, the compiler can often do even better. For 
example, you can generate a 64-bit -1 in many ways, while a 64-bit random 
address is much more work to generate.

Of course, I don't know how much gcc takes advantage of this. Maybe it 
always just generates a silly "movq" rather than being smarter about it 
(eg "orl $-1,reg" can do it in four bytes, I think, because you can use a 
single-byte constant).

Of course, zero is even easier to generate, so NULL is the best constant 
of all, but generally small integers are more amenable to optimization 
than generic addresses. They're also generally easier to test for.

		Linus
