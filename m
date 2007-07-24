Return-Path: <linux-kernel-owner+w=401wt.eu-S1763975AbXGXHKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763975AbXGXHKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbXGXHJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:09:50 -0400
Received: from mx10.go2.pl ([193.17.41.74]:41150 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755305AbXGXHJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:09:48 -0400
Date: Tue, 24 Jul 2007 09:18:58 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcin =?iso-8859-2?Q?=A6lusarz?= <marcin.slusarz@gmail.com>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070724071858.GA2049@ff.dom.local>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com> <20070629150759.GC2771@ff.dom.local> <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 07:44:58AM +0200, Marcin ¦lusarz wrote:
> Ok, I've bisected this problem and found that this patch broke my NIC:
> 
> 76d2160147f43f982dfe881404cfde9fd0a9da21 is first bad commit
> commit 76d2160147f43f982dfe881404cfde9fd0a9da21
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Feb 16 01:28:24 2007 -0800
> 
>    [PATCH] genirq: do not mask interrupts by default
> 
>    Never mask interrupts immediately upon request.  Disabling interrupts in
>    high-performance codepaths is rare, and on the other hand this change 
>    could
>    recover lost edges (or even other types of lost interrupts) by
> conservatively
>    only masking interrupts after they happen.  (NOTE: with this change the
>    highlevel irq-disable code still soft-disables this IRQ line - and
> if such an
>    interrupt happens then the IRQ flow handler keeps the IRQ masked.)
> 
>    Mark i8529A controllers as 'never loses an edge'.
> 
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>    Cc: Thomas Gleixner <tglx@linutronix.de>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

So, it seems nobody (except the users) cares...

BTW, maybe there should be created something like "Network Cards
Producers Made Rich on Unnecessary Changed Cards Linux Foundation"?:

On Fri, Jun 29, 2007 at 10:50:20AM +0200, Jean-Baptiste Vignaud wrote:
...
> 2) changed the 3com cards
> i replaced by two cards,
> 01:06.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 42)
> 01:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8029(AS)
> 
> reinstalled and stressed the network (small download from a laptop) and :
> 
> Jun 29 09:34:10 loki kernel: NETDEV WATCHDOG: eth0: transmit timed out
> Jun 29 09:34:51 loki last message repeated 14 times
> Jun 29 09:35:18 loki last message repeated 8 times

...Of course, no response of any "serious" developer for this as well.

BTW #2: I wonder how true is this (after above-mentioned patch):

>From include/linux/irq.h:
> /**
>  * struct irq_chip - hardware interrupt chip descriptor
...
>  * @disable:		disable the interrupt (defaults to chip->mask if NULL)

Regards,
Jarek P.
