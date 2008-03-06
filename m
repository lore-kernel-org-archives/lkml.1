Return-Path: <linux-kernel-owner+w=401wt.eu-S935010AbYCFQmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010AbYCFQmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764238AbYCFQlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:41:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762088AbYCFQlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:41:32 -0500
Message-ID: <47D01EB5.5080101@redhat.com>
Date: Thu, 06 Mar 2008 11:41:25 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: 64-bit AMD panic
References: <Pine.LNX.4.61.0803031205030.5874@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0803031205030.5874@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) wrote:
> Hello all,
> 
> We have 64-bit production machines that use the kernel shipped with
> a RedHat distribution, linux-2.6.11-1.1369_FC4smp. There have been
> no problems until we received recent hardware. With the latest hardware,
> which the vendor claims hasn't changed, the machines panic when either
> a USB mouse or USB keyboard are plugged in.
> 
> Machine:
> 
> Supermicro H8DME-2
> Two quad-Core AMD Opteron CPUs
> 64GB DDR2 400 SDRAM
> 6 SATA2 3.0Gb/s HD Support
> 2 64-bit 133/100 MHz PCI-X
> 2 64=bit 100MHz PCI-X
> ATI ES1000 Graphics
> 
> Chipset nVida MCP55 Pro
> NEC uPD720400
> USB FUCI, uses ohci_hcd driver.
> 
> When mouse or keyboard is inserted, I get a panic with:
> "map_single bounce buffer is not DMA'ble."
> 
> This comes from: linux-2.6.11-prep/arch/ia64/lib/swiotlb.c,
> line 440. I added 64-bit long print hex to the panic statement
> so I could display the address it doesn't like.

You're using an Itanium kernel on Opteron?

> The address it doesn't like is: 0x000000022a0aa000
> 
> Does anybody have a clue what might be the matter and how to fix it?

If the hardware "didn't change" then it could be a BIOS bug, or just a 
different BIOS behavior that your old kernel doesn't handle well.  Try 
the same version you had on the old hardware.  I once had a desktop box 
that developed a similar behavior when I twiddled the memory hole 
remapping settings in the BIOS.

-- Chris
