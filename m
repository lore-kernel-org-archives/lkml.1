Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYIHRPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYIHRPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYIHRPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:15:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45841 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYIHRPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:15:22 -0400
Date: Mon, 8 Sep 2008 19:18:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux@sandersweb.net, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Message-ID: <20080908171858.GQ26079@one.firstfloor.org>
References: <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org> <20080908170029.GP26079@one.firstfloor.org> <alpine.LFD.1.10.0809081000490.3117@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809081000490.3117@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Btw, I do think that the whole NOPL issue is separate from all the other 
> issues. There can be _other_ cases where it really is worth doing some 
> "generic" optimizations or being more "specific", and my argument really 
> is that NOPL is _not_ one of those cases.
> 
> So I'm still not sure that X86_GENERIC is necessarily the answer. The 

FWIW I personally think Linux should always use very conservative nops. 
Unconditionally. This issue already cost far too much developer time
and it's unlikely to be worth it.

> Peter - does gcc actually use NOPL in _32-bit_ code too? It really seems 

gcc just uses .p2align, so it comes down to binutils

Yes there seems to be a pretty scary ISA selection code in there.

Line 565 of

http://www.google.com/codesearch?hl=en&q=i386_align_code+show:pxieOi43ptA:OXGjJbna8V8:zfd_fdPYgEI&sa=N&cd=1&ct=rc&cs_p=http://gentoo.osuosl.org/distfiles/binutils-2.17.50.0.13.tar.bz2&cs_f=binutils-2.17.50.0.13/gas/config/tc-i386.c

I haven't decoded it completely, but I suspect it does the wrong thing.

-Andi
