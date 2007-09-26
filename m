Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbXIZITV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbXIZITV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXIZITL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:19:11 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:42427 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbXIZITJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:19:09 -0400
Message-ID: <46FA15C7.9020603@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2007 13:48:15 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       kamezawa.hiroyu@jp.fujitsu.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc8-mm1 - powerpc memory hotplug link failure
References: <20070925014625.3cd5f896.akpm@linux-foundation.org> <46F968C2.7080900@linux.vnet.ibm.com> <1190757715.13955.40.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1190757715.13955.40.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty wrote:
> On Wed, 2007-09-26 at 01:30 +0530, Kamalesh Babulal wrote:
>> Hi Andrew,
>>
>> The 2.6.23-rc8-mm1 kernel linking fails on the powerpc (P5+) box
>>
>>   CC      init/version.o
>>   LD      init/built-in.o
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o: In function `memory_block_action':
>> /root/scrap/linux-2.6.23-rc8/drivers/base/memory.c:188: undefined reference to `.remove_memory'
>> make: *** [.tmp_vmlinux1] Error 1
>>
> 
> I ran into the same thing earlier. Here is the fix I made.
> 
> Thanks,
> Badari
> 
> Memory hotplug remove is currently supported only on IA64
> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> 
> Index: linux-2.6.23-rc8/mm/Kconfig
> ===================================================================
> --- linux-2.6.23-rc8.orig/mm/Kconfig	2007-09-25 14:44:03.000000000 -0700
> +++ linux-2.6.23-rc8/mm/Kconfig	2007-09-25 14:44:48.000000000 -0700
> @@ -143,6 +143,7 @@ config MEMORY_HOTREMOVE
>  	bool "Allow for memory hot remove"
>  	depends on MEMORY_HOTPLUG
>  	depends on MIGRATION
> +	depends on (IA64)
> 
>  # Heavily threaded applications may benefit from splitting the mm-wide
>  # page_table_lock, so that faults on different parts of the user address
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hi Badari,

Thanks, your patch fixed the problem.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
