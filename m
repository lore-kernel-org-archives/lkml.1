Return-Path: <linux-kernel-owner+w=401wt.eu-S1946280AbXBIJqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946280AbXBIJqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946282AbXBIJqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:46:52 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:32377 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946280AbXBIJqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:46:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ErWG+JmL6IKIJbVp6d640nEbiFPifmzw/qF3F0rUhBFxipF2zHC4S1dZwsu2PJ3h3ZKEqkUyd84AoSQhSAbfXr3WBGDPj4ufXZKNBHthwHprqtSc3JC1Jl0jjheqYzxl7VJXhpPB4FQRa2PLYeznLBjkWUpRDrLwJeXC1ICm1aM=
Message-ID: <45CC42FF.5030507@gmail.com>
Date: Fri, 09 Feb 2007 04:46:39 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: lepalom@wol.es
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sata_via problems in a Vintage2-AE1
References: <200702090010.06897.lepalom@wol.es>
In-Reply-To: <200702090010.06897.lepalom@wol.es>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Leopold Palomo Avellaneda wrote:
> Dear people,
> 
> I have a barebone Asus Vintage2-AE1 [1]. This box has a mobo Asus A8V-MQ. The 
> board has:
> - the Socket 939 for AMD Athlon 64FX/Athlon 64.
> - North Bridge: VIA K8M800  
> - South Bridge: VIA VT8251
> - VIA Graphics Integrated
> - IDE 2 x UltraDMA 133
> - 4 x Serial ATA
> ...
> 
> I'm using the bios version 0206. The 0210 doesn't show me the vga card, so I 
> don't have graphics mode. I think that is a buggy bios.
> 
> The bios is configured with vt8251 in AHCI mode and bios boot up activated, so 
> the hd is recognized in the beginning. I don't have any raid, only one hd. 
> The hd is a Maxtor 6V250F0.
> 
> I'm using a debian etch but the i386 version. The only way that I can use the 
> hd is using a 2.6.16 standard kernel with the modifications explained in this 
> page [2]. Basically you have to use their ahci.c and sata_via.c. The 
> modifications are small from the original code from Mr Jeff Garzik.
> 
> I have tried to use the 2.6.18 and 2.6.20rc6 and the result is the same. The  
> kernel boots, but when arrives at the ata3, 
> 
> scsi2 : ahci
> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata3.00: qc timeout (cmd 0xec)
> ata3.00: failed to IDENTIFY (I/O error, err_mask=0x104)
> .... repeated some times ...
> scsi3 : ahci
> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> scsi4 : ahci
> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> scsi5 : ahci
> ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> Done.
> Begin: Mounting root file system... ...
> Begin: Running /scripts/local-top
> ide0: I/O resource 0x3F6-0x3F6 not free.
> ide0: ports already in use, skipping probe.
> ide1: I/O resource 0x376-0x376 not free.
> ide1: ports already in use, skipping probe.
> Done.
> Begin: Waiting for root file system ...

It might be VIA IRQ quirk problem.

1. Does giving 'irqpoll' parameter to kernel make any difference?

2. Can you give a shot at 2.6.20?

-- 
tejun
