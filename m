Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXKGPSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXKGPSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbXKGPSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:18:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48536 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbXKGPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:18:33 -0500
Date: Wed, 7 Nov 2007 15:18:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 1/2] libata: Support PIO polling-only hosts.
Message-ID: <20071107151837.3cbe3a67@the-village.bc.nu>
In-Reply-To: <20071107132702.GA27488@linux-sh.org>
References: <20071107081052.GA25913@linux-sh.org>
	<20071107130940.16b5ea86@the-village.bc.nu>
	<20071107132702.GA27488@linux-sh.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Zero is "no IRQ", please use that for polling not "< 0"
> > 
> However, platform_get_irq() will happily return IRQ#0, and it's a valid
> vector on plenty of machines. NO_IRQ is also < 0 on at least FR-V, ARM,
> blackin, PA-RISC, some PowerPC, and even IDE.

No it is not. The platform IRQ code is responsible for ensuring that 0 is
not a real IRQ and doing any neccessary remapping.

Large parts of the kernel assume that
	-	IRQ 0 is "no IRQ assigned" (serial, pci, ide etc )
	-	IRQ is *unsigned*

> We do have some devices that are physically on IRQ#0 that otherwise work
> fine, they aren't ATA devices mind you, but to claim that IRQ#0 isn't a
> valid vector is not in line with what hardware actually does, whether
> it's a good idea or not. In our case the IRQ vector maps to an exception
> offset, which we bump down to zero. We could force an off-by-1 there so
> that the math that indexes IRQ#0 is bumped up one, but that entails
> fixing up every one of our IRQ numbers for no obvious gain.
> 
> I don't really see any value in purposely crippling the range of
> allowable vectors for these machines. Though I don't mind switching to a
> NO_IRQ comparison instead of the < 0 case, so both can be handled.

NO_IRQ is an obsolete old-IDE hack.

http://www.uwsg.indiana.edu/hypermail/linux/kernel/0511.2/2197.html

http://www.uwsg.indiana.edu/hypermail/linux/kernel/0511.2/1789.html

Alan
