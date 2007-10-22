Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbXJVQST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbXJVQST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbXJVQSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:18:11 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60044 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbXJVQSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:18:10 -0400
Date: Mon, 22 Oct 2007 12:18:08 -0400
To: Chris Bergeron <chris@pcburn.com>, linux-kernel@vger.kernel.org
Subject: Re: Syba 8-Port Serial Card Unidentified By Kernel
Message-ID: <20071022161808.GJ4003@csclub.uwaterloo.ca>
References: <4706AD19.4040605@pcburn.com> <20071010095432.GC30345@pazke.donpac.ru> <470E5714.4040303@pcburn.com> <20071012120826.GB23378@pazke.donpac.ru> <47150B06.3040306@pcburn.com> <20071017064219.GB1953@pazke.donpac.ru> <471689DA.4070008@pcburn.com> <20071018055755.GA9561@pazke.donpac.ru> <47179116.2070505@pcburn.com> <20071022153323.GA8123@pazke.donpac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022153323.GA8123@pazke.donpac.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 07:33:23PM +0400, Andrey Panin wrote:
> So the card probably generates screaming interrupt... that's bad.
> I found some docs for IT887x chips, according to these docs  IT887x
> have simple interrupt controller inside. Further investigation is needed.
> 
> Can you post output of lspci -xxx ?

Is it possible they put a chip on to generate a PCI interrupt on perhaps
PCIB on the slot from the serial chips directly, so that they didn't
have to turn interrupts from the serial chips into a signal that forces
the parallel port to generate an interrupt?  After all that would reduce
latency, and if you use PCIA for the parallel port, PCIB for the first
serial chip and PCIC for the second, you might get a much more efficient
design, although the driver would have to register all those IRQs.

What IRQ is each PCI device in that system using right now?  perhaps we
could figure out what irq 17 would be on that PCI slot.

--
Len Sorensen
