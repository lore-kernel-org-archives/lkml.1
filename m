Return-Path: <linux-kernel-owner+w=401wt.eu-S1763633AbYBTPAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763633AbYBTPAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYBTPAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:00:22 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2794 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYBTPAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:00:21 -0500
Date: Wed, 20 Feb 2008 09:57:36 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in die_nmi path
Message-ID: <20080220145736.GA3771@localhost.localdomain>
References: <20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com> <47AA3B16.7000507@zytor.com> <20080206233657.GB12393@elte.hu> <m1r6fpd2uo.fsf@ebiederm.dsl.xmission.com> <20080207121719.GA29279@hmsreliant.think-freely.org> <20080207122404.GA8195@elte.hu> <20080208161422.GA32204@hmsreliant.think-freely.org> <20080208164544.GA23772@redhat.com> <20080212210816.GA1862@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212210816.GA1862@hmsreliant.think-freely.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:08:16PM -0500, Neil Horman wrote:
> > 
> > Neil, is it possible to do some serial console debugging to find out
> > where exactly we are hanging? Beats me, what's that operation which can
> > not be executed while being in NMI handler and makes system to hang. I am
> > also curious to know if it is nested NMI case.
> > 
> > Thanks
> > Vivek
> > 
> 
> 
> Hey-
> 	Some intermediate results:
> 
> I've instrumented head.S in the kernel with the following code:
> #define SEROUT(z) \     
> mov $0x3F8,%dx;\
> movb z,%al;\
> outb %dx
> 
> 
> And peppered different ascii characters throughout the startup code from
> startup_32 to right before the jump to start_kernel.  When I panic the system
> via an:
> echo c > /proc/sysrq_trigger
> I see an appropriate sequence of characters on the serial console
> 
> When I panic the box by forcing an NMI watchdog timeout however, I see nothing.
>  The machine will either hang, or reset into the bios.  I think this is
> reasonably conclusive in its indication that we're not getting into the second
> kernel when this problem occurs.  Next I'll instrument the purgatory code in a
> simmilar way.
> 
> Regards
> Neil
> 
Hey, further update.  I instrumented purgatory, and turned on the console
options that Eric mentioned, which resulted in no output to the console, so I've
concluded that we don't get to purgatory at all.  Further instrumenting shows
that the last C level printk I can issue is right before we call
relocate_kernel.  So it appears that we hang/reset somewhere in there.  I'll
instrument down that path shortly.

Regards
Neil

