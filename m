Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYBKR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYBKR6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYBKR6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:58:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:26271 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbYBKR6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:58:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,334,1199692800"; 
   d="scan'208";a="516675390"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: DMAR EHCI failures
Date: Mon, 11 Feb 2008 09:51:32 -0800
Message-ID: <8012EB0B6BDD82478B53C8ED1EA17FD806A02848@orsmsx411.amr.corp.intel.com>
In-Reply-To: <200802091802.41596.david-b@pacbell.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: DMAR EHCI failures
thread-index: AchriS2QwzIoXmbWTgybkO1nSvdGZABTS7bA
References: <47A74B02.8050704@gmail.com> <200802091802.41596.david-b@pacbell.net>
From: "Raj, Ashok" <ashok.raj@intel.com>
To: "David Brownell" <david-b@pacbell.net>, "Jiri Slaby" <jirislaby@gmail.com>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       <linux-usb@vger.kernel.org>, "Alan Stern" <stern@rowland.harvard.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       "Dave Airlie" <airlied@linux.ie>
X-OriginalArrivalTime: 11 Feb 2008 17:51:30.0732 (UTC) FILETIME=[BBA9AEC0:01C86CD6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thought someone replied to this, 

Basically graphics drivers don't use DMA apis for translation at the
moment, hence when we turn on translation we will get faults since IOMMU
would not be able to translate. 

The workaround used to do two things.

1. IF this is dedicated DMAR for igfx, then we just disable the iommu
2. if this is pcie graphics, we provide a 1-1 so we can avoid those
faults.


Sometimes you get those faults for usb devices if the RMRR is not set
correctly by BIOS. An easy workaround is if you disable legacy mode in
bios those should disappear.


Cheers,
ashok raj
- Open Source Technology Center
   

>-----Original Message-----
>From: David Brownell [mailto:david-b@pacbell.net]
>Sent: Saturday, February 09, 2008 6:03 PM
>To: Jiri Slaby
>Cc: David Brownell; linux-usb@vger.kernel.org; Alan Stern; Linux Kernel
Mailing List; Raj, Ashok; Li,
>Shaohua; Keshavamurthy, Anil S; Dave Airlie
>Subject: Re: DMAR EHCI failures
>
>On Monday 04 February 2008, Jiri Slaby wrote:
>> Hi,
>>
>> I have this in dmesg:
>> DMAR:[DMA Write] Request device [00:02.0] fault addr ee1512000
>> DMAR:[fault reason 05] PTE Write access is not set
>> PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
>> DMAR:[DMA Read] Request device [00:1d.7] fault addr 7d5f0000
>> DMAR:[fault reason 06] PTE Read access is not set
>> DMAR:[DMA Read] Request device [00:1a.7] fault addr 7d5f1000
>> DMAR:[fault reason 06] PTE Read access is not set
>> PCI-GART: No AMD northbridge found.
>> DMAR:[DMA Read] Request device [00:1a.2] fault addr 7d5f7000
>> DMAR:[fault reason 06] PTE Read access is not set
>>
>> CONFIG_DMAR=y
>> CONFIG_DMAR_GFX_WA=y
>> CONFIG_DMAR_FLOPPY_WA=y
>>
>> Without the gfx workaround, there is much more output regarding
00:02.0. Is
>> there problem with broken hw, bios or drivers?
>
>No idea.  Someone who knows the DMA Remapping stuff should have
>an answer.  Presumably it works with DMAR disabled, yes?  If so,
>then just don't use DMAR.  :)
>
>
>> /sys/firmware/acpi/tables/DMAR:
>> http://www.fi.muni.cz/~xslaby/sklad/DMAR.bin
>> dmesg:
>> http://www.fi.muni.cz/~xslaby/sklad/DMAR.dmesg
>>
>> # for a in 00:02.0 00:1d.7 00:1a.7 00:1a.2; do lspci -vxxx -s $a;
done
>> 00:02.0 VGA compatible controller: Intel Corporation 82G33/G31
Express
>> Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
>>          ... deletia ...
>>
>

