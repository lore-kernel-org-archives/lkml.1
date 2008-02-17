Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbYBQML1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbYBQML1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYBQMLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:11:19 -0500
Received: from gw.goop.org ([64.81.55.164]:55398 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbYBQMLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:11:18 -0500
Message-ID: <47B823E9.9020205@goop.org>
Date: Sun, 17 Feb 2008 23:09:13 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org> <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org> <20080215202336.GE26034@mail.oracle.com> <47B64E0A.1020007@goop.org> <20080216085454.GA24570@ca-server1.us.oracle.com> <47B6CD0F.4020202@goop.org> <20080217062958.GC26206@mail.oracle.com>
In-Reply-To: <20080217062958.GC26206@mail.oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker wrote:
>   
>> Unfortunately that doesn't narrow down what the kernel was actually  
>> trying to do at the time.  Clearly a set_pte; looks like someone is  
>> trying to create a writable mapping of an existing pte page.
>>
>> Does "console=hvc0 earlyprintk=xen" on the kernel command line give any  
>> clue about how far it gets before crashing?
>>     
>
>   

I built a kernel using your .config here, but I can't reproduce the 
problem.  It makes it all the way to trying to start init (failed at 
that point because I didn't create an initrd with the xvd module to 
mount /).

> 	Console is already hvc0, but earlyprintk gets us:
>
> --8<-----------------------------------------------------------------
> Reserving virtual address space above 0xf57fe000
> Linux version 2.6.25-rc2-bisectme (jlbec@ca-build23.us.oracle.com) (gcc
> version 4.1.2 20070626 (Red Hat 4.1.2-14)) #21 SMP Fri Feb 15 16:28:35
> PST 2008
> ACPI in unprivileged domain disabled
> BIOS-provided physical RAM map:
>  Xen: 0000000000000000 - 0000000078000000 (usable)
> console [xenboot0] enabled
> 1192MB HIGHMEM available.
> 727MB LOWMEM available.
> Started domain ca-test58
>                         Scan SMP from c0000000 for 1024 bytes.
> Scan SMP from c009fc00 for 1024 bytes.
> Scan SMP from c00f0000 for 65536 bytes.
> NX (Execute Disable) protection: active
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->   186366
>   HighMem    186366 ->   491520
> Movable zone start PFN for each node
> early_node_map[1] active PFN ranges
>     0:        0 ->   491520
> -->8-----------------------------------------------------------------
>
> That's it.
>   

I get:

Entering add_active_range(0, 0, 16384) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    16384
  HighMem     16384 ->    16384
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    16384
On node 0 totalpages: 16384
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 96 pages used for memmap
  Normal zone: 12192 pages, LIFO batch:1
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
...


What happens if you give the domain less memory?

    J
