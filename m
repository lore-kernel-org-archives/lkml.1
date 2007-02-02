Return-Path: <linux-kernel-owner+w=401wt.eu-S1945981AbXBBRZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945981AbXBBRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 12:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945989AbXBBRZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 12:25:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:35100 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945981AbXBBRZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 12:25:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,273,1167638400"; 
   d="scan'208"; a="176395146:sNHT1975292368"
Message-ID: <45C37412.70205@intel.com>
Date: Fri, 02 Feb 2007 09:25:38 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Adam Kropelin <akropel1@rochester.rr.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: MSI failure on nForce 430 (WAS: intel 82571EB gigabit fails to
 see link on 2.6.20-rc5 in-tree e1000 driver (regression))
References: <20070117190448.A20184@mail.kroptech.com> <45AEB79B.2010205@intel.com> <00d701c73c1f$b2bb2390$84163e05@kroptech.com> <45B1562C.8070503@intel.com> <011101c73c29$9f6f5db0$84163e05@kroptech.com> <45B16491.7030207@intel.com> <023401c73cca$05bc5f00$84163e05@kroptech.com> <20070202164726.GH3754@stusta.de>
In-Reply-To: <20070202164726.GH3754@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2007 17:25:39.0050 (UTC) FILETIME=[284B4CA0:01C746EF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Jan 20, 2007 at 02:34:37PM -0500, Adam Kropelin wrote:
>> (cc: list trimmed and thread moved to linux-pci)
>>
>> I have a PCI-E e1000 card that does not see interrupts on 2.6.20-rc5 
>> unless CONFIG_PCI_MSI is disabled. An e1000 maintainer indicated that 
>> the PHY state is correct, it's just that the interrupt is not getting 
>> thru to the kernel. Interestingly, on 2.6.19 PHY interrupts get thru ok 
>> with MSI enabled (link status responds appropriately) but packet tx 
>> fails with timeout errors, implying that perhaps MAC interrupts are not 
>> arriving.
>>
>> I've attached the contents dmesg, 'lspci -vvv', and 'cat 
>> /proc/interrupts' from 2.6.20-rc5.
>>
>> This is an nForce 430 based chipset on a Dell E521 which has had 
>> interrupt routing issues before. Prior to 2.6.19 it had to be booted 
>> with 'noapic' in order to come up at all. It also had USB lockup 
>> problems until I applied the latest BIOS update (v1.1.4). So a BIOS 
>> interrupt routing bug with MSI is not out of the question.
>>
>> I'm happy to gather more data or run tests...
> 
> Was this regression fixed by Eric's patch that is included in -rc7?

no, this is a different issue afaics. Eric's patch solves a msi vector leak 
where MSI's were no longer recovered after all 256 of them were handed out. The 
issue here seems to be a very different regression (no vector at all or vector 
not setup correctly to begin with).

I do suggest re-testing the issue with 2.6.20rc7, but it's unlikely it fixes the 
problem for Adam.

The same issue was reported 2/3 days ago by another user basically too (no 
interrupts at all arriving with MSI enabled).

Cheers,

Auke
