Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbXGaWbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbXGaWbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXGaWbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:31:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:52720 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbXGaWbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:31:23 -0400
In-Reply-To: <46A7A5E4.4090105@ru.mvista.com>
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <46A79DE0.8060405@ru.mvista.com> <46A79F14.9040409@freescale.com> <46A7A17C.8090505@ru.mvista.com> <46A7A1D5.7020003@freescale.com> <46A7A5E4.4090105@ru.mvista.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <d04530fcd6e879e0bc059049b7951aef@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver
Date: Wed, 1 Aug 2007 00:31:04 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>     This doesn't mean that shift is better anyway. If everyone 
> considers it
> better, I give up. But be warned that shift (stride) is not the only 
> property
> characterizing register accesses -- the regs might be only accessible 
> as
> 16/32-bit quantities, for example (16-bit is a real world example -- 
> from
> Amiga or smth of that sort, IIRC).

More importantly, "reg-shift" doesn't say what part of
the bigger words to access.  A common example is byte-wide
registers on a 32-bit-only bus; it's about 50%-50% between
connecting the registers to the low byte vs. connecting it
to the byte with the lowest address.

The only realistic way to handle all this is to put some
knowledge into the device driver.  This does of course
also mean that no "reg-shift" property is needed; the
device driver can look at your "compatible" property,
instead.

>>>    Why the heck should we care about the UART code taling about IDE?!
>
>> Consistency?
>
>     We're not obliged to be consistent with every piece of the kernel 
> code.

It would be nice to not name similar properties in the
device tree dissimilarly.  Kernel code doesn't come into
the picture here.


Segher

