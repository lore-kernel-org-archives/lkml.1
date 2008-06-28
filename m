Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYF1Jh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYF1Jh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 05:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYF1Jhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 05:37:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53119 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754603AbYF1Jhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 05:37:46 -0400
Date: Sat, 28 Jun 2008 10:14:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with
 preemptable hardirqs
Message-ID: <20080628101431.0b64d6c2@lxorguk.ukuu.org.uk>
In-Reply-To: <20080628005436.GA1956@polina.dev.rtsoft.ru>
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>
	<20080623235141.GB17297@elte.hu>
	<20080624000016.GA12547@polina.dev.rtsoft.ru>
	<20080625123431.GA25452@polina.dev.rtsoft.ru>
	<20080628005436.GA1956@polina.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But some hardware (namely ULi M5228 in the ULi M1575 "Super South Brige")
> behaves in a strange way: it asserts interrupts as edge sensitive. And
> because preemptable IRQ handler disables PIC's interrupt, PIC will likely
> miss it.

You mean "I've programmed the hardware wrong"

If your M5228 is in native mode it should be generating a level trigger,
providing you've programmed it in full that way. If you have it in legacy
mode then it honours IDEIRT and you want the relevant PIC/APIC input set
to level.

How to program an IDE controller out of legacy mode is a public open
standard document.

> It would be great to re-configure the ULi bridge or ULi IDE controller
> to behave sanely, but no one knows how or if this is possible at all
> (no available specifications).

You need an NDA with ULi for the documentation or I suspect you can
program the APIC or EISA level registers to match assuming its a PCI like
bridge.

> So.. to workaround the issue IDE interrupt handler should re-check for
> any pending IRQs. This isn't bulletproof solution, but it works and this
> is the best one we can do.

That really does not belong in a mainstream tree.

Alan
