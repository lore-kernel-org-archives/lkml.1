Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYIHPiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYIHPiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYIHPh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:37:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYIHPh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:37:57 -0400
Message-ID: <48C54690.1060002@zytor.com>
Date: Mon, 08 Sep 2008 08:36:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908152330.GA9784@elte.hu>
In-Reply-To: <20080908152330.GA9784@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> yes. X86_P6_NOPS is a totally insignificant optimization and if it makes 
> _any_ CPU not boot (be that virtual or real), then it's frankly not 
> worth it.
> 
> David, exactly how does the kernel fail to boot with latest -git? 
> (v2.6.27-rc5-313-g64f996f or later) Does detect_nopl() run? It really 
> should, and it should detect the non-working instructions.
> 

Okay, a few things here...

1. First, I wrote up a patch yesterday to update the CONFIG_X86_GENERIC 
description and to make it "default y".  It is currently on 
x86/defconfig, but I think it should be promoted to mainline immediately.

2. X86_P6_NOPS is not the only source of static NOPLs.  If gcc is set to 
optimize for specific architectures, then gcc/binutils will generate 
static NOPLs.  The only way we can prevent that is by not using specific 
-march options, as far as I can tell.

3. I'm not positive that CONFIG_X86_GENERIC currently avoid all cases of 
(2), but it obviously should.  I will verify that today and add a 
followup patch to the Makefiles if necessary.

Given all of this, I really think that putting this on 
CONFIG_X86_GENERIC, *AND* making CONFIG_X86_GENERIC the default is the 
right choice.

	-hpa

