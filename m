Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYIHQIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYIHQIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYIHQIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:08:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbYIHQIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:08:10 -0400
Date: Mon, 8 Sep 2008 09:07:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <48C54839.8050304@zytor.com>
Message-ID: <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org>
 <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2008, H. Peter Anvin wrote:
> 
> The help text is indeed out of date.  I did a patch yesterday to, among other
> things, update it; I also want to verify that we are disabling all options
> that can cause gcc or binutils to generate nopl's; I plan to push it today.

Peter.

The help text may be out of date because of changes to NOPL usage, but you 
should ask yourself whether the change is actually a _good_ change.

IOW, I really don't see why you are pushing changing the help-text, 
instead of just making the kernel work better.

The fact that some broken gcc/binutils versions may screw us over _anyway_ 
may well mean that we should just push back on _that_ change instead.

Quite frankly, from a user perspective, even a very _technical_ one, 
please tell me what the advantage of not being fairly generic by default 
is. Really.

Yes, there are some _big_ ISA issues where it is worth doing real static 
code selection (as opposed to just instruction selection and scheduling 
etc that still _works_ for everybody, but optimizes for certain 
archtiectures).

So things like cmpxchg/xadd (for atomics) and cmov (for compiler-generated 
code), and bswap (for networking) can really make a big difference, and 
are not really realistic to do dynamically. 

But NOPL? That's simply not _worth_ it being painful over.

And the fact is, the current help text describes

 (a) the historical meaning (optimize for a specific architecture, but 
     don't make extreme choices that are bad for others)
 (b) what people would generally _want_.

and I really don't think that changing the help text is the right solution 
here. It may be "technically correct", but it is simply not user-friendly 
or smart.

			Linus
