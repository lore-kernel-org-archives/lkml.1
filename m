Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbYHXVxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbYHXVxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 17:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYHXVwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 17:52:54 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:32451 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYHXVwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 17:52:53 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=DM4wlKETVA9SrQwULzsA:9 a=-hcxSDLDbLar8_8VWJQA:7 a=3z6X5WESLpGOJ24Pkb9EJyCnie8A:4 a=Aks6A_XPZJcA:10 a=88GqaR7iNyEA:10 a=LQpqtOfbXR4A:10
Message-ID: <48B1D82C.5000107@shaw.ca>
Date: Sun, 24 Aug 2008 15:52:44 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jari Aalto <jari.aalto@cante.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
References: <fa.c8YPWdZHXAabbZwTVLAgq9ahOlE@ifi.uio.no> <fa.9B7J3O7801PlFtm4WwuBX/J0kU8@ifi.uio.no> <fa.ES0QYHe349FfrOTaqTun1n3qaYk@ifi.uio.no> <fa.8FK+C3lDiXBnZCV9FTofTkm6PJE@ifi.uio.no> <fa.cN6j0N4TRlTlG7oLEhhT8Wj2N7A@ifi.uio.no> <fa.XwRqZTkk0olSp3UUnbSFZahR4TI@ifi.uio.no>
In-Reply-To: <fa.XwRqZTkk0olSp3UUnbSFZahR4TI@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jari Aalto wrote:
> Krzysztof Halasa <khc@pm.waw.pl> writes:
> 
>> Jari Aalto <jari.aalto@cante.net> writes:
>>
>>> >From Debian stock kernel:
>>>
>>> $ grep -Ei 'iommu|agp' /boot/config-2.6.25-2-amd64
>>> CONFIG_GART_IOMMU=y
>>> CONFIG_CALGARY_IOMMU=y
>>> CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
>>> CONFIG_IOMMU_HELPER=y
>>> CONFIG_AGP=y
>>> CONFIG_AGP_AMD64=y
>>> CONFIG_AGP_INTEL=m
>>> CONFIG_AGP_SIS=m
>>> CONFIG_AGP_VIA=m
>> Should be fine. SWIOTLB is there for a backup, most (?) Intel machines
>> don't have IOMMU (even the newest desktop boards).
>>
>>> Are these the correct boot options, without swiotlb?
>>>
>>>    iommu=noagp,noaperture,off
>>>
>>> Or just:
>>>
>>>    iommu=off
>> Do you have problems without "iommu=XXX"?
> 
> Initially when the PC was installed (and had no IOMMU) options, that
> cause the whole harddisk to corrupt and I had to reinstall everything.
> It might have been a little older kernel (2.6.23?), but I don't recall
> it exactly.
> 
> According to messages in syslog I tried to track down similar incidents
> and found the iommu articles. But the information was like trial and
> error.
> 
> Would you suggest that "immu=off" would be best option?

No, you can't use iommu=off. If you have memory located over 4GB and 
devices which can only do 32-bit DMA then you need some kind of IOMMU 
support, otherwise things will just blow up.

If you use no options and it's enabled in the kernel config it should be 
using the GART IOMMU built into the CPU on this machine..
