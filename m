Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYGDI0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYGDI0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 04:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYGDI0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 04:26:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53864 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbYGDI0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 04:26:35 -0400
Date: Fri, 4 Jul 2008 09:08:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: michael@ellerman.id.au
Cc: benh@kernel.crashing.org, Matthew Wilcox <matthew@wil.cx>,
       Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: Multiple MSI
Message-ID: <20080704090803.545d52be@lxorguk.ukuu.org.uk>
In-Reply-To: <1215136324.7849.9.camel@localhost>
References: <20080703024445.GA14894@parisc-linux.org>
	<1215060119.21182.77.camel@pasglop>
	<1215067484.17950.35.camel@localhost>
	<200807031110.30072.arnd@arndb.de>
	<1215076620.19689.2.camel@pasglop>
	<20080703113128.GC14894@parisc-linux.org>
	<1215085266.19689.19.camel@pasglop>
	<1215136324.7849.9.camel@localhost>
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

> In most cases that I can see the conversion from irq number to irq_desc
> is done in the genirq code, so I don't see why you couldn't just put a
> remapping in there from irq numbers to descs that doesn't use an array. 
> But maybe I'm missing something.

There are a pile of drivers you would also need to fix up that use NR_IRQ
sized tables. There is also the performance concern. The irq->desc
conversion has to be very fast.

It would be better (IMHO) if dev->irq and irq in general was a pointer
whose number for end users was irq->num or similar.
