Return-Path: <linux-kernel-owner+w=401wt.eu-S1946882AbXD3XUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946882AbXD3XUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946881AbXD3XUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:20:39 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:61728 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423777AbXD3XUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:20:10 -0400
Date: Mon, 30 Apr 2007 17:20:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] support PCI MCFG space on Intel i915 bridges
In-reply-to: <200704301225.22016.jesse.barnes@intel.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-id: <463679A4.60704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.aWIs6SNmpl2IhGAAoSWJu6oKjPo@ifi.uio.no>
 <46355007.5030807@shaw.ca> <200704301225.22016.jesse.barnes@intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Sunday, April 29, 2007 7:10 pm Robert Hancock wrote:
>> Jesse Barnes wrote:
>>> Add support for Intel 915 bridge chips to the new PCI MMConfig
>>> detection code.  Tested and works on my sole 915 based platform (a
>>> Toshiba laptop).  I added register masking per Oliver's suggestion,
>>> and moved the __init qualifier to after the 'static const char' to
>>> match Ogawa-san's recent cleanup patches.
>>>
>>> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
>>>
>>> diff --git a/arch/i386/pci/mmconfig-shared.c
>>> b/arch/i386/pci/mmconfig-shared.c index 747d8c6..1339d31 100644
>>> --- a/arch/i386/pci/mmconfig-shared.c
>>> +++ b/arch/i386/pci/mmconfig-shared.c
>>> @@ -72,6 +72,26 @@ static const char __init *pci_mmcfg_e7520(void)
>>>  	return "Intel Corporation E7520 Memory Controller Hub";
>>>  }
>>>
>>> +static const char __init *pci_mmcfg_intel_915(void)
>>> +{
>>> +       u32 pciexbar, len = 0;
>>> +
>>> +       pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
>>> +
>>> +       /* No enable bit or size field, so assume 256M range is
>>> enabled. */ +       len = 0x10000000U;
>> Check the 915 spec more carefully, there is an enable bit, it's in
>> the DEVEN register offset 54h, the bit is called PCIEXBAREN (bit 31).
>> If that is not set you should be setting pci_mmcfg_config_num to 0
>> and bailing out.
> 
> Right, but you patch should obsolete this stuff anyway.  I'll test it 
> out in the next few days.

We likely still want this chipset-specific support, it will catch the 
case where the MCFG table lists a location which is reserved in ACPI but 
the chipset was actually programmed to a different location entirely, 
which I seem to remember someone mentioning was actually the case on 
some boards..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


