Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbYGXPKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbYGXPKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYGXPKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:10:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYGXPKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:10:42 -0400
Message-ID: <4888959D.6090907@redhat.com>
Date: Thu, 24 Jul 2008 10:45:49 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <488854DB.60307@redhat.com>	<20080724193457S.fujita.tomonori@lab.ntt.co.jp>	<20080724123755.GP31439@8bytes.org> <20080724223309C.fujita.tomonori@lab.ntt.co.jp> <4888925E.8050504@redhat.com>
In-Reply-To: <4888925E.8050504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>  
>>
>> Yeah, I'm not against fixing IOMMUs to make alloc_consistent return
>> the reqeuested size aligned memory. My point is that it's not likely
>> to fix anything. Even with the patch, we hit the above problem because
>> as I explained, the root cause of the problem is the boundary issue;
>> we need to fix pci-dma.c
>>
>>   
>
> Sorry, I misquoted code up there and was looking for a clear example 
> of where this would happen.  The issue I'm trying to resolve didn't 
> happen on the skge -- it was just a convenient piece of code to 
> examine and point out ;)
>

Here's a case where USB has problems:

 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000f57f6800 (reserved)
 BIOS-e820: 00000000f57f6800 - 00000000f5800000 (ACPI data)
 BIOS-e820: 00000000f5800000 - 00000000fdc00000 (reserved)
 BIOS-e820: 00000000fdc00000 - 00000000fdc01000 (reserved)
 BIOS-e820: 00000000fdc10000 - 00000000fdc01000 (reserved)
 BIOS-e820: 00000000fdc20000 - 00000000fdc01000 (reserved)
 BIOS-e820: 00000000fdc30000 - 00000000fdc01000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
 BIOS-e820: 00000000fec20000 - 00000000fec30000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000fee10000 - 00000000ff800000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000017fffff000 (usable)

I haven't tracked down what pci_alloc_consistent went wrong in 
usb-storage yet ... it seemed irrelevant because GART was broken.

P.
