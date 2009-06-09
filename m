Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZFIPUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZFIPUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZFIPUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:20:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbZFIPUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:20:02 -0400
Date: Tue, 9 Jun 2009 08:18:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Nick Piggin <npiggin@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <20090609122529.GD25586@elte.hu>
Message-ID: <alpine.LFD.2.01.0906090808370.6847@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
 <20090609093918.GC16940@wotan.suse.de> <20090609111719.GA4463@elte.hu> <20090609121055.GA9158@wotan.suse.de> <20090609122529.GD25586@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Jun 2009, Ingo Molnar wrote:
> 
> In practice the pte format hurts the VM more than just highmem. (the 
> two are inseparably connected of course)

I think PAE is a separate issue (ie I think HIGHMEM4G and HIGHMEM64G are 
about different issues).

I do think we could probably drop PAE some day - very few 32-bit x86's 
have more than 4GB of memory, and the ones that did buy lots of memory 
back when it was a big deal for them have hopefully upgraded long since.

Of course, PAE also adds the NX flag etc, so there are probably other 
reasons to have it. And qutie frankly, PAE is just a small x86-specific 
detail that doesn't hurt anybody else.

So I have no reason to really dislike PAE per se - the real dislike is for 
HIGHMEM itself, and that gets enabled already for HIGHMEM4G without any 
PAE.

Of course, I'd also not ever enable it on any machine I have. PAE does add 
overhead, and the NX bit isn't _that_ important to me.

		Linus
