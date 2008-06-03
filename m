Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYFCSzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYFCSzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYFCSzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:55:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36269 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbYFCSzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:55:43 -0400
Date: Tue, 3 Jun 2008 12:55:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
Message-ID: <20080603185541.GB3549@parisc-linux.org>
References: <1211852026.3286.36.camel@pasglop> <alpine.LFD.1.10.0805271451100.2958@woody.linux-foundation.org> <20080602072403.GA20222@flint.arm.linux.org.uk> <200806031416.18195.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0806030746190.3473@woody.linux-foundation.org> <Pine.LNX.4.64.0806031130130.3242@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806031130130.3242@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 11:47:00AM -0700, Trent Piepho wrote:
> On Tue, 3 Jun 2008, Linus Torvalds wrote:
> >On Tue, 3 Jun 2008, Nick Piggin wrote:
> >>
> >>Linus: on x86, memory operations to wc and wc+ memory are not ordered
> >>with one another, or operations to other memory types (ie. load/load
> >>and store/store reordering is allowed). Also, as you know, store/load
> >>reordering is explicitly allowed as well, which covers all memory
> >>types. So perhaps it is not quite true to say readl/writel is strongly
> >>ordered by default even on x86. You would have to put in some
> >>mfence instructions in them to make it so.
> 
> So on x86, these could be re-ordered?
> 
> writel(START_OPERATION, CONTROL_REGISTER);
> status = readl(STATUS_REGISTER);

You wouldn't ask for write-combining memory mapping for control or
status registers.

> >Well, you have to ask for WC/WC+ anyway, so it's immaterial. A driver that
> >does that needs to be aware of it. IOW, it's a non-issue, imnsho.
> 
> You need to ask for coherent DMA memory too.

Different case.  Coherent DMA memory is *host* memory that the *device*
accesses.  We're talking about *device* memory that the *cpu* accesses.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
