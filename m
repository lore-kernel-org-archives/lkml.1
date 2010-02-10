Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab0BJVUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:20:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41280 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab0BJVUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:20:19 -0500
Message-ID: <4B7322E3.8090407@zytor.com>
Date: Wed, 10 Feb 2010 13:19:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 09/35] x86: print out for RAM buffer
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>	<1265743966-17065-10-git-send-email-yinghai@kernel.org> <20100209115213.dc85e4a5.akpm@linux-foundation.org>
In-Reply-To: <20100209115213.dc85e4a5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 11:52 AM, Andrew Morton wrote:
>>
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index a966b75..dfb1689 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -1429,6 +1429,9 @@ void __init e820_reserve_resources_late(void)
>>  			end = MAX_RESOURCE_SIZE;
>>  		if (start >= end)
>>  			continue;
>> +		printk(KERN_DEBUG "reserve RAM buffer: %016Lx - %016Lx ",
>> +			       (unsigned long long) start,
>> +			       (unsigned long long) end);
>>  		reserve_region_with_split(&iomem_resource, start, end,
>>  					  "RAM buffer");
>>  	}
> 
> The typecasts for printing u64's are unneeded within x86 code.  In fact
> I think they're now unneeded on all architectures.
> 

... not to mention that the proper printf format for long long is "ll".
 "L" is used for long double, although a lot of implementations treat
"L" and "ll" the same.

And yes, it's a nitpick.

	-hpa
