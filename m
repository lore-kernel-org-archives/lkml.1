Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYIHSS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYIHSS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYIHSSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:18:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbYIHSSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:18:16 -0400
Date: Mon, 8 Sep 2008 11:17:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809081108250.3117@nehalem.linux-foundation.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2008, Linus Torvalds wrote:
> 
>  - X86_GENERIC means _other_ things too, like doing a 128-bit cacheline 
>    just so that it won't suck horribly on P4's even if it's otherwise 
>    tuned for a good microarchitecture.

Hmm. The only other thing seems to be X86_INTEL_USERCOPY. Which doesn't 
seem to be something we want to force either.

And I have to say, that whole X86_GENERIC -> L1_CACHE_BYTES=128 -> 
cache_line_size() -> SLAB/SLUB/SLOB alignment worries me too. Looking at 
that, I really don't feel like I want to force 128-byte alignment on 
everybody, just because the P4 was a pig in cacheline size.

So NOPL really stands out as being different from the other things that 
X86_GENERIC does.

			Linus
