Return-Path: <linux-kernel-owner+w=401wt.eu-S1764515AbXIMUFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764515AbXIMUFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXIMUFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:05:30 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44186 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615AbXIMUF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:05:29 -0400
Date: Thu, 13 Sep 2007 13:14:44 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
 is used
In-reply-to: <20070913195203.GA1131@alberich.amd.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Martin Mares <mj@ucw.cz>,
       dean gaudet <dean@arctic.org>, Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <46E99A34.9070103@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <200709121921.43950.yinghai.lu@sun.com>
 <200709131147.43446.ak@suse.de> <20070913104704.GA3878@kroah.com>
 <200709131353.15752.ak@suse.de> <20070913195203.GA1131@alberich.amd.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> On Thu, Sep 13, 2007 at 01:53:15PM +0200, Andi Kleen wrote:
>> On Thursday 13 September 2007 12:47, Greg KH wrote:
>>> On Thu, Sep 13, 2007 at 11:47:42AM +0200, Andi Kleen wrote:
>>>> On Thursday 13 September 2007 04:21, Yinghai Lu wrote:
>>>>> [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is
>>>>> used.
>>>>>
>>>>> reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.
>>>> I just rejected a similar patch -- this should be done using MMCONFIG
>>> But what about for broken machines without the proper MMCONFIG entries?
>>> They still need a way to get access to this config space,
>> If there are any devices that need it. IBS and PCI-E error handling 
>> do, but they're quite obscure.
>>
>> Also so far we don't know of any Fam 10h systems without MMCONFIG
>> entries. Fam10h requires a new BIOS so it's reasonable to assume
>> that the new BIOSes will do better.
> 
> IMHO support for all config space access methods should be added to the kernel.
> And it should be added at a central point. Not waiting for drivers to do it
> their own way if they need to use it.
> 
> The more complicated/important question is how to decide which access method
> should be used for a device. (Something similar to the pci_mmcfg_fallback_slots
> stuff that exists already for K8 NB.)
> But that needs some more thinking.
> 
> Here a summary wrt family 10h extended config space access methods.
> (Most of this stuff I verified with some patched kernels. I didn't
> eavesdropping on the physical links though ...)
> 
> For family 10h we have 3 methods
> (1) "legacy" MMCONFIG access (via south bridge)
> (2) mmconfig access via CPU/NB (new with fam10h, using the new MMIO
>     config base MSR)
> (3) CF8/CFC ECS access (new with fam10h, has to be enabled in the NB_CFG MSR)

ECS access in NB_CFG_MSR is always enabled. because BIOS need to use that to do mem initialization.

mmconfig enablement in BIOS is depending ....

YH
