Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYILWGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYILWGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYILWF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:05:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbYILWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:05:56 -0400
Date: Fri, 12 Sep 2008 15:04:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Sanders <linux@sandersweb.net>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nops in virtual pc x86
In-Reply-To: <200809121711.48558.linux@sandersweb.net>
Message-ID: <alpine.LFD.1.10.0809121501390.3337@nehalem.linux-foundation.org>
References: <200809121711.48558.linux@sandersweb.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Sep 2008, David Sanders wrote:
>
> Well, I thought we determined that multibyte nops were causing virtual pc to 
> die and removing them made it work fine.  Then why do I see this
> $ cat /proc/cpuinfo | grep nopl
> 
> flags           : fpu vme pse tsc msr pae cx8 sep pge cmov acpi mmx fxsr sse 
> sse2 constant_tsc up nopl lahf_lm
>              
> It seems the detection code in common.c is saying nops are supported.  Huh?

Because the _native_ CPU handles them quite well.

> SO I ran this code:

.. in user space.

The thing is, afaik, Virtual PC will happily let the CPU execute all the 
user-space instructions, and thus they all work as well as if they were 
running on real hardware - since they _do_ run on real hardware.

But it is probably the case that Virtual PC will then do some "security 
checking" of any system code, possibly by JIT'ing it or just interpreting 
it, since it can't let the kernel run natively with privileges. That's 
what VMware does too, since older CPU's don't have virtualization support 
for ring0 programs.

And _that_ is presumably buggy, and never learnt about the "new" 
instructions in the PPro.

		Linus
