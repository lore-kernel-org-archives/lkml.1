Return-Path: <linux-kernel-owner+w=401wt.eu-S1765129AbYBUVB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765129AbYBUVB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762167AbYBUVBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:01:43 -0500
Received: from www.tglx.de ([62.245.132.106]:45275 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934520AbYBUVBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:01:42 -0500
Date: Thu, 21 Feb 2008 21:59:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Andi Kleen <ak@muc.de>,
       Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Roman Zippel <zippel@linux-m68k.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
In-Reply-To: <alpine.LFD.1.00.0802212129510.7583@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.00.0802212154550.7583@apollo.tec.linutronix.de>
References: <kjm4pc3d92p.fsf@pelargir.dolphinics.no>  <20080221155852.GA42442@muc.de>  <alpine.LFD.1.00.0802212039240.7583@apollo.tec.linutronix.de> <1203624160.6150.5.camel@localhost.localdomain>
 <alpine.LFD.1.00.0802212129510.7583@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Thomas Gleixner wrote:
> > That or we need to do the NOP/un-NOP part in the update_vsyscall code
> > dependent on if the current clocksource supports vread, instead of on
> > the /proc entry access.
> 
> That won't fly. We need to sychronize the CPUs when we patch the code,
> which is not possible from update_wall_time with interrupts disabled.

Also this is utterly stupid as we keep the syscall in cases where we
do not have vread anyway, so we keep the attack point open for a lot
of existing machines due to TSC wreckage and HPET unavailability.

Thanks,

	tglx
