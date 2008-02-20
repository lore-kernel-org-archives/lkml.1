Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYBTFQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYBTFQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYBTFQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:16:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:53967 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbYBTFQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:16:27 -0500
Cc: sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Message-Id: <7A7ECF09-E547-4C04-A388-C3E8755478DD@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20080219.204525.193731674.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] [LMB]: Fix lmb_add_region if region should be added at the head
Date: Tue, 19 Feb 2008 23:16:18 -0600
References: <Pine.LNX.4.64.0802192227170.2215@blarg.am.freescale.net> <20080219.204525.193731674.davem@davemloft.net>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 19, 2008, at 10:45 PM, David Miller wrote:

> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Tue, 19 Feb 2008 22:27:48 -0600 (CST)
>
>> We introduced a bug in fixing lmb_add_region to handle an initial
>> region being non-zero.  Before that fix it was impossible to insert
>> a region at the head of the list since the first region always  
>> started
>> at zero.
>>
>> Now that its possible for the first region to be non-zero we need to
>> check to see if the new region should be added at the head and if so
>> actually add it.
>>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ...
>> @@ -184,6 +184,11 @@ static long __init lmb_add_region(struct  
>> lmb_region *rgn, u64 base, u64 size)
>> 			break;
>> 		}
>> 	}
>> +
>> +	if (base < rgn->region[0].base) {
>> +		rgn->region[0].base = base;
>> +		rgn->region[0].size = size;
>> +	}
>> 	rgn->cnt++;
>>
>> 	return 0;
>
> Are you sure this is sufficient?
>
> It seems to me, to handle this properly, you'll need to handle
> the case where the lower addressed entry you are inserting is
> not contiguous with the existing entry 0.
>
> Therefore, you need to move all existing entries up a slot,
> then you can set the 0 entry to 'base' and 'size'.

The for loop above the code I added will move all the existing slots  
up one.  Its just the tail cleanup we are missing.

- k
