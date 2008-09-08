Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYIHRMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYIHRMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYIHRM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:12:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42650 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYIHRM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:12:26 -0400
Message-ID: <48C55CEC.1080900@kernel.org>
Date: Mon, 08 Sep 2008 10:12:12 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org> <20080908170029.GP26079@one.firstfloor.org> <alpine.LFD.1.10.0809081000490.3117@nehalem.linux-foundation.org> <48C55C0A.7070203@zytor.com>
In-Reply-To: <48C55C0A.7070203@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Yes, it does:
> 
>   /* We need to decide which NOP sequence to use for 32bit and
>      64bit. When -mtune= is used:
> 
>      1. For PROCESSOR_I386, PROCESSOR_I486, PROCESSOR_PENTIUM and
>      PROCESSOR_GENERIC32, f32_patt will be used.
>      2. For PROCESSOR_PENTIUMPRO, PROCESSOR_PENTIUM4, PROCESSOR_NOCONA,
>      PROCESSOR_CORE, PROCESSOR_CORE2, and PROCESSOR_GENERIC64,
>      alt_long_patt will be used.
>      3. For PROCESSOR_ATHLON, PROCESSOR_K6, PROCESSOR_K8 and
>      PROCESSOR_AMDFAM10, alt_short_patt will be used.
> 
>      When -mtune= isn't used, alt_long_patt will be used if
>      cpu_arch_isa_flags has Cpu686. Otherwise, f32_patt will
>      be used.
> 
> "alt_long_patt" uses NOPL and its variants.
> 

I should point out that the code above is from binutils (gas), not from 
gcc.  It is entirely possible that doing something like
"-mtune=core2 -Wa,-mtune=generic" might actually work, but I have not 
dug through the gcc code proper to figure out if that (a) would work, 
and (b) will remain the case...

	-hpa
