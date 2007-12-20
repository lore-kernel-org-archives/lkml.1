Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbXLTANr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbXLTANr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 19:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbXLTANj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 19:13:39 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:3289 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbXLTANi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 19:13:38 -0500
Date: Wed, 19 Dec 2007 18:12:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 0/5]PCI: x86 MMCONFIG
In-reply-to: <fa.3T2SqNjavN55hanLOjr3RO+WalE@ifi.uio.no>
To: Greg KH <gregkh@suse.de>
Cc: tcamuso@redhat.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, prarit@redhat.com
Message-id: <4769B368.1030402@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.zIbPFbLub6ANMT5vMxS6hx+dfv0@ifi.uio.no>
 <fa.3T2SqNjavN55hanLOjr3RO+WalE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Dec 19, 2007 at 05:17:46PM -0500, tcamuso@redhat.com wrote:
>> OVERVIEW
>> =======
>>
>> The patches should be applied in sequence to obviate any
>> possible build problems.
>>
>> The patch-set was built against 2.6.24-rc5
>>
>> Description
>> ===========
>>
>> There exist devices that do not respond correctly to PCI
>> MMCONFIG accesses in x86 platforms.
> 
> What devices are these?  Do you have reports of them somewhere?
> 
>> This patch-set detects the problem by comparing an MMCONFIG
>> read to a Legacy PCI config read of the vendor/device dword
>> of every device discovered during the PCI probing sequence.
>>
>> A miscompare means that a device does not correctly respond
>> to MMCONFIG accesses. When the patch code detects this condition,
>> the bus that serves this device, and all subordinate buses, will
>> be programmed to use Legacy PCI Config accesses.
>>
>> This patch-set DOES NOT detect devices that generate machine
>> checks against MMCONFIG accesses. For such systems,
>> "pci=nommconf" is required in the boot command.
> 
> That sounds like this patchset can cause bad side affects on hardware
> that currently works just fine.  That is not a good thing to be adding
> to the kernel, right?

I think we need more details on why this patch is needed. Also, we 
already have something like this in arch/x86/pci/mmconfig-shared.c, in 
the unreachable_devices function. This attempts to detect devices where 
MMCONFIG cannot access the configuration space (one of these would be at 
least one device in the AMD K8 built-in northbridge). If this is not 
sufficient, I would suggest expanding that mechanism instead of adding 
all this new code.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

