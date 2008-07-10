Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYGJJTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYGJJTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYGJJTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:19:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50716 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752774AbYGJJTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:19:30 -0400
Date: Thu, 10 Jul 2008 09:46:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Message-ID: <20080710094641.0c52eaa7@the-village.bc.nu>
In-Reply-To: <20080710065639.GA16794@digi.com>
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se>
	<20080710065639.GA16794@digi.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +       else if (!irq_on && !priv->irq_disabled)
> > +               disable_irq(dev_info->irq);
> I'm not sure if this is a problem on SMP.  Should you use
> disable_irq_nosync here, too?  Probably it's OK.

That one will also deadlock.

The easiest fix is probably to use test_and_set and friends for each I/O
operation. You would then not need the lock to protect ->irq_disabled.
Propogating that throughout means your user space has to handle the case
of an IRQ arriving after disable returns but would be a fair bit saner I
think ?
