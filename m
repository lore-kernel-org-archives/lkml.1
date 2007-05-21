Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbXEUR6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbXEUR6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbXEUR6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:58:38 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44189 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbXEUR6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:58:38 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Organization: IBM Linux Technology Center
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] [PATCH] Ignore bogus ACPI info for offline CPUs
Date: Mon, 21 May 2007 10:58:32 -0700
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       Stable Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
References: <1179584570.12981.123.camel@chaos> <200705210947.35350.dvhltc@us.ibm.com> <20070521170815.GE3429@sequoia.sous-sol.org>
In-Reply-To: <20070521170815.GE3429@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211058.34108.dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 10:08:15 Chris Wright wrote:
> * Darren Hart (dvhltc@us.ibm.com) wrote:
> > On Saturday 19 May 2007 07:22:50 Thomas Gleixner wrote:
> > > Booting a SMP kernel with maxcpus=1 on a SMP system leads to a hard
> > > hang, because ACPI ignores the maxcpus setting and sends timer
> > > broadcast info for the offline CPUs. This results in a stuck for ever
> > > call to smp_call_function_single() on an offline CPU.
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

The system will boot w/o acpi=noirq with and without this patch if maxcpus is 
not specified.  If maxcpus is specified without the patch, the system locks 
up as Thomas described.  If maxcpus is specified with the patch, then 
acpi=noirq is required to boot - but it will boot.  This does not introduce a 
regression IMO.

--Darren

>
> thanks,
> -chris



-- 
Darren Hart
IBM Linux Technology Center
Realtime Linux Team
