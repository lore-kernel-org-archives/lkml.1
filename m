Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbYJXPRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbYJXPRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYJXPQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:16:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33411 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYJXPQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:16:58 -0400
Message-ID: <4901E6FB.4070200@redhat.com>
Date: Fri, 24 Oct 2008 11:17:15 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: maxk@qualcomm.com, LinuxPPC-dev list <linuxppc-dev@ozlabs.org>,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: default IRQ affinity change in v2.6.27 (breaking several SMP
 PPC based systems)
References: <4E3CD4D5-FC1B-40BF-A776-C612B95806B8@kernel.crashing.org>
In-Reply-To: <4E3CD4D5-FC1B-40BF-A776-C612B95806B8@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> It appears the default IRQ affinity changes from being just cpu 0 to all 
> cpu's.  This breaks several PPC SMP systems in which only a single 
> processor is allowed to be selected as the destination of the IRQ.
> 
> What is the right answer in fixing this?  Should we:
> 
>     cpumask_t irq_default_affinity = 1;
> 
> instead of
> 
>     cpumask_t irq_default_affinity = CPU_MASK_ALL?

On those systems, perhaps, but not universally.  There's plenty of hardware 
where the physical topology of the machine is abstracted away from the OS, and 
you need to leave the mask wide open and let the APIC figure out where to map 
the IRQs.  Ideally, we should probably make this decision based on the APIC, but 
if there's no PPC hardware that uses this technique, then it would suffice to 
make this arch-specific.

-- Chris
