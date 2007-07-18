Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbXGRQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbXGRQl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933199AbXGRQlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:41:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60990 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933864AbXGRQlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:41:16 -0400
Date: Wed, 18 Jul 2007 17:47:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dor Laor" <dor.laor@qumranet.com>
Cc: "Or Sagi" <ors@tutis.com>, <kvm-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
Message-ID: <20070718174736.0baf6d0e@the-village.bc.nu>
In-Reply-To: <64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net>
References: <005901c7c921$79c006c0$6d401440$@com>
	<20070718123040.615795b7@the-village.bc.nu>
	<64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What if we will force the specific device to the end of the list. Once
> IRQ_NONE was returned by the other devices, we will mask the irq,
> forward the irq to the guest, issue a timer for 1msec. Motivation:
> 1msec is long enough for the guest to ack the irq + host unmask the irq

It makes no difference. The deadlock isn't fixable by timing hacks.
Consider the following sequence


	Guest0	-	blocked on I/O

	IRQ14 from your hardware
		Block IRQ14
		Sent to guest (guest is blocked)

	IRQ14 from hard disk
		Ignored (as blocked)

	Deadlock

