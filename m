Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbYIHREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbYIHREw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYIHREp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:04:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbYIHREo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:04:44 -0400
Date: Mon, 8 Sep 2008 10:04:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <20080908170029.GP26079@one.firstfloor.org>
Message-ID: <alpine.LFD.1.10.0809081000490.3117@nehalem.linux-foundation.org>
References: <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org>
 <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org> <20080908170029.GP26079@one.firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2008, Andi Kleen wrote:
>
> Originally it was an option because the 128 byte cache line it selects
> caused bloat in several important data structures. That was back
> then when cache line padded NR_CPUs arrays were still pretty common.
> I don't know if it's still a problem, but before making it default y
> it would be good to check the dynamic+static memory cost at least.

Btw, I do think that the whole NOPL issue is separate from all the other 
issues. There can be _other_ cases where it really is worth doing some 
"generic" optimizations or being more "specific", and my argument really 
is that NOPL is _not_ one of those cases.

So I'm still not sure that X86_GENERIC is necessarily the answer. The 
answer may be:

 - never use NOPL statically unless we _know_ it works (eg x86-64)

 - never allow such a stupid decision by gcc as to use NOPL on x86-32.

..and then leave X86_GENERIC alone wrt everything else.

Peter - does gcc actually use NOPL in _32-bit_ code too? It really seems 
to be a stupid decision to make a binary not run on other CPU's over 
something as trivial as that. That's something I'd expect out of an Intel 
compiler just to mess with AMD, not out of gcc.

			Linus
