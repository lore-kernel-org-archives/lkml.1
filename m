Return-Path: <linux-kernel-owner+w=401wt.eu-S947749AbXHMTJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947749AbXHMTJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759887AbXHMTJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:09:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:37274 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761622AbXHMTJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:09:05 -0400
Subject: Re: [patch 3/3] genirq: mark io_apic level interrupts to avoid
	resend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>
In-Reply-To: <20070813135311.GB4026@ff.dom.local>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
	 <20070812152303.177006193@inhelltoy.tec.linutronix.de>
	 <20070813112821.GA2863@ff.dom.local> <1187006835.12828.112.camel@chaos>
	 <20070813135311.GB4026@ff.dom.local>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 14:07:37 -0500
Message-Id: <1187032057.5330.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 15:53 +0200, Jarek Poplawski wrote:
> 
> I've thought e.g. about "fasteoi" for this "Virtual Wire" timer for
> i386: I hope it's OK, but since is it any problem to add some comment
> here, why it's OK with resending here (with POWERPC it's easier to
> think it's something special, but here we have to similar things in
> the same file)?

To be totally fair, there shouldn't be a problem with spurrious
re-sends, I'm not sure what problems some chipsets are having there,
though it may be related to the method used for re-sending. On ppc, we
use the soft method I think everywhere anyway.

I use re-sending on cell with fasteoi for the on-die top-level PIC
because while it does have a HW priority handling, it also doesn't have
a HW mask. Thus I just "drop" IRQs that are masked and resend (it's edge
messages).

Ben.


