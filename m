Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYH0Nkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYH0Nkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYH0Nkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:40:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55394 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755074AbYH0Nkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:40:36 -0400
Date: Wed, 27 Aug 2008 14:21:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Parag Warudkar" <parag.lkml@gmail.com>
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
Message-ID: <20080827142142.303cdba8@lxorguk.ukuu.org.uk>
In-Reply-To: <f7848160808270552u2ee66167x912a68e0bf8b25bf@mail.gmail.com>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	<alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
	<200808261111.19205.rusty@rustcorp.com.au>
	<alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	<20080826183051.GB10925@cs181140183.pp.htv.fi>
	<alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	<20080826205916.GB11734@cs181140183.pp.htv.fi>
	<alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	<20080826232411.GC11734@cs181140183.pp.htv.fi>
	<20080827092528.780916bd@lxorguk.ukuu.org.uk>
	<f7848160808270552u2ee66167x912a68e0bf8b25bf@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> By your logic though, XFS on x86 should work fine with 4K stacks -
> many will attest that it does not and blows up due to stack issues.
> 
> I have first hand experiences of things blowing up with deep call
> chains when using 4K stacks where 8K worked just fine on same
> workload.
> 
> So there is definitely some other problem with 4K stacks.

Nothing of the sort. If it blows up with a 4K stack it will almost
certainly blow up with an 8K stack *eventually* - when a heavy stack usage
coincides with a heavy stack using IRQ handler.

You won't catch it in simple testing, you won't catch it in trivial
simulation and it'll be incredibly hard to reproduce. Not the kind of bug
you want in a production system really. IRQ stacks make things much more
predictable.

Alan
