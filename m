Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbXHNIBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbXHNIBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXHNIBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:01:09 -0400
Received: from mx10.go2.pl ([193.17.41.74]:33135 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752098AbXHNIBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:01:07 -0400
Date: Tue, 14 Aug 2007 10:01:52 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin\.slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [patch 3/3] genirq: mark io_apic level interrupts to avoid resend
Message-ID: <20070814080152.GB1702@ff.dom.local>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de> <20070812152303.177006193@inhelltoy.tec.linutronix.de> <20070813112821.GA2863@ff.dom.local> <1187006835.12828.112.camel@chaos> <20070813135311.GB4026@ff.dom.local> <1187032057.5330.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187032057.5330.17.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 02:07:37PM -0500, Benjamin Herrenschmidt wrote:
> On Mon, 2007-08-13 at 15:53 +0200, Jarek Poplawski wrote:
> > 
> > I've thought e.g. about "fasteoi" for this "Virtual Wire" timer for
> > i386: I hope it's OK, but since is it any problem to add some comment
> > here, why it's OK with resending here (with POWERPC it's easier to
> > think it's something special, but here we have to similar things in
> > the same file)?

Sorry! Of course, there is something about edge in a lapic_chip
declaration, so this (plus some knowledge of the subject) should be
enough, but I was a little surprised that x86_64 uses handle_edge_irq
for probably(?) the same thing.

> 
> To be totally fair, there shouldn't be a problem with spurrious
> re-sends, I'm not sure what problems some chipsets are having there,
> though it may be related to the method used for re-sending. On ppc, we
> use the soft method I think everywhere anyway.

IMHO, this method is very doubtful if the whole system isn't adapted
for this: e.g. in networking code softirqs are blocked very often, so
such resended irq could be really late.

> 
> I use re-sending on cell with fasteoi for the on-die top-level PIC
> because while it does have a HW priority handling, it also doesn't have
> a HW mask. Thus I just "drop" IRQs that are masked and resend (it's edge
> messages).

So, if I got this right, it looks a bit easier, since you can resend with
the same type as not masked ones (fasteoi-edge?!), I guess.

Regards,
Jarek P.
