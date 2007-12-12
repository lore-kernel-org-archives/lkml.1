Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbXLLXpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbXLLXpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXLLXpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:45:11 -0500
Received: from mail171.messagelabs.com ([216.82.253.243]:42565 "HELO
	mail171.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751012AbXLLXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:45:10 -0500
X-VirusChecked: Checked
X-Env-Sender: arasv@magtech.com.au
X-Msg-Ref: server-11.tower-171.messagelabs.com!1197503108!13866955!1
X-StarScan-Version: 5.5.12.14.2; banners=magtech.com.au,-,-
X-Originating-IP: [150.101.126.166]
Message-ID: <4760727E.2090906@magtech.com.au>
Date: Thu, 13 Dec 2007 10:45:02 +1100
From: Aras Vaichas <arasv@magtech.com.au>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: mmaping an IO port device
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can I implement mmap with an io port connected device on an x86 based CPU?


Background:

I've got a device driver which can be compiled for either x86 or ARM. 
The driver provides an interface to an FPGA via either an IO port 
(0x180) on the x86 or as a memory mapped SRAM-like device (0x30000000) 
on the ARM.

To get myself an "address" for ioread calls I use:

FPGA_base = (u32) ioremap_nocache(FPGA_REG_IO_BASE, SZ_4K) for both CPU 
types.

FPGA_REG_IO_BASE is set to either 0x180 or 0x30000000 for x86 and ARM 
respectively.

I then call ioread16(FPGA_base + FPGA_register) for both x86 and ARM and 
it all works perfectly. No problems there.

My problem is that I am now moving from ioctl calls to a mmap interface. 
This isn't a problem with ARM as I can pass (0x30000000 >> PAGE_SHIFT) 
to remap_pfn_range() in the .mmap fops function but I can't pass 0x180 
because ... well, it's obvious.

Is there a trick?

Aras

______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
