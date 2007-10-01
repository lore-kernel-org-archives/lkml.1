Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbXJAWrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbXJAWrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbXJAWrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:47:46 -0400
Received: from www.tglx.de ([62.245.132.106]:60457 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbXJAWrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:47:45 -0400
Date: Tue, 2 Oct 2007 00:47:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: Arjan van de Ven <arjan@infradead.org>, David Bahi <dbahi@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
In-Reply-To: <200710020007.09864.ak@suse.de>
Message-ID: <alpine.LFD.0.9999.0710020043450.20478@localhost.localdomain>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710012341.53169.ak@suse.de> <alpine.LFD.0.9999.0710012349160.20478@localhost.localdomain> <200710020007.09864.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Andi Kleen wrote:
> 
> > OTOH, the accounting hook would allow us to remove the IRQ#0 -> CPU#0
> > restriction. Not sure whether it's worth the trouble.
> 
> Some SIS chipsets hang the machine when you migrate irq 0 to another
> CPU. It's better to keep that Also I wouldn't be surprised if there are some
> other assumptions about this elsewhere.
> 
> Ok in theory it could be done only on SIS, but that probably would really
> not be worth the trouble

Agreed.

I just got a x8664-hrt report, where I found the following oddity:

 0:       1197     172881   IO-APIC-edge      timer

That's one of those infamous AMD C1E boxen. Strange, all my systems have 
IRQ#0 on CPU#0 and nowhere else. Any idea ?

	tglx

