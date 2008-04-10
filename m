Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYDJLnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYDJLnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 07:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYDJLmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 07:42:55 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:39940 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbYDJLmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 07:42:55 -0400
Message-ID: <47FDFD3C.1030708@tiscali.nl>
Date: Thu, 10 Apr 2008 13:42:52 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pagewalk: don't pte_unmap(NULL) in walk_pte_range()
References: <47FC95AD.1070907@tiscali.nl> <87zls3qhop.fsf@saeurebad.de>
In-Reply-To: <87zls3qhop.fsf@saeurebad.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Hi,
> 
> Roel Kluin <12o3l@tiscali.nl> writes:
> 
>> This is right isn't it?
>> ---
>> Don't pte_unmap a NULL pointer, but the previous.
> 
> Which NULL pointer?
> 
>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>> ---
>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>> index 1cf1417..6615f0b 100644
>> --- a/mm/pagewalk.c
>> +++ b/mm/pagewalk.c
>> @@ -15,7 +15,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  		       break;
>>  	} while (pte++, addr += PAGE_SIZE, addr != end);
>>  
>> -	pte_unmap(pte);
>> +	pte_unmap(pte - 1);
>>  	return err;
>>  }
> 
> This does not make any sense to me.

you are right, please ignore.

> 	Hannes

thanks,

Roel
