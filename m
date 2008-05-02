Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbYEBAVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbYEBAVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbYEBAVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:21:42 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:33342 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbYEBAVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:21:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q/bC1Nvy4L+jA65PsELOnT5O69oGbsg+X/5eZmoS5J6z4hqu8cFWCKeuN6C1fKMGXZdnbjdulD8tnnfqoV5783t0ieNJ8H+frZqlteT7eHPfdQFSMp56/I9SnGXDtVhQlhyBvhTzvlAzQ2ON6VxDeRe0oN34KQWP7huoIRZY5ro=
Message-ID: <dd18b0c30805011721j2f08f746p526fe11f5aae6954@mail.gmail.com>
Date: Fri, 2 May 2008 00:21:39 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Cc: "Tom Rini" <trini@kernel.crashing.org>, torvalds@linux-foundation.org,
       bunk@kernel.org, venkatesh.pallipadi@intel.com, davem@davemloft.net,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       vegard.nossum@gmail.com
In-Reply-To: <20080501165945.077d34f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

On Thu, May 1, 2008 at 11:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 1 May 2008 16:24:47 -0700
>  Tom Rini <trini@kernel.crashing.org> wrote:
>
>  > On Thu, May 01, 2008 at 03:33:49PM -0700, Andrew Morton wrote:
>  > > On Thu, 1 May 2008 15:27:26 -0700 (PDT)
>  > > Linus Torvalds <torvalds@linux-foundation.org> wrote:
>  > >
>  > > >
>  > > >
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
>
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
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>

I hate to jump in like this, but I noticed something while compiling
madwifi as well with
gcc, I'm wondering if this is related to the above:
/home/name/Desktop/madwifi-trunk-r3574-20080426/Makefile:50
Makefile.inc: no such file or directory
even though the files exists,


Makefile.inc98: scripts/get_arch.mk: no such file or directory
Makefile.inc:102 ath_hal/ah_target.inc: no such file or directory
Makefile.inc:163 *** TARGET i386-elf is invalid, invalid target are: . Stop.
make[1] *** [modules] Error 2

After modifying the  Makefiles you're left with ***TARGET i386-elf problem

regards;

-- 
Justin P. Mattock
