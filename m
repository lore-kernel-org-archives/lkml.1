Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbZFPQqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbZFPQqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZFPQqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:46:45 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:62872 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZFPQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:46:44 -0400
Message-ID: <4A37CC72.3060709@freescale.com>
Date: Tue, 16 Jun 2009 11:46:42 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Chris Pringle <chris.pringle@oxtel.com>
CC: linux-kernel@vger.kernel.org,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
References: <4A37A503.3030209@oxtel.com> <20090616162114.GA5051@loki.buserror.net> <4A37C97A.5050508@oxtel.com>
In-Reply-To: <4A37C97A.5050508@oxtel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Pringle wrote:
> The kernel version is 2.6.26. Firmware is custom on a custom board.
>> Cache coherency on PCI DMA requires that the memory be mapped with the M
>> attribute on this chip, but that should be happening based on 
>> detection of
>> the core.
>>   
> I'm not sure where to look to verify this?

Check asm/cputable.h for CPU_FTR_NEED_COHERENT.  Make sure that 
CONFIG_8260 is one of the #ifdefs that turns that on.  It looks like 
that was in place by 2.6.26 in arch/powerpc.  I'm not sure what to look 
for in arch/ppc.

>> Also make sure that you park the bus on PCI and raise its arbitration
>> priority, as done at the end of fixup_pci in 
>> arch/powerpc/boot/cuboot-pq2.c.
>>   
> Since this is a reasonably recent kernel,

Not really, there was a fair amount of 82xx work in the mid-2.6.20s. 
The addition of CPU_FTR_NEED_COHERENT to 82xx was somewhere in that time.

Can you try 2.6.30?

> I'd guess that both of these 
> things are correct. I've had a quick look in that file and there is code 
> in there raising arbitartion priority and parking the bus.

Just because the code is there doesn't mean you're using it -- are you 
using cuImage?  Are you using arch/ppc or arch/powerpc?

Typically this would be done by firmware; it's only in cuboot because 
u-boot wasn't doing it.

>> BTW, you may want to post to linuxppc-dev@lists.ozlabs.org for
>> powerpc-specific issues, especially this kind of hardware issue.
>>
>>   
> I've just posted there :-)

Doh, sorry. :-)

> Interestingly, I've just turned off cache snooping and the problem has 
> got much worse. This has surprised me as I thought that part of the job 
> done by pci_map_sg was to flush the CPU cache

It only flushes the cache on hardware that doesn't do coherent DMA.

-Scott

