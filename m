Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZCBVSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZCBVSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbZCBVSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:18:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37600 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756002AbZCBVSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:18:13 -0500
Date: Mon, 2 Mar 2009 21:17:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
Message-ID: <20090302211755.24a58ec9@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
References: <1235996477.5330.174.camel@laptop>
	<alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Organization: None.. I'm free I'm free bwhahahahaha!
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, IDE controllers that we end up using PIO on all tend to be pretty 
> old, but admittedly even the old ones are faster than the worst-case 
> timings, so in practice you're not looking quite at that kind of horror 
> case, but you're still looking at each sector transfer (256 16-bit words) 
> taking on the order of tens of us.

The worst case timings are far worse because of IORDY. 

> Now: I suspect you don't have a single machine that does PIO by default, 
> and you probably haven't had any for the last ten years. These things 
> _are_ old. But they do exist. 

I bet you do for some stuff. Most CF cards are PIO only. Several
controllers need to do PIO for some corner cases. Almost all pre-AHCI
controllers issue command blocks via PIO.

Worse still of course some controllers have an erratum where touching
some of the other registers during a transfer [which is what you need to
do to see if you are the IRQ source] corrupts the transfer. Not all
devices honour the IRQ masking bit on the device either. That makes the
generalised case of doing both unmasked transfers after an IRQ and the
errata cases of handling IRQs you can't mask and must leave disabled
rather more exciting than is nice.

Alan
