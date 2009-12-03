Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZLCNaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZLCNaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZLCNaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:30:14 -0500
Received: from flmx07.ccur.com ([12.192.68.12]:53853 "EHLO flmx07.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbZLCNaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:30:13 -0500
Message-ID: <4B17BD6D.1070000@ccur.com>
Date: Thu, 3 Dec 2009 07:30:21 -0600
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Setting /proc/irq/[n]/smp_affinity failure on 8
 cpu systems
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > On Wed, 2009-12-02 at 08:19 -0800, John Blackwood wrote:
 > > > I would like to mention an irq set affinity issue occurs on an
 > > > older Dell PowerEdge 6650 system:
 > > >     - 8 cpus (4 are hyper-threaded),
 > > >     - uses the struct apic 'apic_default' support
 > > >     - 32 bit (x86) kernel
 > > >
 > > > This issue is that once you change the irq smp_affinity of an irq
 > > > to be less than all cpus in the system, you can never change really
 > > > the
 > > > irq smp_affinity back to be all cpus in the system (0xff) again,
 > > > even though no error status is returned on the "/bin/echo ff >
 > > > /proc/irq/[n]/smp_affinity" operation.
 > > >
 > > > This is due to that fact that BAD_APICID has the same value as
 > > > all cpus (0xff) on 32bit kernels, and thus the value returned from
 > > > set_desc_affinity() via the cpu_mask_to_apicid_and() function is
 > > > treated
 > > > as a failure in set_ioapic_affinity_irq_desc(), and no affinity
 > > > changes
 > > > are made.
 > > >
 > > > It seems like changing the BAD_APICID value from 0xFF to 0xFFFF for
 > > > CONFIG_X86_32 might be one possible solution, and it seems to function
 > > > properly for this Dell PowerEdge 6650 system.
 >
 > John, Thanks for the root cause and analysis. As you noticed, 0xff is a
 > valid logical apicid. Similarly 0xffff is a valid logical x2apic cluster
 > id. So while your patch fixes your issue, it doesn't completely fix the
 > issue. Can you please check if the appended patch works and ack if it
 > passes your test?
 >

Hi Suresh,

Yes, your patch works on the Dell PowerEdge 6650 system.

Thanks for your help and quick reply.

