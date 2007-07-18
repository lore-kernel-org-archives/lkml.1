Return-Path: <linux-kernel-owner+w=401wt.eu-S934181AbXGRVk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbXGRVk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbXGRVkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:40:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49080 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757096AbXGRVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:40:14 -0400
Date: Wed, 18 Jul 2007 22:46:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dor Laor" <dor.laor@qumranet.com>
Cc: "Avi Kivity" <avik@qumranet.com>, <kvm-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC] Deferred interrupt handling.
Message-ID: <20070718224649.3e49a978@the-village.bc.nu>
In-Reply-To: <64F9B87B6B770947A9F8391472E032160CC16F3C@ehost011-8.exch011.intermedia.net>
References: <005901c7c921$79c006c0$6d401440$@com>
	<20070718123040.615795b7@the-village.bc.nu>
	<64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net>
	<20070718174736.0baf6d0e@the-village.bc.nu>
	<469E43D5.70802@qumranet.com>
	<64F9B87B6B770947A9F8391472E032160CC16D06@ehost011-8.exch011.intermedia.net>
	<20070718183358.0a0886aa@the-village.bc.nu>
	<64F9B87B6B770947A9F8391472E032160CC16F3C@ehost011-8.exch011.intermedia.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - Make the device the last irqaction in the list
> - Our dummy handler will always return IRQ_HANDLED in case any other
> previous
>   irqaction did not return such. It will also issue the timer and mask
> the irq in this case.

Ok

>   btw, if I'm not mistaken only after bad 99900/100000 the irq is
> disabled.

(and with GIT providing that they occurred in a short time period)

> - If the timer pops before the guest acks the irq, the timer handler
> will
>   ack the irq and unmask it. The timer's job is only to prevent
> deadlocks.

Ok I see what you are doing. It's either inspired or insane and I am not
quite sure which of the two. I agree it should work although may cause
performance crunches now and then and will also need care getting the
locking right.

Alan
