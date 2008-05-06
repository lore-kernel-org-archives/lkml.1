Return-Path: <linux-kernel-owner+w=401wt.eu-S1765172AbYEFQNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765172AbYEFQNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbYEFQNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:13:31 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:58502 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884AbYEFQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:13:28 -0400
Date: Tue, 6 May 2008 17:12:31 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
In-Reply-To: <48207A13.7010205@goop.org>
Message-ID: <Pine.LNX.4.64.0805061700390.13699@blonde.site>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
 <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site>
 <20080506150432.GA31075@elte.hu> <alpine.LFD.1.10.0805060807520.32269@woody.linux-foundation.org>
 <48207A13.7010205@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Jeremy Fitzhardinge wrote:
> Linus Torvalds wrote:
> > You should have used a pagetable-specific macro, becuse PAGE_MASK is simply
> > fundamentally WRONG, and has absolutely nothing to do with the PFN bits,
> > whether sign-extended or not!
> >
> > The fact is, the page frane number bits are *not* ~PAGE_MASK or anything
> > like that. They share only the low bits - not the high bits.
> 
> Yes.  There's already a PTE_MASK for masking out the PFN vs the flags in a
> pte, but it isn't used consistently (perhaps at all).

My patch sidesteps this issue by simply restoring most things to how
they were in 2.6.25 (using PTE_MASK in x86_64 but PAGE_MASK in x86_32).
We've contentedly used PAGE_MASK there for many many years.

Seeing the PTE_MASK discussion I did briefly consider using PTE_MASK
at the x86_32 end (it would have the nice effect of testing for lots
of badly set bits it the upper PAE half?), but I wasn't sure it has
the right type at present (there seems to be a "long" type in there
which I'd have expected to need to be long long for PAE), and it was
all even more of a maze than the last time I looked.

I decided it's safer to go back to what we had before to fix the
current warning, together with the original point which got us
into this, and leave any PTE_MASK-ification to some other patch.

I've more to say on it when commenting the patch.

Hugh
