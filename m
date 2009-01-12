Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZALLZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZALLZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZALLZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:25:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44041 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZALLZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:25:06 -0500
Date: Mon, 12 Jan 2009 12:24:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
Message-ID: <20090112112458.GA19388@elte.hu>
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz> <20090112105202.GF10405@elte.hu> <alpine.LNX.1.10.0901121211000.5377@jikos.suse.cz> <3f9a31f40901120319l4fac84e4me193fb314bdbbcaa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901120319l4fac84e4me193fb314bdbbcaa@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Mon, Jan 12, 2009 at 4:42 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Mon, 12 Jan 2009, Ingo Molnar wrote:
> >
> >> > with Linus' tree (ae04d14015) doesn't build for me with
> >> >
> >> > arch/x86/kernel/ldt.c: In function 'alloc_ldt':
> >> > arch/x86/kernel/ldt.c:55: error: implicit declaration of function 'paravirt_alloc_ldt'
> >> > arch/x86/kernel/ldt.c:79: error: implicit declaration of function 'paravirt_free_ldt'
> >> >
> >> > Config on http://www.jikos.cz/jikos/junk/.config
> >>
> >> hm, it builds fine here with your config. Did .28 build fine for you? The
> >> only change to this file since .28 has been Jaswinder's "423a540: x86:
> >> ldt.c fix style problems".
> >
> > Puzzled. On one system, I still get this build error even after make
> > mrpoper (I use this machine to build kernel routinely, so it certainly
> > didn't happen a few days ago).
> >
> > But I just tried on different system, and there is builds flawlessly. It's
> > gcc 4.3.1 vs 4.3.2. I will check a little bit more.
> >
> 
> I am using gcc 4.3.2
> 
> Please check 'git diff' if by mistake some thing is gone wrong or check 
> 'git log'

That wont show working tree corruption.

Safest is to move away the working tree into a backup directory and check 
out the tree again:

  cd linux
  mkdir ../linux-backup
  mv * ../linux-backup

  git checkout HEAD .

then, if this solves the build problem, do some forensics by looking at:

 diff -rNu ../linux-backup ../linux'

	Ingo
