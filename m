Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbXCGFku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbXCGFku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 00:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbXCGFku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 00:40:50 -0500
Received: from terminus.zytor.com ([192.83.249.54]:33205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbXCGFkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 00:40:49 -0500
Message-ID: <45EE503D.10608@zytor.com>
Date: Tue, 06 Mar 2007 21:40:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org> <200703061828.00253.dada1@cosmosbay.com> <200703061910.13431.dada1@cosmosbay.com> <45EDCD11.8070000@cosmosbay.com> <Pine.LNX.4.64.0703061944590.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703061944590.5963@woody.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 6 Mar 2007, Eric Dumazet wrote:
>> I did a user space program, attached to this mail.
>>
>> I rewrote the reciprocal_div() for i386 so that one multiply is used.
> 
> Ok, this is definitely faster on Core 2 as well, so "numbers talk, 
> bullshit walks". No more objections.
> 
> (That said, I bet you could do even better for octal and hex numbers, so 
> if you *really* want to speed things up, you should just make a 
> special-case routine for each base (there's just three of them), and you 
> can then also optimize the base-10 thing much better (you can do two 
> digits at a time by dividing by 100, etc)
> 

Of course you can do better for octal and hex -- it's just shift and mask.

Decimal is trickier; however, at least on i386 it might make sense to 
divide by 100 and then use the AAM instruction, or a table lookup, to 
split it into individual digits.

	-hpa
