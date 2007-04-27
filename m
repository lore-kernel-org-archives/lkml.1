Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbXD0XdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbXD0XdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXD0XdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:33:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757901AbXD0XdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:33:12 -0400
Date: Fri, 27 Apr 2007 16:32:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ananth@in.ibm.com
Cc: Adrian Bunk <bunk@stusta.de>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] include/linux/kprobes.h: always offer
 show_registers() prototype
Message-Id: <20070427163251.209fa828.akpm@linux-foundation.org>
In-Reply-To: <20070427051056.GB9787@in.ibm.com>
References: <20070426234749.GJ3468@stusta.de>
	<20070427051056.GB9787@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 10:40:57 +0530
Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> On Fri, Apr 27, 2007 at 01:47:49AM +0200, Adrian Bunk wrote:
> > Allow gcc to perform show_registers() type checking also with 
> > CONFIG_KPROBES=n.
> 
> Is kprobes.h the correct place to allow for this change? Perhaps, with
> Christoph's patch http://marc.info/?l=linux-kernel&m=117432009501114&w=2
> consolidating the die_notifier code, this could be moved to
> include/linux/kdebug.h instead?
> 

Yes, I think something is definitely wrong here.  If the code is presently
calling show_registers() with no prototype in scope, it should be emitting
warnings?

Also, yes, kprobes.h is an inappropriate place for this declaration.  It
should be in include/asm-foo/, I guess.

But if we do that, there's an excellent chance of a compile explosion,
because we also have implementations of show_registers() in
drivers/net/wireless/ipw2100.c, drivers/usb/gadget/net2280.c,
drivers/usb/host/ehci-dbg.c, drivers/usb/host/ohci-dbg.c and who knows
where else.

So what I'd suggest is that we rename show_registers() to something saner,
then put the declaration into some arch header file then include that
header in kprobes.

