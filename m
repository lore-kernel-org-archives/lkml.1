Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbYJYXLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbYJYXLZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYJYXJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:09:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046AbYJYXJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:09:13 -0400
Date: Sat, 25 Oct 2008 16:08:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       walt <w41ter@gmail.com>
Subject: Re: [PULL] module, param and stop_machine patches
In-Reply-To: <alpine.LFD.2.00.0810251554030.3327@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810251603310.3327@nehalem.linux-foundation.org>
References: <200810221005.59874.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251416130.3327@nehalem.linux-foundation.org> <200810260924.09479.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251529240.3327@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0810251554030.3327@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 25 Oct 2008, Linus Torvalds wrote:
>
> -early_initcall(stop_machine_init);
> +core_initcall(stop_machine_init);

Btw, this obviously implies that all stop_machine() users had better be 
later in the boot sequence.

And no, I didn't check that exhaustively. There's the tracing 
infrastructure, and it's also core_initcall(), but it should be linked 
later. And module loading will happen later. mm/page_alloc.c has special 
code for bootup, and intel-rng.c should be a normal driver.

So it _should_ be ok. But I really didn't test. And my default kernel 
config doesn't even have CONFIG_STOP_MACHINE enabled, so I'm not the best 
person to test. 

		Linus
