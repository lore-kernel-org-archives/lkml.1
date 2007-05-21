Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbXEURZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbXEURZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbXEURZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:25:23 -0400
Received: from www.osadl.org ([213.239.205.134]:34579 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755902AbXEURZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:25:22 -0400
Subject: Re: [stable] [PATCH] Ignore bogus ACPI info for offline CPUs
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Darren Hart <dvhltc@us.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Stable Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070521170815.GE3429@sequoia.sous-sol.org>
References: <1179584570.12981.123.camel@chaos>
	 <200705210947.35350.dvhltc@us.ibm.com>
	 <20070521170815.GE3429@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Mon, 21 May 2007 19:32:08 +0200
Message-Id: <1179768728.12708.31.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 10:08 -0700, Chris Wright wrote:
> * Darren Hart (dvhltc@us.ibm.com) wrote:
> > On Saturday 19 May 2007 07:22:50 Thomas Gleixner wrote:
> > > Booting a SMP kernel with maxcpus=1 on a SMP system leads to a hard
> > > hang, because ACPI ignores the maxcpus setting and sends timer broadcast
> > > info for the offline CPUs. This results in a stuck for ever call to
> > > smp_call_function_single() on an offline CPU.
> > >
> > > Ignore the bogus information and print a kernel error to remind ACPI
> > > folks to fix it.
> > >
> > > Affects 2.6.21 / 2.6.22-rc
> > >
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > When I first booted with this patch I received the following in a loop:
> > 
> > irq 9: nobody cared (try booting with the "irqpoll" option)
> 
> What happens when booting w/out this patch?  Don't want to add known
> regression to -stable.

See commit log:

Booting a SMP kernel with maxcpus=1 on a SMP system leads to a hard
hang, because ACPI ignores the maxcpus setting and sends timer broadcast
info for the offline CPUs. This results in a stuck for ever call to
smp_call_function_single() on an offline CPU.

The irq 9 issue is a separate problem and only surfaces on some boxen,
but it's not related to this patch. It's related to maxcpus=1 as well.

	tglx


