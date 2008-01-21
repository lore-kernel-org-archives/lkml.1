Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYAUWZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYAUWZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYAUWZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:25:08 -0500
Received: from main.gmane.org ([80.91.229.2]:46995 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbYAUWZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:25:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: 2.6.24-rc8-git does not boot on Geode LX
Date: Mon, 21 Jan 2008 17:25:14 -0500
Message-ID: <20080121172514.531b6de0@ephemeral>
References: <20080120081442.GA12713@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: dsl092-071-179.bos1.dsl.speakeasy.net
In-Reply-To: <20080120081442.GA12713@1wt.eu>
X-Newsreader: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jan 2008 09:14:42 +0100
Willy Tarreau <w@1wt.eu> wrote:

> Hi,
> 
> I've just pulled latest -git and tried this morning in on one of my ALIX
> mobos equipped with an AMD Geode LX800 + CS5536. HEAD is a7da60f41551*.
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
> 

Hi Willy,

If this is in fact true (that GEODE_MFGPT_TIMER was disabled), the
machine hung, and with nomfgpt it didn't hang..   That sounds like
our geode_mfgpt_detect call hung.  Do you have "MFGPT Workaround"
selected in the BIOS?  I'm curious whether enabling or disabling
that makes a difference..

