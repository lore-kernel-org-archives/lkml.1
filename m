Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbYGNSmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbYGNSmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbYGNSm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:42:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757261AbYGNSmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:42:25 -0400
Date: Mon, 14 Jul 2008 11:42:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
In-Reply-To: <8763r8z570.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0807141139120.3305@woody.linux-foundation.org>
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu> <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org> <8763r8z570.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Andi Kleen wrote:
> 
> The issue is that the kernel cannot detect it (short of running the
> KVM x86 emulator on #GP, but surely you're not suggesting that), so it
> cannot print something out.

Don't be silly. It prints out the oops message.

People who cannot see where that oops is, and cannot be bothered to look 
at the register state aren't going to help _anyway_.

In fact, with the 0xdead... sequence, it's going to be *more* obvious than 
with some almost-kernel 0xffffc.. address, even if it's not showing up in 
the first line.

In other words, your whole argument is pure and utter sh*t. The page fault 
is _less_ readable than the GP fault.

> That is why I suggested using a canonical address.

And I disagree. Violently. 

The whole and ONLY point of poisoning is to get the fault.

With the canonical address, you won't get it reliably, and when you do get 
it, it's not obvious to decode.

End of discussion.

			Linus
