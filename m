Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbXCEQBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbXCEQBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933582AbXCEQBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:01:00 -0500
Received: from mail.tmr.com ([64.65.253.246]:58295 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933578AbXCEQAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:00:49 -0500
Message-ID: <45EC3F25.5060308@tmr.com>
Date: Mon, 05 Mar 2007 11:02:45 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch] disable NMI watchdog by default
References: <20070114092926.GA14465@elte.hu>
In-Reply-To: <20070114092926.GA14465@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Subject: [patch] disable NMI watchdog by default
> 
> there's a new NMI watchdog related problem: KVM crashes on certain 
> bzImages because ... we enable the NMI watchdog by default (even if the 
> user does not ask for it) , and no other OS on this planet does that so 
> KVM doesnt have emulation for that yet. So KVM injects a #GP, which 
> crashes the Linux guest:
> 
>  general protection fault: 0000 [#1]
>  PREEMPT SMP
>  Modules linked in:
>  CPU:    0
>  EIP:    0060:[<c011a8ae>]    Not tainted VLI
>  EFLAGS: 00000246   (2.6.20-rc5-rt0 #3)
>  EIP is at setup_apic_nmi_watchdog+0x26d/0x3d3
> 
> and no, i did /not/ request an nmi_watchdog on the boot command line!
> 
> Solution: turn off that darn thing! It's a debug tool, not a 'make life 
> harder' tool!!
> 
> with this patch the KVM guest boots up just fine.
> 
> And with this my laptop (Lenovo T60) also stops its sporadic hard 
> hanging (sometimes in acpi_init(), sometimes later during bootup, 
> sometimes much later during actual use) as well. It hung with both 
> nmi_watchdog=1 and nmi_watchdog=2, so it's generally the fact of NMI 
> injection that is causing problems, not the NMI watchdog variant, nor 
> any particular bootup code.
> 
> The patch is unintrusive.

I'm missing something, what limits this to systems running under kvm?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
