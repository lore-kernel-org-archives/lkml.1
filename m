Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYIHPin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYIHPin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYIHPic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:38:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:15686 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbYIHPib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:38:31 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Mon, 8 Sep 2008 11:38:20 -0400
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908152330.GA9784@elte.hu>
In-Reply-To: <20080908152330.GA9784@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081138.21225.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008 11:23, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Sun, 7 Sep 2008, H. Peter Anvin wrote:
> > > Under that logic we shouldn't even have CPU configurables, since you
> > > want it to "just work" whatever crap you're running on.  That is
> > > EXACTLY what CONFIG_X86_GENERIC means
> >
> > I dunno.. Event he help-text doesn't actually agree with that:
> >
> >   config X86_GENERIC
> >         bool "Generic x86 support"
> >         depends on X86_32
> >         help
> >           Instead of just including optimizations for the selected
> >           x86 variant (e.g. PII, Crusoe or Athlon), include some more
> >           generic optimizations as well. This will make the kernel
> >           perform better on x86 CPUs other than that selected.
> >
> >           This is really intended for distributors who need more
> >           generic optimizations.
> >
> > Also, quite frankly, while the CPU processor type message says
> >
> >           The kernel will not necessarily run on earlier architectures
> > than the one you have chosen, e.g. a Pentium optimized kernel will run on
> > a PPro, but not necessarily on a i486.
> >
> > I thought you agreed that CPU virtualization can be a problem? That
> > was the whole excuse for why the dynamic code was changed. Why would
> > it not be true for the static code?
> >
> > The fact is, if you want to run on a Core2 or other modern CPU, then
> > "Virtual PC" is apparently buggy in this respect. You worked around it
> > for the dynamic choice - but that's totally _pointless_ if you then
> > don't want to work around it for the static one.
>
> yes. X86_P6_NOPS is a totally insignificant optimization and if it makes
> _any_ CPU not boot (be that virtual or real), then it's frankly not
> worth it.
>
> David, exactly how does the kernel fail to boot with latest -git?
> (v2.6.27-rc5-313-g64f996f or later) Does detect_nopl() run? It really
> should, and it should detect the non-working instructions.
>

Ingo,
With CONFIG_X86_GENERIC=y, the latest v2.6.27 in Linus's tree boots fine.  But 
if you don't select that option (and some distributions don't) it won't boot 
at all.  It just hangs (blank screen) with no error messages and nothing in 
dmesg.  I assume it is hitting one of the ASM_NOP? instructions.
David
