Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYATNmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYATNmB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 08:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYATNlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 08:41:52 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:57493 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753039AbYATNlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:41:51 -0500
Message-ID: <47934FC8.1030800@i4.informatik.rwth-aachen.de>
Date: Sun, 20 Jan 2008 14:42:32 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc8-git does not boot on Geode LX
References: <20080120081442.GA12713@1wt.eu>
In-Reply-To: <20080120081442.GA12713@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Willy Tarreau schrieb:
> Hi,
> 
> I've just pulled latest -git and tried this morning in on one of my ALIX
> mobos equipped with an AMD Geode LX800 + CS5536. HEAD is a7da60f41551*.

We boot 2.6.24-rc8 on these mainboards, which BIOS version do you use?

> 
> Last kernel which runs on it was 2.6.22.14. I've not yet tried intermediate
> kernels nor tried to bisect yet. Last messages are :
> 
> Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)                 
> Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)                   
> Memory: 257304k/262144k available (1506k kernel code, 4400k reserved, 370k data,
>  136k init, 0k highmem)                                                         
> virtual kernel memory layout:                                                   
>     fixmap  : 0xffffb000 - 0xfffff000   (  16 kB)                               
>     vmalloc : 0xd0800000 - 0xffff9000   ( 759 MB)                               
>     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)                               
>       .init : 0xc02d8000 - 0xc02fa000   ( 136 kB)                               
>       .data : 0xc0278970 - 0xc02d5504   ( 370 kB)                               
>       .text : 0xc0100000 - 0xc0278970   (1506 kB)                               
> Checking if this processor honours the WP bit even in supervisor mode... Ok.    
> SLUB: Genslabs=11, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1         
> Calibrating delay using timer specific routine.. 997.59 BogoMIPS (lpj=1995180)  
> Mount-cache hash table entries: 512                                             
> CPU: After generic identify, caps: 0088a93d c0c0a13d 00000000 00000000 00000000 
> 00000000 00000000 00000000                                                      
> CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)               
> CPU: L2 Cache: 128K (32 bytes/line)                                             
> CPU: After all inits, caps: 0088a93d c0c0a13d 00000000 00000000 00000000 0000000
> 0 00000000 00000000                                                             
> Compat vDSO mapped to ffffe000.                                                 
> CPU: AMD Geode(TM) Integrated Processor by AMD PCS stepping 02                  
> Checking 'hlt' instruction... OK.                                               
> Freeing SMP alternatives: 0k freed                                              
> net_namespace: 64 bytes                                                         
> NET: Registered protocol family 16                                              
> -----> hangs here <-----
> 
> In 2.6.22, the PCI is probed after this last message :
> 
> CPU: AMD Geode(TM) Integrated Processor by AMD PCS stepping 02
> Checking 'hlt' instruction... OK.
> NET: Registered protocol family 16                                              
> PCI: Using configuration type 1                                                 
> Setting up standard PCI resources                                               
> SCSI subsystem initialized                                                      
> PCI: Probing PCI hardware                                                       
> PCI: Probing PCI hardware (bus 00)                                              
> NET: Registered protocol family 2                                               
> 
> So I tried disabling PCI, MFGPT, etc... But no success yet.

Did you try to boot with nomfgpt?
In my experiments disabling CONFIG_GEODE_MFGPT_TIMER won't be enough to
boot 2.6.24-rc8 on a v0.98 bios or on a v0.99 bios with MFGPT workaround
turned on in the bios menu.
Otherwise the system will hang in arch/x86/kernel/mfgpt_32.c while
trying to detect MFGPT timers.
To clearify, for us the following works:
v0.99 bios, MFGPT workaround turned off in bios and
CONFIG_GEODE_MFGPT_TIMER=n

--- snip ---

Best regards,
Arnd Hannemann
