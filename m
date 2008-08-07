Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYHGMZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYHGMZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbYHGMYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:24:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53405 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754039AbYHGMYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:24:39 -0400
Date: Thu, 7 Aug 2008 11:57:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
Message-ID: <20080807115748.7c57b952@lxorguk.ukuu.org.uk>
In-Reply-To: <86802c440808070351m6400b290jb826d10407c7de77@mail.gmail.com>
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	<m1hc9yjb7x.fsf@frodo.ebiederm.org>
	<86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
	<m1y739j2z8.fsf@frodo.ebiederm.org>
	<20080807002638.04699eac@lxorguk.ukuu.org.uk>
	<m18wv9iqn9.fsf@frodo.ebiederm.org>
	<20080807111216.6cfdbeea@lxorguk.ukuu.org.uk>
	<86802c440808070351m6400b290jb826d10407c7de77@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> #ifndef CONFIG_HAVE_SPARSE_IRQ
> #define   valid_irq(irq)          ((irq) > 0 && (irq) < nr_irqs)
> #else
> #define   valid_irq(irq)          ((irq) > 0)

For a sparse IRQ you might want to call an arch specific bit of C to do
the validating. Not sure that matters too much though as must user set
interrupts are ISA 8)

> anyway why 0 is invalid instead of -1U...?

So you can write the natural thing in C 

	if (!dev->irq)
		poll_device();

