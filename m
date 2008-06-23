Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbYFWJ0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbYFWJ0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYFWJ0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:26:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42971 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754058AbYFWJ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:26:22 -0400
Date: Mon, 23 Jun 2008 10:08:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, hpa@zytor.com
Subject: Re: [patch] x86 supports NO_IRQ convention
Message-ID: <20080623100823.61213c3f@lxorguk.ukuu.org.uk>
In-Reply-To: <200806221953.18849.david-b@pacbell.net>
References: <200806221953.18849.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 19:53:18 -0700
David Brownell <david-b@pacbell.net> wrote:

> Hmm, x86 doesn't seem to support the NO_IRQ convention.  This means
> that portable code can't use it.  Which in turn means that there's
> no portable way for drivers to know whether they have been handed a
> valid IRQ number (zero usually being valid).  Double-plus ungood.

NAK. It was discussed before repeatedly as you suspected and settled by
Linus ultimately.

Zero is not a valid IRQ in the kernel mapping of things. If you have a
physical IRQ 0 remap it. That way you can write the more natural

	if (dev->irq)
		setup_for_irq(dev);
	else
		poll(dev);

type stuff.

NO_IRQ was intentionally removed from various platforms and really wants
kicking out of some others.

Alan
