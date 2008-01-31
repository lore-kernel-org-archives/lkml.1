Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbYAaKLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbYAaKLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYAaKLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:11:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219AbYAaKLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:11:22 -0500
Date: Thu, 31 Jan 2008 11:11:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: about relocs.c on x86
Message-ID: <20080131101111.GB11867@elte.hu>
References: <86802c440801310007oe8693c7q177d41a87c27ca7@mail.gmail.com> <20080131095223.GA11867@elte.hu> <1201773740.23523.17.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201773740.23523.17.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> > during the big first phase of unification we generally kept file 
> > names untouched if they were only present in one of the previous 
> > architectures. I.e. pure 32-bit and pure 64-bit files were not 
> > renamed to _32/_64.
> > 
> > Now that we've got lots of unified 32/64-bit files it might make 
> > sense to rename the 'standalone' ones into _32/_64 if they share the 
> > same directory with 32/64-bit source files - to reduce the 
> > confusion. And given that for example 
> > arch/x86/boot/compressed/misc.c is unified while 
> > arch/x86/boot/compressed/relocs.c is 32-bit only, i'd agree with 
> > your observation. Feel free to send a rename patch for such cases.
> 
> I'd argue that eliminating the _32/_64 suffixes through unification 
> and not adding any more would be better.  Renaming at this point seems 
> like the wrong side of the cost/benefit line.  When the makefiles 
> finally get unified, that would be a natural list of what is 32 
> bit-only and what is 64 bit-only, and additional suffixes wouldn't add 
> much to that.

no strong opinion from me - but i think it should be obvious to the 
developer when they are looking at a .c file that it's 32-bit only (or 
64-bit only). I.e. the default is that whatever .c file we look at is 
unified - and in that sense relocs.c breaks that general expectation.

In fact renaming it to _32.c might spur its unification: people might 
say "hm, this would be handy on 64-bit as well". We might even do that 
to directories - so that for example arch/x86/math-emu/ would become 
arch/x86/match-emu_32/.

( Hey, and maybe someone is crazy enough to try to port the math-emu 
  code to 64-bit and boot Linux up on 64-bit with all user-space FPU ops 
  emulated. It would be one of the most useless hacks of all times, and 
  that certainly has a certain kind of sick appeal to it, doesnt it? ;-))

but it's really not a big issue, we can certainly leave it alone and 
observe the situation as more stuff gets unified. I'd expect it all fall 
into place naturally.

	Ingo
