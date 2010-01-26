Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953Ab0AZBeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0AZBeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248Ab0AZBep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:34:45 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:45819 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab0AZBep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:34:45 -0500
Message-ID: <4B5E46B0.80300@cnu.edu>
Date: Mon, 25 Jan 2010 20:34:40 -0500
From: James Kosin <james.kosin.04@cnu.edu>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/24] drivers/block/floppy.c: Add function is_ready_state
References: <e5jMK-25X-3@gated-at.bofh.it> <e5jMM-25X-51@gated-at.bofh.it>	 <4B5B32AF.1010509@cox.net> <1264279618.30778.34.camel@Joe-Laptop.home>
In-Reply-To: <1264279618.30778.34.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/2010 3:46 PM, Joe Perches wrote:
> On Sat, 2010-01-23 at 12:32 -0500, James Kosin wrote:
>    
>> On 1/22/2010 12:00 AM, Joe Perches wrote:
>>      
>>> Used a couple of times, might simplify the code a bit.
>>>
>>> Signed-off-by: Joe Perches<joe@perches.com>
>>> ---
>>>    drivers/block/floppy.c |   19 +++++++++++++++----
>>>    1 files changed, 15 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
>>> index 2f6ed78..fd56b26 100644
>>> --- a/drivers/block/floppy.c
>>> +++ b/drivers/block/floppy.c
>>> @@ -782,6 +782,12 @@ static inline int is_selected(int dor, int unit)
>>>    	return ((dor&   (0x10<<   unit))&&   (dor&   3) == unit);
>>>    }
>>>
>>> +static bool is_ready_state(int status)
>>> +{
>>> +	int state = status&   (STATUS_READY | STATUS_DIR | STATUS_DMA);
>>> +	return state == STATUS_READY;
>>> +}
>>> +
>>>        
>> This should probably be simplified to:
>>
>> static bool is_ready_state(int status)
>> {
>> 	return ((state&  STATUS_READY) == STATUS_READY);
>> }
>>      
> Certainly not.
> That wouldn't be the same code.
>
> include/linux/fdreg.h:#define STATUS_DMA	0x20		/* 0- DMA mode */
> include/linux/fdreg.h:#define STATUS_DIR	0x40		/* 0- cpu->fdc */
> include/linux/fdreg.h:#define STATUS_READY	0x80		/* Data reg ready */
>
>
>    
   Sorry,

That probably should have been:
         return ((status & STATUS_READY) == STATUS_READY);

James
