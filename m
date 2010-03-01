Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0CAWB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 17:01:26 -0500
Received: from claw.goop.org ([74.207.240.146]:47023 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0CAWBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:01:25 -0500
Message-ID: <4B8C3933.7080507@goop.org>
Date: Mon, 01 Mar 2010 14:01:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add arch_probe_nr_irqs()
 again
References: <20100207210250.GB8256@jenkins.home.ifup.org>	 <tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>	 <4B881097.1050505@kernel.org>	 <1267442545.11737.20718.camel@zakaz.uk.xensource.com>	 <m1d3zn7uwl.fsf@fess.ebiederm.org> <1267479860.2785.843.camel@localhost.localdomain>
In-Reply-To: <1267479860.2785.843.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 01:44 PM, Ian Campbell wrote:
>> - Xen has an array irq_info[NR_IRQS] one of the last static arrays
>>    sized at NR_IRQs in the entire kernel.
>>      
> Hopefully the same info as is in that array could (and indeed should) be
> instead stored in irq_desc->chip_data. Would you object to
> arch_init_copy_chip_data and arch_free_chip_data becoming function
> pointers within the struct irq_chip?
>    

Yes, I was just about to suggest something like this.  We just need a 
mechanism of storing some per-irq info, and attaching it to the existing 
desc structure is much cleaner than maintaining some parallel structure.

You're right about the chip_data lifetime functions; it seems very odd 
that most of irq_chip is nicely factored out into a set of ops, but the 
per-chip data management is per-architecture.

With that in place, we could eliminate any dependency on irq numbers.

     J
