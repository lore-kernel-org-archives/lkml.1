Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZFEDwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZFEDwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZFEDwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:52:40 -0400
Received: from mail.lang.hm ([64.81.33.126]:54879 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZFEDwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:52:40 -0400
Date: Thu, 4 Jun 2009 20:52:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: only a single core (out of 8) initialized
In-Reply-To: <20090604202933.d7c24c3d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906042049230.11064@asgard>
References: <alpine.DEB.1.10.0906041949030.7953@asgard> <20090604202933.d7c24c3d.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Andrew Morton wrote:

> Subject: Re: only a single core (out of 8) initialized
> 
> On Thu, 4 Jun 2009 19:52:36 -0700 (PDT) david@lang.hm wrote:
>
>> this is 2.6.30-rc7
>
> Were any earlier kernels OK?
>
>>  with a patch added to debug a nv sata driver
>> incompatibility with the Intel SSDs on a tyan motherboard
>>
>> on one system it sees all 8 cores, on the other system it only initializes
>> one core.
>>
>> can anyone help me spot what's going wrong in the one that's only seeing a
>> single core? If I'm reading things correctly it's seeing both sockets for
>> the NUMA setup, but then only initializing one core on the first socket.
>
> good:
> 	SMP: Allowing 8 CPUs, 4 hotplug CPUs
>
> bad:
> 	SMP: Allowing 1 CPUs, 0 hotplug CPUs
>
> perhaps due to
> 	ACPI: No APIC-table, disabling MPS
>
> You could have a poke around in arch/x86/kernel/smpboot.c() and find
> out what happened here.  I'd be suspecting this code triggered:
>
>        /* no processor from mptable or madt */
>        if (!num_processors)
>                num_processors = 1;
>
> because ACPI doesn't like that board.
>
> Did you look into updating the BIOS?

this is actually the newer of the two systems. I've already escalated up 
to Tyan about the fact that this board won't see the Intel SSD drives 
(unless you hotplug the drive). I've forwarded this to them as well. their 
website does show a newer bios than what was shipped to me.

David Lang
