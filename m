Return-Path: <linux-kernel-owner+w=401wt.eu-S932682AbZHZAjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbZHZAjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 20:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932155AbZHZAjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 20:39:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148AbZHZAjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 20:39:16 -0400
Date: Tue, 25 Aug 2009 17:39:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Anirban Sinha <ASinha@zeugmasystems.com>
cc: linux-kernel@vger.kernel.org
Subject: RE: [PATCH] console_print: change the function api to make it have
 printk style interface
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501EA926D@exchange.ZeugmaSystems.local>
Message-ID: <alpine.LFD.2.01.0908251730530.3218@localhost.localdomain>
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local> <alpine.LFD.2.01.0908251717230.3218@localhost.localdomain> <DDFD17CC94A9BD49A82147DDF7D545C501EA926D@exchange.ZeugmaSystems.local>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Aug 2009, Anirban Sinha wrote:
> 
> Ah! Of course you are correct! Can we simply have a macro instead of a
> full blown function instead? If that is not acceptable, I will think of
> something else to get around it.

A macro is what others are generally doing.

I'd suggest looking at "dev_printk()" as an example. Sure, it basically 
requires that the first argument be a string constant (so that the 
automatic concatenations of string constants in C does its job), so it's 
not a _generic_ solution, but it's a very powerful and simple one.

In other words, you'll likely have to change a few existing

	console_print(data);

to

	console_print("%s", data);

to make things work, but hey, not a big deal.

That said, quite frankly, I suspect an even better solution would be to 
just remove the whole 'console_print()' function entirely, and just make 
people use 'printk()' or 'dev_printk()' instead. The only real valid 
reason for that thing existing in the first place is likely the 
_assembler_ interface of doing a printout of an ASCII string (see 
arch/ia64/kernel/head.S).

The other uses of 'console_print()' seem totally pointless, really. It's a 
stupid legacy interface that shouldn't exist, I'm afraid.

		Linus
