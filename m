Return-Path: <linux-kernel-owner+w=401wt.eu-S1762745AbYJJVIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762745AbYJJVIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbYJJVHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:07:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759559AbYJJVHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:07:52 -0400
Date: Fri, 10 Oct 2008 14:07:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #1
In-Reply-To: <48EFBE65.60505@zytor.com>
Message-ID: <alpine.LFD.2.00.0810101358480.3503@nehalem.linux-foundation.org>
References: <20081009234705.GA20540@elte.hu>  <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org>  <20081010152631.GB26231@elte.hu> <20081010155830.GA4767@elte.hu> <19f34abd0810101339x66afc6d3mb6efa1a52e186816@mail.gmail.com>
 <48EFBE65.60505@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, H. Peter Anvin wrote:
> 
> Double underscores aren't the problem per se, the problem is having changes
> _ASM_X86_ to ASM_X86__ and therefore violating the namespace.

Yeah. If I recall the namespace rules correctly, you have to have a 
underscore followed by another underscore or an upper-case letter. Those 
cannot even be used for local variables by a conforming program.

Single-underscore + lower-case letter is only reserved as an external 
identifier. I _think_. So a conforming program could still do

	int main(int argc, char **argv)
	{
		int _asm_x86_types_h = 1;
		return _asm_x86_types_h;
	}

and I _think_ it should be ok.

So a system macro definition that could mess with something (admittedly 
crazy as that) has to be either double underscores or underscore + 
uppercase, so as long as the prefix is "_ASM" (or _LINUX), we're ok.

Double underscores in the _middle_ of the identifiers are a non-issue, and 
are just ugly.

> That being said, I don't personally like the double underscores.

I agree, inside the identifier in particular they do seem pointless. At 
the beginning, they are useful for things like __i386__ or __x86, where 
you need the double underscore because 'i' is lower-case.

Or maybe I mis-remember the name space rules.

			Linus
