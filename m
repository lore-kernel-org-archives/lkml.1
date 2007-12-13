Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbXLMAxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbXLMAxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXLMAxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:53:06 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:62880 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXLMAxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:53:05 -0500
Date: Wed, 12 Dec 2007 18:52:11 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: mmaping an IO port device
In-reply-to: <fa.noVJACisdR+sMNi3JjMxD+zdqf8@ifi.uio.no>
To: Aras Vaichas <arasv@magtech.com.au>
Cc: linux-kernel@vger.kernel.org
Message-id: <4760823B.30901@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.noVJACisdR+sMNi3JjMxD+zdqf8@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aras Vaichas wrote:
> Hi,
> 
> Can I implement mmap with an io port connected device on an x86 based CPU?
> 
> 
> Background:
> 
> I've got a device driver which can be compiled for either x86 or ARM. 
> The driver provides an interface to an FPGA via either an IO port 
> (0x180) on the x86 or as a memory mapped SRAM-like device (0x30000000) 
> on the ARM.
> 
> To get myself an "address" for ioread calls I use:
> 
> FPGA_base = (u32) ioremap_nocache(FPGA_REG_IO_BASE, SZ_4K) for both CPU 
> types.
> 
> FPGA_REG_IO_BASE is set to either 0x180 or 0x30000000 for x86 and ARM 
> respectively.
> 
> I then call ioread16(FPGA_base + FPGA_register) for both x86 and ARM and 
> it all works perfectly. No problems there.
> 
> My problem is that I am now moving from ioctl calls to a mmap interface. 
> This isn't a problem with ARM as I can pass (0x30000000 >> PAGE_SHIFT) 
> to remap_pfn_range() in the .mmap fops function but I can't pass 0x180 
> because ... well, it's obvious.
> 
> Is there a trick?
> 
> Aras

It's impossible to mmap an IO port area on x86 since IO ports are not 
accessible as part of the normal memory space. The only way to get 
access to IO ports in userspace is to use iopl (which requires root 
privileges) and then executing inl/outl, etc. instructions directly.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

