Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYGNQ1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYGNQ1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYGNQ0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:26:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbYGNQ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:26:52 -0400
Date: Mon, 14 Jul 2008 09:26:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
In-Reply-To: <487B7A10.9050104@qumranet.com>
Message-ID: <alpine.LFD.1.10.0807140917050.3305@woody.linux-foundation.org>
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu> <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org> <487B7A10.9050104@qumranet.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Avi Kivity wrote:
> 
> We could add a printk to the #GP handler that alerts the reader that a
> poisoned list is suspected, if we find the address pattern in one of the
> registers.

I wouldn't worry too much - it's going to be pretty visible anyway.

The only thing I _would_ worry about is the AMD prefetch bug - some AMD 
cores raise a spurious page fault for prefetch instructions, and we ignore 
it.

I _think_ that bug is a pure TLB issue and would never trigger for an 
address that doesn't do page fault handling at all because it gets caught 
in the "is the address valid" code, but it does make me go "Hmm".

See

	http://lkml.org/lkml/2003/9/10/397

from Rich Brunner. The AMD errata listing does say just page fault, and 
does talk about speculative TLB reloads, so I think we're all good.

		Linus
