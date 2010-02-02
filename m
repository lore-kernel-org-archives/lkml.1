Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab0BBBhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:37:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57095 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0BBBhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:37:54 -0500
Message-ID: <4B6781D3.6090904@zytor.com>
Date: Mon, 01 Feb 2010 17:37:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] Generic page_is_ram: use __weak
References: <tip-e52730071567ec5b6f57e21d6693b112e01e1d0e@git.kernel.org> <20100201172423.6803e898.akpm@linux-foundation.org>
In-Reply-To: <20100201172423.6803e898.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 05:24 PM, Andrew Morton wrote:
>>
>> diff --git a/kernel/resource.c b/kernel/resource.c
>> index b4d637a..e68cd74 100644
>> --- a/kernel/resource.c
>> +++ b/kernel/resource.c
>> @@ -305,7 +305,7 @@ static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
>>   * This generic page_is_ram() returns true if specified address is
>>   * registered as "System RAM" in iomem_resource list.
>>   */
>> -int __attribute__((weak)) page_is_ram(unsigned long pfn)
>> +int __weak page_is_ram(unsigned long pfn)
>>  {
>>  	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
>>  }
> 
> hm, it's strange to do this as two separate commits?
> 

You had it as a separate fix patch, and I generally don't want to fold
patches which have different authorship, especially if the original code
doesn't actually break anything.

> There was another fixlet:
> 
> From: Wu Fengguang <fengguang.wu@intel.com>
> 
> ioport.h didn't seem like the right place to declare page_is_ram().
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Yes, I have that one too.

	-hpa
