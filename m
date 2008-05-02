Return-Path: <linux-kernel-owner+w=401wt.eu-S1763535AbYEBHSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763535AbYEBHSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbYEBHSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:18:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:31516 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbYEBHSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cDuspMQoSIcwVS+N+NLLDsuU3LShHU8yGsnKwtfq0X+O69LnToInBSveCJ5CueUBNFEFPIrZ8zSC2LBhMF7f1DOGH9yX4n6d8bYtpWuuLsQ6qgK3tLTiEqXDmlgVdySdtkluUxF+hByDwP25uIS8EAkZtqPN9Z0vk1jRTigmfWk=
Message-ID: <19f34abd0805020018i11fb722fg5a4cc180ab5f2856@mail.gmail.com>
Date: Fri, 2 May 2008 09:18:10 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Cc: "Tom Rini" <trini@kernel.crashing.org>, torvalds@linux-foundation.org,
       bunk@kernel.org, venkatesh.pallipadi@intel.com, davem@davemloft.net,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
In-Reply-To: <20080501165945.077d34f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080430013108.GA18207@linux-os.sc.intel.com>
	 <20080429.212833.192304794.davem@davemloft.net>
	 <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com>
	 <20080501215633.GU29330@cs181133002.pp.htv.fi>
	 <20080501152051.4eb4bad3.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
	 <20080501153349.f4537ec7.akpm@linux-foundation.org>
	 <20080501232447.GF4354@smtp.west.cox.net>
	 <20080501165945.077d34f9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey :)

On Fri, May 2, 2008 at 1:59 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 1 May 2008 16:24:47 -0700
>  Tom Rini <trini@kernel.crashing.org> wrote:
>
>  > On Thu, May 01, 2008 at 03:33:49PM -0700, Andrew Morton wrote:
>  > > On Thu, 1 May 2008 15:27:26 -0700 (PDT)
>  > > Linus Torvalds <torvalds@linux-foundation.org> wrote:
>  > >
>  > > > On Thu, 1 May 2008, Andrew Morton wrote:
>  > > > > >
>  > > > > > I see only the following choices:
>  > > > > > - remove __weak and replace all current usages
>  > > > > > - move all __weak functions into own files, and ensure that also happens
>  > > > > >   for future usages
>  > > > > > - #error for gcc 4.1.{0,1}
>  > > > >
>  > > > > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
>  > > >
>  > > > It's __GNUC_PATCHLEVEL__, I believe.
>  > > >
>  > > > So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1}
>  > > > (bad, and rather uncommon).
>  > > >
>  > > > And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to
>  > > > begin with, I think it's better to just not support it.
>  > > >
>  > >
>  > > Drat.  There go my alpha, i386, m68k, s390, sparc and powerpc
>  > > cross-compilers.  Vagard, save me!
>  > >
>  > > Meanwhile I guess I can locally unpatch that patch.
>  >
>  > I know I'll come off as an ass, but you can't make new ones with 4.1.2?
>  > It's not like we're talking about gcc 2.95/96 fun here :)

It's true; crosstool hasn't been much of a trouble (for me anyway). A
couple of combinations that I tried failed.

>  Honestly, I nearly died when I built all those cross-compilers.  Sooooooo
>  many combinations of gcc/binutils/glibc refused to work for obscure
>  reasons.  Compilation on x86_64 just didn't work at all and I ended up
>  having to build everything on a slow i386 box, etc, etc.  The stream of
>  email to Dan got increasingly strident ;)
>
>  I think crosstool has become a lot better since then, judging from the ease
>  with which Jens was able to spin up the powerpc compiler, but the trauma
>  was a life-long thing.
>
>  Vegard has been making noises about (finally!) preparing and maintaining a
>  decent set of cross-compilers for us.  It would be a great service (begs).

Noises? Heh...

So I've only just begun that work. For i386 host we have the following targets:
alpha, arm, ia64, sparc64, sparc, x86_64

though these are largely untested with Linux Kernel. Most of them are
gcc 3.4.5 (this should in theory compile the kernel correctly), though
I found an e-mail from Ingo saying that you need the -tls versions for
stackprotector to work correctly. This might be a good time to ask if
I should be making gcc 4.1.2s instead. I need to recompile in either
case.

In other words, we are NOT fully operational yet :-)

Though H. Peter gave me a directory to stuff it in, you could try it
out if you're impatient:

http://www.kernel.org/pub/tools/crosstool/

(Hm, it seems that all my .asc files disappeared in the transition.. Oh well.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
