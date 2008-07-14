Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYGNQAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYGNQAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYGNQAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:00:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753647AbYGNQAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:00:10 -0400
Date: Mon, 14 Jul 2008 08:59:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
In-Reply-To: <20080714151247.GA27145@elte.hu>
Message-ID: <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org>
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Ingo Molnar wrote:
> > 
> > Why not use something sane like 0xdead000000000000, which has the high 
> > bit set but very fundamentally isn't a valid pointer, and never will 
> > be? And which is a *lot* more visually obvious too!
> 
> initially i suggested that too - but such addresses raise a #GP instead 
> of a page fault so their decoding is a bit harder.

But raising a GP is exactly what you want: a PF is an indication that the 
address was actually half-way valid, and will not fault at all on some 
(possibly future) machine.

> We dont do any instruction decoding in #GP handlers to figure out what 
> happened, while in the pagefault case we know which address faulted, 
> etc.

Why would we care? It would be very obvious from the instruction 
disassembly plus the register contents. No need to decode instructions.

> Perhaps we could try to make #GP handlers a bit more informative - 
> although decoding instructions will make things a bit more fragile 
> inevitably.
> 
> Perhaps make it 0xffffcdead0000000 ?

I'm really not seeing the reason for not just doing it right.

			Linus
