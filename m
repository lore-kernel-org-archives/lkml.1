Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbZFAVMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbZFAVMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZFAVL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:11:59 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:27610 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456AbZFAVL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:11:59 -0400
X-Trace: 208380788/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.104.29/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.104.29
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQFAIbgI0pPRWgd/2dsb2JhbACBT8sOhAwF
X-IronPort-AV: E=Sophos;i="4.41,286,1241391600"; 
   d="scan'208";a="208380788"
Date: Mon, 1 Jun 2009 22:11:42 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler
 in the VM v3
In-Reply-To: <20090601140553.GA1979@localhost>
Message-ID: <Pine.LNX.4.64.0906012138170.27344@sister.anvils>
References: <200905271012.668777061@firstfloor.org>
 <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de>
 <20090528095934.GA10678@localhost> <20090528122357.GM6920@wotan.suse.de>
 <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de>
 <20090601140553.GA1979@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009, Wu Fengguang wrote:
> On Mon, Jun 01, 2009 at 07:50:46PM +0800, Nick Piggin wrote:
> > On Thu, May 28, 2009 at 09:54:28PM +0800, Wu Fengguang wrote:
> > > On Thu, May 28, 2009 at 08:23:57PM +0800, Nick Piggin wrote:
> > > >
> > > > Should all be commented and put into mm/swap_state.c (or somewhere that
> > > > Hugh prefers).
> > >
> > > But I doubt Hugh will welcome moving that bits into swap*.c ;)
> >
> > Why not? If he has to look at it anyway, he probably rather looks
> > at fewer files :)
> 
> Heh. OK if that's more convenient - not a big issue for me really.

Sorry for being so elusive, leaving you all guessing: it's kind of
you to consider me at all.  As I remarked to Andi in private mail
earlier, I'm so far behind on my promises (especially to KSM) that
I don't expect to be looking at HWPOISON for quite a while.

I don't think I'd mind about the number of files to look at.

Generally I agree with Nick, wanting the rmap-ish code to be in rmap.c
and the swap_state-ish code to be in swap_state.c and the swapfile-ish
code to be in swapfile.c etc.  (Though it's an acquired skill to work
out which is which of those two - one thing you can be sure of though,
if it's swap-related code, swap.c is strangely not the place for it.
Yikes, someone put swap_setup in there.)

But like most of us, I'm not so keen on #ifdefs: am I right to think
that if you distribute the hwpoison code around in its appropriate
source files, we'll have a nasty rash of #ifdefs all over?  We can
sometimes get away with the optimizer removing what's not needed,
but that only works in the simpler cases.

Maybe we should start out, as you have, with most of the hwpoison
code located in one file (rather like with migrate.c?); but hope
to refactor things and distribute it over time.

How seriously does the hwpoison work interfere with the assumptions
in other sourcefiles?  If it's playing tricks liable to confuse
someone reading through those other files, then it would be better
to place the hwpoison code in those files, even though #ifdefed.

There, how's that for a frustratingly equivocal answer?

Hugh
