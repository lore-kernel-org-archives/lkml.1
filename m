Return-Path: <linux-kernel-owner+w=401wt.eu-S1031022AbXDJQUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031022AbXDJQUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031018AbXDJQUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:20:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38955 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031022AbXDJQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:19:51 -0400
Date: Tue, 10 Apr 2007 17:22:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: irqpoll enhancement to show what is misrouted
Message-ID: <20070410172253.0c6b437a@the-village.bc.nu>
In-Reply-To: <461BAEFB.2020809@redhat.com>
References: <461BAEFB.2020809@redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 11:36:27 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> Can irqpoll be enhanced to show which interrupts are being misrouted?
> It looks like it should be possible to show the actual interrupt,
> the driver that is handling it, and what interrupt it's expecting
> in a /proc file -- just what happened last time irqpoll resolved
> the interrupt would be better than nothing.

You can take a guess at this, and Ingo did propose that it ought to be
possible to dynamically deduce all the IRQ routing this way. There are
problems however.

- It is possible a given IRQ simply vanished. In this scenario we pick up
the fact work needed doing from the timer tick
- We will get a lot of false positives as we scan.

You could certainly collate statistical data and build counts of which
stuck IRQ caused which IRQ events to be handled and which IRQ they are
supposedly bound to.

You can also do similar things to count work done on a timer tick, which
may help.

It won't be perfect data - and with the timer stuff may be horribly
inadequate, but it should give you a good guess.
