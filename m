Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYILXFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYILXFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYILXFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:05:32 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38227 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbYILXFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:05:31 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: nops in virtual pc x86
Date: Fri, 12 Sep 2008 19:05:23 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200809121711.48558.linux@sandersweb.net> <alpine.LFD.1.10.0809121501390.3337@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809121501390.3337@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121905.23724.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008 18:04, Linus Torvalds wrote:
> On Fri, 12 Sep 2008, David Sanders wrote:
> > Well, I thought we determined that multibyte nops were causing virtual pc
> > to die and removing them made it work fine.  Then why do I see this $ cat
> > /proc/cpuinfo | grep nopl
> >
> > flags           : fpu vme pse tsc msr pae cx8 sep pge cmov acpi mmx fxsr
> > sse sse2 constant_tsc up nopl lahf_lm
> >
> > It seems the detection code in common.c is saying nops are supported. 
> > Huh?
>
> Because the _native_ CPU handles them quite well.
>
> > SO I ran this code:
>
> .. in user space.
>
> The thing is, afaik, Virtual PC will happily let the CPU execute all the
> user-space instructions, and thus they all work as well as if they were
> running on real hardware - since they _do_ run on real hardware.
>
> But it is probably the case that Virtual PC will then do some "security
> checking" of any system code, possibly by JIT'ing it or just interpreting
> it, since it can't let the kernel run natively with privileges. That's
> what VMware does too, since older CPU's don't have virtualization support
> for ring0 programs.
>
> And _that_ is presumably buggy, and never learnt about the "new"
> instructions in the PPro.
>
> 		Linus
And even stranger, the same program won't run on the host OS because of data 
execution prevention.

I reported the problem to Microsoft, they say they are aware of it and working 
on a resolution.
