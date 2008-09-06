Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbYIFVWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbYIFVWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYIFVWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:22:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYIFVWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:22:24 -0400
Date: Sat, 6 Sep 2008 14:22:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809062311540.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809061419440.3117@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <1220653095.14401.72.camel@alok-dev1>
 <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809061347120.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061351170.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062311540.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> 
> One gcc does:
> 
>     i++;
>     if (i >= QUICK_PIT_ITERATIONS)
>        goto out;
>     expect--;
> 
> The other one does:
> 
>     i++;
>     expect--;
>     if (i >= QUICK_PIT_ITERATIONS)
>        goto out;
> 
> Don't ask me which one is correct. It's just reality :(

Show me. Because I simply don't believe you.

The first code is simply _wrong_ - except if "expect" isn't even _used_ 
afterwards (in which case gcc can optimize away the last unused write).

And I strongly suspect that that is what you've seen. 

Because quite frankly, if what you describe is real, then your gcc is 
incredibly buggy. So buggy that it sounds unlikely to be able to compile 
the kernel in many other places. This is very simple and very fundamental 
C, not something subtle or even half-way undefined.

			Linus
