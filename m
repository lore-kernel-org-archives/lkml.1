Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbXLMXkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbXLMXkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764985AbXLMXjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:39:44 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9921 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764746AbXLMXjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:39:41 -0500
Date: Thu, 13 Dec 2007 17:38:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI resource unavailable on mips
In-reply-to: <fa.vbvzhsk+kDPCopbmajO8EsxAnKE@ifi.uio.no>
To: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4761C26C.3010708@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.vbvzhsk+kDPCopbmajO8EsxAnKE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Dufresne wrote:
> Hi,
> 
> I've done a bit of linux driver development on x86 in the past.
> Currently I am working on my first ever linux driver for a mips box. I
> started by testing the device in an x86 box and got it reasonable stable
> and am now testing it in the mips box. There appears to be a major
> problem, one unlike I have ever seen before.
> 
> My PCI device has three BARS. This can be confirmed by the Technical
> documentation and the x86 code. When the pci device is first probed, I
> run a loop to printk out the bar information, this is just as a sanity
> check. Here is the output on the x86:
> 
> Bar0:PHYS=e0000000 LEN=04000000
> Bar1:PHYS=efa00000 LEN=00200000
> Bar2:PHYS=e8000000 LEN=04000000

So, two 64MB BARs and a 2MB one?

> 
> but here is the output on the mips:
> Bar0:PHYS=20000000 LEN=04000000
> Bar1:PHYS=24000000 LEN=00200000
> Bar2:PHYS=00000000 LEN=00000000
> 
> notice, BAR2 has no valid information on the mips. I tried to run
> "pci_enable_device" before printing this information, as suggested by
> LDD but it did not help.
> 
> Has anyone seen a problem like this before and any idea how I can get
> BAR2 a proper address?
> 
> If I examine the config space directly there is an address in BAR2's
> register, however it isn't in the 0x20000000 range like the other two,
> instead it is 0x1c000000. Also if I do a ``cat /proc/iomem'' I correctly
> see BAR0 and BAR1 in the output, but not BAR2.

Any PCI resource allocation errors in dmesg during the boot process? 
Could be the kernel wasn't able to find a place to map all of the BARs.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

