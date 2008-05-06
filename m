Return-Path: <linux-kernel-owner+w=401wt.eu-S1763463AbYEFPP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463AbYEFPP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbYEFPPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:15:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37569 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170AbYEFPPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:15:51 -0400
Date: Tue, 6 May 2008 17:15:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Linux 2.6.26-rc1 - pgtable_32.c:178 pmd_bad
Message-ID: <20080506151529.GA6321@elte.hu>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <20080506150432.GA31075@elte.hu> <alpine.LFD.1.10.0805060807520.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805060807520.32269@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 6 May 2008, Ingo Molnar wrote:
> > 
> > hm, the main objection was about whether to turn PAGE_SIZE from 
> > unsigned into signed though - and that we didnt do.
> 
> No it wasn't.
> 
> The main objection was that you SHOULD NOT USE PAGE_SIZE_MASK AT ALL!
>
> You should have used a pagetable-specific macro, becuse PAGE_MASK is 
> simply fundamentally WRONG, and has absolutely nothing to do with the 
> PFN bits, whether sign-extended or not!
> 
> The fact is, the page frane number bits are *not* ~PAGE_MASK or 
> anything like that. They share only the low bits - not the high bits.

yeah, indeed, sorry about that. Will sort this type mixing out today.

	Ingo
