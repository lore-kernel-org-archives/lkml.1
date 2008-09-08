Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYIHPKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYIHPKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYIHPKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:10:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbYIHPKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:10:34 -0400
Date: Mon, 8 Sep 2008 08:09:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux@sandersweb.net, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <48C4A46B.90705@zytor.com>
Message-ID: <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Sep 2008, H. Peter Anvin wrote:
> 
> Under that logic we shouldn't even have CPU configurables, since you want it
> to "just work" whatever crap you're running on.  That is EXACTLY what
> CONFIG_X86_GENERIC means

I dunno.. Event he help-text doesn't actually agree with that:

  config X86_GENERIC
        bool "Generic x86 support"
        depends on X86_32
        help
          Instead of just including optimizations for the selected
          x86 variant (e.g. PII, Crusoe or Athlon), include some more
          generic optimizations as well. This will make the kernel
          perform better on x86 CPUs other than that selected.
          
          This is really intended for distributors who need more
          generic optimizations.

Also, quite frankly, while the CPU processor type message says

          The kernel will not necessarily run on earlier architectures than
          the one you have chosen, e.g. a Pentium optimized kernel will run on
          a PPro, but not necessarily on a i486.

I thought you agreed that CPU virtualization can be a problem? That was 
the whole excuse for why the dynamic code was changed. Why would it not be 
true for the static code?

The fact is, if you want to run on a Core2 or other modern CPU, then 
"Virtual PC" is apparently buggy in this respect. You worked around it for 
the dynamic choice - but that's totally _pointless_ if you then don't want 
to work around it for the static one.

			Linus
