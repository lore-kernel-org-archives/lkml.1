Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZKJVNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZKJVNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZKJVNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:13:15 -0500
Received: from 1wt.eu ([62.212.114.60]:50922 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZKJVNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:13:15 -0500
Date: Tue, 10 Nov 2009 22:12:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110211259.GD26633@1wt.eu>
References: <4AF9020C.90108@zytor.com> <4AF9435F.2070103@redhat.com> <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110205445.GB1407@ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 09:54:45PM +0100, Pavel Machek wrote:
> Hi!
> 
> > Indeed, but there is a difference between [cmpxchg, bswap, cmov, nopl]
> > on one side and [sse*] on the other : distros are built assuming the
> > former are always available while they are not always. And the
> > distro
> 
> Well, fix the distros... 

you know like me that it's as easy as useless to point the finger at
distros, because people running on low end want something that works
and people running on high end want something that runs fast. In order
to satisfy every one, you would have to build with optimizations for
every CPU around, which does not make sense. Simply count the number
of CPU variants in the kernel, and imagine that many CDs/DVDs for a
single platform distro.

However, targetting the most common denominator of high end machines
(basically i686) and having the lower end systems experience a tiny
slowdown is not stupid at all since performance is not what matters
the most there. The higher end systems will simply be able to run
CPU-specific optimizations per-program as they already do right now.

(...)
> > CMOV/NOPL are rarely used, thus have no reason to cause a massive
> > performance drop, but are frequent enough (at least cmov) for almost
> 
> *One* CMOV in the inner loop will make your performance go down 20x.

yes, just like with emulated FPU or trapped unaligned accesses. It's
just like flying fishes. They exist but they aren't the most common
ones. If people encounter these cases on a specific program, then
they just have to recompile it if it is a problem. At least they
don't rebuild the whole distro. And once again, I've been using
cmpxchg/bswap emulation for years on my i386 without feeling any
need for a rebuild, and CMOV emulation for years now on my mini-itx 
C3 without any problem either. These are real experiences, not just
fears of imaginary problems. Yes I can design a program to run 400
times slower on these machines if I want. I just don't feel the need
to do so and apparently existing programs' authors didn't either.

Regards,
Willy

