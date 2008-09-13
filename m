Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYIMLZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYIMLZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 07:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYIMLZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 07:25:01 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:26900 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYIMLZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 07:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ipCCpUq5paE/PRPLUDXz6s6STRCKAb+9Un+J9jR3Gy52T7PiaN2lU/8nrqiwfs6XLZ
         PeRJBMNprje9hG4Y9cpyGw+4bqA9e+zyB+Vof15wSoI9bEd5wVBkL7h0pLsFc+ga4HHU
         hWDAnzF56K/sfwapFqgKEojg5aRVeeEN4Z7P4=
Message-ID: <48CBA308.1070309@gmail.com>
Date: Sat, 13 Sep 2008 04:24:56 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [MTD] physmap.c: Add a dummy release function
References: <48CB5EA4.10907@gmail.com> <20080913104701.GF21603@xi.wantstofly.org>
In-Reply-To: <20080913104701.GF21603@xi.wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek wrote:
> On Fri, Sep 12, 2008 at 11:33:08PM -0700, Zev Weiss wrote:
> 
>> Adding a dummy release function to the physmap device so as to silence a log
>> warning on initialization.
>>
>> Signed-off-by: Zev Weiss <zevweiss@gmail.com>
>> ---
>>   drivers/mtd/maps/physmap.c |    5 +++++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
>> index 49e2039..73a8d3c 100644
>> --- a/drivers/mtd/maps/physmap.c
>> +++ b/drivers/mtd/maps/physmap.c
>> @@ -277,11 +277,16 @@ static struct resource physmap_flash_resource = {
>>   	.flags		= IORESOURCE_MEM,
>>   };
>>
>> +static void physmap_dummy_release(struct device *dev)
>> +{
>> +}
>> +
>>   static struct platform_device physmap_flash = {
>>   	.name		= "physmap-flash",
>>   	.id		= 0,
>>   	.dev		= {
>>   		.platform_data	= &physmap_flash_data,
>> +		.release	= &physmap_dummy_release,
>>   	},
>>   	.num_resources	= 1,
>>   	.resource	= &physmap_flash_resource,
> 
> Isn't that just papering over the issue?
> 

Quite possibly -- is there something it *should* be doing?  (I don't mean to suggest 
I particularly think there's not, honest question.)  I had figured it was a minor 
oversight and the warning was sort of a "spurious" one, though I'm admittedly well 
out of my depth here, so perhaps I shouldn't be doing such things (though I suppose 
it's one way to learn).
