Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbYGNSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbYGNSeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYGNSeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:34:09 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:4114 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYGNSeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:34:08 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
From: Andi Kleen <andi@firstfloor.org>
References: <20080714144828.GA22666@elte.hu>
	<alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org>
	<20080714151247.GA27145@elte.hu>
	<alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org>
Date: Mon, 14 Jul 2008 20:33:23 +0200
In-Reply-To: <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org> (Linus Torvalds's message of "Mon, 14 Jul 2008 08:59:44 -0700 (PDT)")
Message-ID: <8763r8z570.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jul 2008 18:33:22.0809 (UTC) FILETIME=[1897B690:01C8E5E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> We dont do any instruction decoding in #GP handlers to figure out what 
>> happened, while in the pagefault case we know which address faulted, 
>> etc.
>
> Why would we care? It would be very obvious from the instruction 
> disassembly plus the register contents. No need to decode instructions.

The issue is that the kernel cannot detect it (short of running the
KVM x86 emulator on #GP, but surely you're not suggesting that), so it
cannot print something out.

You would always need someone skilled in x86 assembler code
[a lot of kernel developers actually aren't]
to look at the oops and say: ok it was a bad list poison.

Currently it is very obvious because the fault address is printed
even if you don't know any x86 assembler.

I would consider that a regression.

That is why I suggested using a canonical address.

Also BTW if a CPU ever supports more than 40 bits virtual there
will be so many kernel changes needed (5 level page tables) that 
changing the poison too is the smallest of your worries.

-Andi
