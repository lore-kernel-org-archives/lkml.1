Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbZFOP2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbZFOP2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758457AbZFOP2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:28:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37994 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760658AbZFOP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:28:32 -0400
Date: Mon, 15 Jun 2009 16:28:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
Message-ID: <20090615162804.4cb75b30@lxorguk.ukuu.org.uk>
In-Reply-To: <20090615152427.GF31969@one.firstfloor.org>
References: <20090615024520.786814520@intel.com>
	<4A35BD7A.9070208@linux.vnet.ibm.com>
	<20090615042753.GA20788@localhost>
	<Pine.LNX.4.64.0906151341160.25162@sister.anvils>
	<20090615140019.4e405d37@lxorguk.ukuu.org.uk>
	<20090615132934.GE31969@one.firstfloor.org>
	<20090615154832.73c89733@lxorguk.ukuu.org.uk>
	<20090615152427.GF31969@one.firstfloor.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> oops=panic already implies panic on all machine check exceptions, so they will
> be fine then (assuming this is the best strategy for availability 
> for them, which I personally find quite doubtful, but we can discuss this some 
> other time)

You can have the argument with all the people who deploy large systems.
Providing their boxes can be persuaded to panic they don't care about the
masses.

> That's because unpoisioning is quite hard -- you need some kind
> of synchronization point for all the error handling and that's
> the poisoned page and if it unposions itself then you need
> some very heavy weight synchronization to avoid handling errors
> multiple time. I looked at it, but it's quite messy.
> 
> Also it's of somewhat dubious value.

On a system running under a hypervisor or with hot swappable memory its
of rather higher value. In the hypervisor case the guest system can
acquire a new virtual page to replace the faulty one. In fact the
hypervisor case is even more complex as the guest may get migrated at
which point knowledge of "poisoned" memory is not at all connected to
information on hardware failings.

> > 
> > (You can unfail pages on x86 as well it appears by scrubbing them via DMA
> > - yes ?)
> 
> Not architectually. Also the other problem is not just unpoisoning them,
> but finding out if the page is permenantly bad or just temporarily.

Small detail you are overlooking: Hot swap mirrorable memory.

Second detail you are overlooking

	curse a lot
	suspend to disk
	remove dirt from fans, clean/replace RAM
	resume from disk

The very act of making the ECC error not take out the box creates the
environment whereby the underlying hardware error (if there was one) can
be cured.

In all these cases the fact you've got to shoot stuff because a page has
been lost becomes totally disconnected from the idea that the page is
somehow not recoverable and "contaminated" forever.

Which to me says your model is wrong.

Alan
