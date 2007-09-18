Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXIRW0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXIRW0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXIRW0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:26:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753017AbXIRW0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:26:15 -0400
Date: Tue, 18 Sep 2007 15:25:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
In-Reply-To: <alpine.LFD.0.999.0709181439190.16478@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709181515230.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com> 
 <20070918113401.6a8a737f@the-village.bc.nu> 
 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com> 
 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org> 
 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com> 
 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org> 
 <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com> 
 <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org>
 <43e72e890709181402x7335d0acp306cf576fac6c070@mail.gmail.com>
 <alpine.LFD.0.999.0709181408390.16478@woody.linux-foundation.org>
 <46F04386.8010209@garzik.org>
 <alpine.LFD.0.999.0709181439190.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Linus Torvalds wrote:
> 
> I just think that proliferation of IO interfaces is a bad idea. 

Side note: just allowing readl/writel on the iomap'ed pointers obviously 
avoids that proliferation, but iomap really is architecture-specific, so 
not only will different architectures act very differently, it's not 
necessarily the case that iomap() will always have the same pointer as the 
old ioremap(), even though the routines in the *default* implementation in 
lib/iomap.c do that.

In fact, for IO port accesses, we already do some debugging to make sure 
that people don't misuse the iomap() interfaces (ie the whole "Bad IO 
access.." thing). I could well see the same thing happening for MMIO under 
some debugging option, explicitly using some high bits in a 64-bit address 
as a cookie - and that would make using regular readl/writel on the cookie 
just fail spectacularly.

That said, it does seem unlikely (ie if we added a cookie for MMIO 
pointers, we'd probably do it *both* for iomap and for ioremap(), and 
readl/writel would continue to work). So in practice the readl/writel 
probably works.

		Linus
