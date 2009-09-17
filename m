Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZIQI4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZIQI4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZIQI4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:56:19 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:37914 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbZIQI4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:56:18 -0400
Message-ID: <4AB1F9B0.10103@monstr.eu>
Date: Thu, 17 Sep 2009 10:56:16 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: =?us-ascii?Q?=5Bmicroblaze=2Duclinux=5D=20Re=3A=20=5BPATCH=5D=20Actually=20show=20KiB=20rather=20than=20pages=20in=20=22Freeing=20initrd
References: <20090915165037.GA23702@csclub.uwaterloo.ca> <4AB1E78D.3070007@snapgear.com>
In-Reply-To: <4AB1E78D.3070007@snapgear.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Greg Ungerer wrote:
> Hi Lennart,
> 
> Lennart Sorensen wrote:
>> Fix "Freeing initrd memory:" message on h3800, m68knommu and microblaze
>> to show kilobytes as claimed rather than number of pages.
>>
>> Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
> 
> Looks ok to me. I can take and push the m68knommu part separately.
> Or if Andrew wants to take it all as one, here is an:
> 
> Acked-by: Greg Ungerer <gerg@uclinux.org>

As Greg wrote. It will be the best to push it separately. IMHO it
will be faster. It is up to you. If you want to add it to microblaze
branch please send only patch for microblaze.

If not.

Acked-by: Michal Simek <monstr@monstr.eu>


Thanks,
Michal



> 
> 
> Regards
> Greg
> 
> 
>> diff --git a/arch/h8300/mm/init.c b/arch/h8300/mm/init.c
>> index 9942f24..3342f49 100644
>> --- a/arch/h8300/mm/init.c
>> +++ b/arch/h8300/mm/init.c
>> @@ -170,7 +170,7 @@ void free_initrd_mem(unsigned long start, unsigned
>> long end)
>>          totalram_pages++;
>>          pages++;
>>      }
>> -    printk ("Freeing initrd memory: %dk freed\n", pages);
>> +    printk ("Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE
>> / 1024));
>>  }
>>  #endif
>>  
>> diff --git a/arch/m68knommu/mm/init.c b/arch/m68knommu/mm/init.c
>> index b1703c6..f3236d0 100644
>> --- a/arch/m68knommu/mm/init.c
>> +++ b/arch/m68knommu/mm/init.c
>> @@ -162,7 +162,7 @@ void free_initrd_mem(unsigned long start, unsigned
>> long end)
>>          totalram_pages++;
>>          pages++;
>>      }
>> -    printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
>> +    printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages *
>> (PAGE_SIZE / 1024));
>>  }
>>  #endif
>>  
>> diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
>> index f207f1a..ed5f96b 100644
>> --- a/arch/microblaze/mm/init.c
>> +++ b/arch/microblaze/mm/init.c
>> @@ -180,7 +180,7 @@ void free_initrd_mem(unsigned long start, unsigned
>> long end)
>>          totalram_pages++;
>>          pages++;
>>      }
>> -    printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
>> +    printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages *
>> (PAGE_SIZE / 1024));
>>  }
>>  #endif
>>  
>>
> 

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
