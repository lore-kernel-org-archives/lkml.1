Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbXF2A64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbXF2A64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 20:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762503AbXF2A6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 20:58:47 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:18724 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764741AbXF2A6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 20:58:46 -0400
Date: Thu, 28 Jun 2007 18:58:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.22-rc6-mm1 Intel DMAR crash on AMD x86_64
In-reply-to: <fa.WYdi9Gj/0/XomcQpW4CEW5a4kKI@ifi.uio.no>
To: Zan Lynx <zlynx@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com
Message-id: <46845943.7050005@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GKNLH/oj9PSCnQCxx9ZAggjc5uA@ifi.uio.no>
 <fa.WYdi9Gj/0/XomcQpW4CEW5a4kKI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zan Lynx wrote:
> On Thu, 2007-06-28 at 03:43 -0700, Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
> 
>> +intel-iommu-dmar-detection-and-parsing-logic.patch
>> +intel-iommu-pci-generic-helper-function.patch
>> +intel-iommu-pci-generic-helper-function-fix.patch
>> +intel-iommu-clflush_cache_range-now-takes-size-param.patch
>> +intel-iommu-iova-allocation-and-management-routines.patch
>> +intel-iommu-iova-allocation-and-management-routines-fix.patch
>> +intel-iommu-iova-allocation-and-management-routines-fix-2.patch
>> +intel-iommu-intel-iommu-driver.patch
>> +intel-iommu-intel-iommu-driver-fix.patch
>> +intel-iommu-intel-iommu-driver-fix-2.patch
>> +intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
>> +intel-iommu-intel-iommu-cmdline-option-forcedac.patch
>> +intel-iommu-dmar-fault-handling-support.patch
>> +intel-iommu-iommu-gfx-workaround.patch
>> +intel-iommu-iommu-floppy-workaround.patch
>> +intel-iommu-iommu-floppy-workaround-fix.patch
>> +intel-iommu-iommu-floppy-workaround-fix-fix.patch
>>
>>  Intel IOMMU support
> 
> I believe the above patch set is causing the problem.  On my first try
> with rc6-mm1 I said Yes to the CONFIG_DMAR options. (I'm nearly as good
> as random option selection :-)
> 
> The system panicked during boot, I believe it was trying to detect an
> Intel IOMMU.  Later when I have a camera, I will try to post a
> screenshot of the backtrace. (I can't seem to get netconsole to work on
> boot, only in a module).
> 
> When I recompiled without DMAR set, things seem to be working great.  I
> seem to be getting better disk read throughput than rc3-mm1, by the way.
> 
> This laptop is an AMD Athlon64 on a NForce3 running a 64-bit Gentoo
> build.
> 
> I'll provide more details on request, and when I get the chance.  This
> is a heads-up on the BUG in case someone has an "ah ha!" moment.

I took a picture of it, looks like the backtrace is:

NULL pointer dereference at 024
EIP:dmar_table_init+0x11
intel_iommu_init+0x30
pci_iommu_init+0xe
kernel_init+0x16e

Presumably something is NULL in dmar_table_init that wasn't expected to 
be.. I would guess it likely crashes on any system without an Intel 
IOMMU in it.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

