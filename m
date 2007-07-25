Return-Path: <linux-kernel-owner+w=401wt.eu-S934837AbXGYS1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837AbXGYS1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760832AbXGYS1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:27:34 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:25692 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758929AbXGYS1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:27:33 -0400
Message-ID: <46A7968D.3070707@ru.mvista.com>
Date: Wed, 25 Jul 2007 22:29:33 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver
 for CF	interface
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <20070725165326.5331.19920.stgit@localhost.localdomain> <46A78322.3080607@ru.mvista.com> <46A78E3F.1030904@ru.mvista.com> <20070725180145.GA29689@ld0162-tx32.am.freescale.net>
In-Reply-To: <20070725180145.GA29689@ld0162-tx32.am.freescale.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:

>>    Also, what mmio-ide in the compat properly means in the context of 
>>ide_platform which is able to handle both port and memory mapped IDE.
>>I think we must get rid with this crap, and since this IDE register
>>mapping is pretty much board specific, call it something like
>>"mpc8349emitx-ide" instead.

> What is board specific about a set of standard IDE registers at a given
> address?  Do we need to make board-specific glue code for all of the
> various ns16550-compatibles out there as well?

    I acn undertand your complaint in the context of an OF driver (which we 
don't have yet) but "mmio-ide" just means nothing to the current driver, and 
it doesn't convery enough info on the programming interface for the 
conceivable OF driver, it also does need to know at least "reg-stride" (and 
maybe "reg-size" in case only 16/32-bit accesses can be used).  Well, if such 
driver will be written, I/O mapping support will probably be dropped from it, 
so indeed, calling it mmio-ide.c would make sense.  But that can be added when 
this driver is done, and for now I'd really prefer the board name to appear in 
the "compatible" prop (to which "mmio-ide" can be appended)...

> -Scott

WBR, Sergei
