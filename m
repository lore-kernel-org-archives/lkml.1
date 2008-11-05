Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbYKEP70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbYKEP70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 10:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYKEP7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 10:59:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:16323 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYKEP7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 10:59:16 -0500
Message-ID: <4911C2CB.8010206@mimas.ru>
Date: Wed, 05 Nov 2008 19:59:07 +0400
From: Constantin Baranov <const@mimas.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080930 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc3] x86: make CONFIG_SWIOTLB configurable
References: <49107844.8070509@mimas.ru> <20081105102126.GC1424@ucw.cz>
In-Reply-To: <20081105102126.GC1424@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2008-11-04 20:28:52, Constantin Baranov wrote:
>> Make it possible to enable individually the CONFIG_SWIOTLB option.
>> This is useful for Intel x86_64 systems without DMAR support.
>>
>> Signed-off-by: Constantin Baranov <const@mimas.ru>
>> ---
>> Tested on my system based on Gigabyte GA-EP45-DS3 mainboard
>> (P45 chipset) with 8 GiB of RAM.
>> Currently I need to enable either CONFIG_GART_IOMMU or
>> CONFIG_AMD_IOMMU for proper work. Both are AMD specific.
>> When the patch applied, just CONFIG_SWIOTLB is sufficient.
>>
>>  arch/x86/Kconfig |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> --- linux-2.6.28-rc3/arch/x86/Kconfig	2008-11-04 17:32:29.846408880 +0400
>> +++ linux-2.6.28-rc3-swiotlb/arch/x86/Kconfig	2008-11-04 18:11:47.796408084 +0400
>> @@ -566,7 +566,9 @@ config AMD_IOMMU
>>  
>>  # need this always selected by IOMMU for the VIA workaround
>>  config SWIOTLB
>> -	bool
>> +	bool "Support for software bounce buffers"
>> +	depends on X86_64 && EXPERIMENTAL
>> +	default n
>>  	help
>>  	  Support for software bounce buffers used on x86-64 systems
>>  	  which don't have a hardware IOMMU (e.g. the current generation
> 
> Why experimental?
> 

As far as I understood, the comment before config SWIOTLB ('need this always selected by IOMMU for the VIA workaround') stands that voluntary enabling SWIOTLB may cause problems. Although I'm not sure that EXPERIMENTAL is really needed, or may be something else is better to prevent catastrophes.
