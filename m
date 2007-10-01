Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbXJAWyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbXJAWyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbXJAWyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:54:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59131 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbXJAWyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:54:01 -0400
Date: Mon, 1 Oct 2007 15:52:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, David Bahi <dbahi@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Message-ID: <20071001155202.56c348c8@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.0.9999.0710020043450.20478@localhost.localdomain>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com>
	<200710012341.53169.ak@suse.de>
	<alpine.LFD.0.9999.0710012349160.20478@localhost.localdomain>
	<200710020007.09864.ak@suse.de>
	<alpine.LFD.0.9999.0710020043450.20478@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 00:47:12 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 2 Oct 2007, Andi Kleen wrote:
> > 
> > > OTOH, the accounting hook would allow us to remove the IRQ#0 ->
> > > CPU#0 restriction. Not sure whether it's worth the trouble.
> > 
> > Some SIS chipsets hang the machine when you migrate irq 0 to another
> > CPU. It's better to keep that Also I wouldn't be surprised if there
> > are some other assumptions about this elsewhere.
> > 
> > Ok in theory it could be done only on SIS, but that probably would
> > really not be worth the trouble
> 
> Agreed.
> 
> I just got a x8664-hrt report, where I found the following oddity:
> 
>  0:       1197     172881   IO-APIC-edge      timer
> 
> That's one of those infamous AMD C1E boxen. Strange, all my systems
> have IRQ#0 on CPU#0 and nowhere else. Any idea ?

2 things;
the current irq balancers don't balance the timer interrupt, in fact
they'll leave it alone (so the chipset might balance)
older ones pin it to cpu 0 or rotate it....
