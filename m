Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYFNWXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYFNWXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 18:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbYFNWXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 18:23:00 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62323 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755117AbYFNWW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 18:22:59 -0400
Date: Sat, 14 Jun 2008 23:00:03 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
In-Reply-To: <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.55.0806142249090.3771@cliff.in.clinika.pl>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
 <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2008, Linus Torvalds wrote:

> I don't believe this is a regression, at least the 8GB thing. The 
> HIGHMEM64G config option has had a
> 
> 	depends on !M386 && !M486
> 
> for quite a while now. It certainly was in 2.6.25 already.
> 
> So if you want PAE support, we do require that you ask for a kernel that 
> has cmpxchg8b support (needed for the atomic 64-bit clearing of a PAE page 
> table entry). Not to mention a CPU that supports PAE. And that is simply 
> incompatible with "I want it to work on an i486 too".
> 
> So saying "I want a kernel that uses PAE _and_ works on an i486" is simply 
> nonsensical. If we ever supported it, it was a mistake, and wouldn't have 
> actually worked on an i486 anyway.

 From what you have written it looks the dependency should actually be:

	depends on !M386 && !M486 && !M586 && !M586TSC && !M586MMX

as none of the pre-Pentium-Pro processors had the PAE feature (I am not
sure about non-Intel implementations, so the case of M586 would have to be
investigated).  It was originally planned for the Pentium, but abandoned
because of the die size required -- the details behind the story were
obviously never very well known, but it was definitely related to some
cost implications.  The feature was reportedly documented in the earlier
not-so-widely-available revisions of the Pentium manuals and later on
removed while some of the other stuff was migrated to the (in)famous
Appendix H.  This also explains the odd location of the PAE bits among the
CPUID flags and in the CR4 register, which was initially marked as
reserved.

  Maciej
