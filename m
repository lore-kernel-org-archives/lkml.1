Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbXHJFAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbXHJFAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 01:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXHJFAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 01:00:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbXHJFAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 01:00:10 -0400
From: Neil Brown <neilb@suse.de>
To: "Dan Merillat" <dan.merillat@gmail.com>
Date: Fri, 10 Aug 2007 14:59:50 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18107.61638.897455.3076@notabene.brown>
Cc: "Eric Sandeen" <sandeen@sandeen.net>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrea Arcangeli" <andrea@suse.de>, "Matt Mackall" <mpm@selenic.com>,
       "Rene Herman" <rene.herman@gmail.com>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Bodo Eggert" <7eggert@gmx.de>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: message from Dan Merillat on Friday August 10
References: <469BF104.1040703@gmail.com>
	<20070719013725.GP11115@waste.org>
	<20070719112436.GG29728@v2.random>
	<20070719124419.48c3d610@the-village.bc.nu>
	<46A9ECD5.3050801@sandeen.net>
	<20070727183807.2d7dbe7b@the-village.bc.nu>
	<a781481a0707271131j3ab89470o4dea2fe2624fca32@mail.gmail.com>
	<46B003A3.1090507@sandeen.net>
	<a56dfcf00708010111n4b862a11wf91fe9677ee46143@mail.gmail.com>
	<18096.23187.887075.943181@notabene.brown>
	<a56dfcf00708092151q2c485fb9o328db1ae9802e591@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday August 10, dan.merillat@gmail.com wrote:
> On 8/1/07, Neil Brown <neilb@suse.de> wrote:
> 
> > No, this does not use indefinite stack.
> >
> > loop will schedule each request to be handled by a kernel thread, so
> > requests to 'loop' are serialised, never stacked.
> >
> > In 2.6.22, generic_make_request detects and serialises recursive calls,
> > so unlimited recursion is not possible there either.
> 
> Is that saying "before 2.6.22, a read/write on a deeply layered device
> would use a lot of stack?"

before 2.6.22, a stack of dm and/or md devices (not loop, and not
md/raid0 or md/linear) would use more stack the more devices were
involved.  If you made a very deep stack, you could push the stack
over any limit you chose.

I won't say "a lot of stack" as I haven't measured the exact amount,
just "more stack as you add more devices".

NeilBrown
