Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbYB0APd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbYB0APd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbYB0APZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:15:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50709 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754823AbYB0APY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:15:24 -0500
Date: Wed, 27 Feb 2008 00:02:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?UTF-8?B?QmrDtnJu?= Steinbrink <B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
Message-ID: <20080227000222.158f9220@core>
In-Reply-To: <47C499CF.2000605@pobox.com>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de>
	<20080225195924.GA23176@atjola.homenet>
	<47C32043.6090809@pobox.com>
	<20080225124054.9b69e9f0.akpm@linux-foundation.org>
	<alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de>
	<47C34CEA.7060307@pobox.com>
	<20080226083904.GC9857@elte.hu>
	<47C43F18.6060207@pobox.com>
	<20080226101928.f6c16c66.akpm@linux-foundation.org>
	<20080226204943.GD14350@elte.hu>
	<20080226133715.d9cd32e7.akpm@linux-foundation.org>
	<47C499CF.2000605@pobox.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Aside: The "FIXME: use bounce buffer" comment above indicates the more 
> optimal PIO data xfer approach of
> 
> 	local_irq_save()
> 	kmap_atomic()
> 	memcpy into bounce buffer
> 	kunmap_atomic()
> 	local_irq_restore()
> 
> 	/* do slow PIO bitbanging data transfer */
> 	ap->ops->data_xfer(...)

Definitely - older PATA controllers are unbuffered. A PIO_0 transfer is
running at ISA speed with IRQs off. Guaranteed to give Ingo's RT a blip.

Alan
