Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbZD0UQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbZD0UQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbZD0UQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:16:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:54657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbZD0UQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:16:18 -0400
Message-ID: <49F61265.10201@kernel.org>
Date: Mon, 27 Apr 2009 13:15:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Gary Hade <garyhade@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-acpi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
References: <49ED22EC.2040204@kernel.org> <200904271344.04099.bjorn.helgaas@hp.com>
In-Reply-To: <200904271344.04099.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Monday 20 April 2009 07:35:40 pm Yinghai Lu wrote:
>> it wil be overwriten later if _CRS is used, so don't bother to set it.
>>
>> [ Impact: cleanup ]
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/pci/amd_bus.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> Index: linux-2.6/arch/x86/pci/amd_bus.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/pci/amd_bus.c
>> +++ linux-2.6/arch/x86/pci/amd_bus.c
>> @@ -100,6 +100,10 @@ void x86_pci_root_bus_res_quirks(struct
>>  	int j;
>>  	struct pci_root_info *info;
>>  
>> +	/* don't go for it if _CRS is used */
>> +	if (pci_probe & PCI_USE__CRS)
>> +		return;
>> +
>>  	/* if only one root bus, don't need to anything */
>>  	if (pci_root_num < 2)
>>  		return;
> 
> This isn't a comment on this patch per se.
> 
> I am concerned about the fact that "pci=use_crs" is not the default.
> From the changelog of 62f420f8282, it sounds like you have to boot an
> IBM x3850 with "pci=use_crs" to make hot-plug work, even though ACPI
> tells us everything we need to know.  That's backwards.
> 
> We shouldn't need an option to tell Linux that the firmware is
> trustworthy.  We should have an option to *ignore* it for the times
> when we trip over something broken and haven't figured out a way to
> work around it yet.

other system may have broken _CRS.

maybe we could try to use DMI whitelist them?

YH
