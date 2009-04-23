Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZDWGcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZDWGcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZDWGcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:32:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZDWGcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:32:22 -0400
Date: Thu, 23 Apr 2009 08:30:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was
	Re: New x86 warning
Message-ID: <20090423063053.GA9833@elte.hu>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org> <alpine.LFD.2.00.0904221354320.3101@localhost.localdomain> <20090422211501.GD13896@one.firstfloor.org> <alpine.LFD.2.00.0904221417110.3101@localhost.localdomain> <20090422220428.GE13896@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422220428.GE13896@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > > Quick test here:
> > 
> > How about you just compile the kernel with gcc-3.2 and compare 
> > the number of calls to memcpy before-and-after instead? That's 
> > the real test.
> 
> I waited over 10 minutes for the full vmlinux objdumps to finish. 
> sorry lost patience. If someone has a fast disassembler we can try 
> it. I'll leave them running over night, maybe there are exact 
> numbers tomorrow.

Uhm, the test Linus requested is very simple, it doesnt need 'full' 
objdumps, just a plain defconfig [*] - an objdump takes less than 10 
seconds here even on an old box i tried it on.

I just did this - it all took less than 5 minutes to do the whole 
test with gcc34:

  vmlinux.gcc34.vanilla:       679 calls to memcpy
  vmlinux.gcc34.gcc-memcpy:   1393 calls to memcpy

So your patch more than doubles the number of calls to out-of-line 
memcpy on older GCC. That's not really acceptable so i'm NAK-ing 
this patch.

Next time you send such patches please test with older GCCs straight 
away - it's a basic act of testing when doing a patch that 'lets GCC 
decide' anything. GCC has a very bad track record in that area.

	Ingo
