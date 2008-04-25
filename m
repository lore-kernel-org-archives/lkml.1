Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbYDYPG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbYDYPG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYDYPGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:06:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbYDYPGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:06:19 -0400
Date: Fri, 25 Apr 2008 08:03:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com, rjw@sisk.pl,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
In-Reply-To: <1209343883-7991-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Apr 2008, Jiri Slaby wrote:
> 
> Thanks. Bisected mm down to git-x86.patch, bisected git-x86-latest down to
> x86: enhance DEBUG_RODATA support - alternatives
> The patch below fixes the problem for me. Comments welcome.

You're a hero, Jiri.

And that also explains why I didn't see it - I don't do modules.

Thanks a heap.

> The 0xf0 pattern comes from alternatives_smp_lock:
> text_poke(*ptr, ((unsigned char []){0xf0}), 1);

And we should really add a lot more sanity checking there.

		Linus
