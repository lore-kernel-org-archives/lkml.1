Return-Path: <linux-kernel-owner+w=401wt.eu-S1751133AbYIML1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbYIML1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 07:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYIML1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 07:27:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:23916 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYIML1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 07:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BkMdXXTga7f5dyL5KGojyXEz+HWZgDmDVfV5dR1HsdH8jsO1UI6uSd/DXKivX/NlQ2
         GrxyXKn2H/C5rk6vQHU8pz6KzLJMig5t0rIMFalBafSbHjcMJlkJdKxfAfzz6vOurbrC
         pUD35Fi+SWnpe+HF4OY3qLe4boY/nORb9iIvk=
Message-ID: <48CBA3A4.7020308@gmail.com>
Date: Sat, 13 Sep 2008 04:27:32 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [MTD] physmap.c: Check return of platform_device_register()
References: <48CB5E9A.4010000@gmail.com> <20080913104542.GD21603@xi.wantstofly.org>
In-Reply-To: <20080913104542.GD21603@xi.wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek wrote:
> On Fri, Sep 12, 2008 at 11:32:58PM -0700, Zev Weiss wrote:
> 
>> The PHYSMAP_COMPAT code had been ignoring the return value of
>> platform_device_register() in the physmap_init() function.
>>
>> Signed-off-by: Zev Weiss <zevweiss@gmail.com>
>> ---
>>   drivers/mtd/maps/physmap.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
>> index 42d844f..6fba0d4 100644
>> --- a/drivers/mtd/maps/physmap.c
>> +++ b/drivers/mtd/maps/physmap.c
>> @@ -312,7 +312,7 @@ static int __init physmap_init(void)
>>   	err = platform_driver_register(&physmap_flash_driver);
>>   #ifdef PHYSMAP_COMPAT
>>   	if (err == 0)
>> -		platform_device_register(&physmap_flash);
>> +		err = platform_device_register(&physmap_flash);
>>   #endif
> 
> I don't think you want the registration of the physmap driver to fail
> if the compat platform device fails to register.
> 
> One reason that the compat platform device can fail to register can be
> that there is already a non-compat platform device for the compat flash
> chip, and in that case I don't think you want to fail the driver init
> (while leaving the physmap_flash_driver registered, too!).
> 

Chalk another one up to ignorance on my part...sounds like a nak all 'round.
