Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZG2Glb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZG2Glb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZG2Gla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:41:30 -0400
Received: from smtpauth.net4india.com ([202.71.129.41]:57148 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZG2Gla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:41:30 -0400
Message-ID: <4A6FEF5F.3050701@xenontk.org>
Date: Wed, 29 Jul 2009 12:12:39 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Mozilla/5.0 (X11; X; Linux x86_64; rv:1.9.1b3pre) Gecko/20090513 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: torvalds@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, yinghai@kernel.org
Subject: Re: [PATCH v2] Remove Spurious PnP Memory Reserved Warning
References: <1248505976-4952-1-BlackWidow-davidjon@xenontk.org>	<1248753983-4334-1-BlackWidow-davidjon@xenontk.org> <20090728093137.52575d8c@jbarnes-g45>
In-Reply-To: <20090728093137.52575d8c@jbarnes-g45>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2009 10:01 PM, Jesse Barnes wrote:
> On Tue, 28 Jul 2009 09:36:23 +0530
> David John <davidjon@xenontk.org> wrote:
> 
>> Remove unnecessary complaints by the PnP sub-system about memory
>> ranges being reserved.
>>
>> Signed-off-by: David John <davidjon@xenontk.org>
>>
>> diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
>> index 59b9092..84ee297 100644
>> --- a/drivers/pnp/system.c
>> +++ b/drivers/pnp/system.c
>> @@ -48,10 +48,11 @@ static void reserve_range(struct pnp_dev *dev,
>> resource_size_t start,
>>  	 * example do reserve stuff they know about too, so we may
>> well
>>  	 * have double reservations.
>>  	 */
>> -	dev_info(&dev->dev, "%s range 0x%llx-0x%llx %s reserved\n",
>> -		port ? "ioport" : "iomem",
>> -		(unsigned long long) start, (unsigned long long) end,
>> -		res ? "has been" : "could not be");
>> +	if (res) {
>> +		dev_info(&dev->dev, "%s range 0x%llx-0x%llx has been
>> "
>> +			 "reserved\n",	port ? "ioport" :
>> "iomem",
>> +			(unsigned long long) start, (unsigned long
>> long) end);
>> +	}
>>  }
>>  
>>  static void reserve_resources_of_dev(struct pnp_dev *dev)
> 
> I'm inclined to keep the message, since it's just a dev_info and does
> provide interesting info sometimes.  So unless Linus wants to kill
> it...
> 
> Jesse
> 

This patch doesn't remove the message, it just removes the 'could not reserve' messages,
which would be useful if they are actual errors, but they are not. It's pretty silly if
the left hand doesn't know what the right is doing... However in the interest of keeping
the code as is, I guess the patch isn't all that important.

Regards,
David.
