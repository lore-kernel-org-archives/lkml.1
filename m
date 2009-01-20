Return-Path: <linux-kernel-owner+w=401wt.eu-S1761049AbZATMjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761049AbZATMjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZATMi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:38:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40621 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbZATMi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:38:57 -0500
Date: Tue, 20 Jan 2009 13:38:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Andi Kleen <andi@firstfloor.org>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex:
	implement adaptive spinning
Message-ID: <20090120123824.GD7790@elte.hu>
References: <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu> <20090119062212.GC22584@wotan.suse.de> <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain> <20090120005124.GD16304@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120005124.GD16304@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> > > it seems like a nice opt-in thing that can be used where the aliases 
> > > are verified and the code is particularly performance critical...
> > 
> > Yes. I think we could use it in the kernel, although I'm not sure how 
> > many cases we would ever find where we really care.
> 
> Yeah, we don't tend to do a lot of intensive data processing, so it is 
> normally the cache misses that hurt most as you noted earlier.
> 
> Some places it might be appropriate, though. It might be nice if it can 
> bring code size down too...

I checked, its size effects were miniscule [0.17%] on the x86 defconfig 
kernel and it seems to be a clear loss in total cost as there would be an 
ongoing maintenance cost of this weird new variant of C that language 
lawyers legislated out of thin air and which departs so significantly from 
time-tested C coding concepts and practices.

We'd have to work around aliasing warnings of the compiler again and again 
with no upside and in fact i'd argue that the resulting code is _less_ 
clean.

The lack of data processing complexity in the kernel is not a surprise: 
the kernel is really just a conduit/abstractor between hw and apps, and 
rarely generates genuinely new information. (In fact it can be generally 
considered a broken system call concept if such data processing _has_ to 
be conducted somewhere in the kernel.)

( Notable exceptions would be the crypto code and the RAID5 [XOR checksum]
  and RAID6 [polinomial checksums] code - but those tend to be seriously
  hand-optimized already, with the most critical bits written in assembly. )

	Ingo
