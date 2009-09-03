Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZICSF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZICSF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZICSFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:05:25 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:58716 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbZICSFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=mfWJIr2vL4pCB8fsuZdAihu+kLd+qBuDCbXZIK7FiM9KMjhtsON+3iApe7Tai9b0Y8
         TiX1zbQi//12zKU44AqEJuQjeFCtWQzzw0/YIpDvqBGnfJkYx5L9mldApSwzbeARMHVE
         vmZqOOfYLoAXQi3F3zAAL23+G8iQemjPQ+5q4=
MIME-Version: 1.0
In-Reply-To: <1251996915.22485.26.camel@pc1117.cambridge.arm.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com> 
	<1251956140-5499-5-git-send-email-lrodriguez@atheros.com> 
	<1251996915.22485.26.camel@pc1117.cambridge.arm.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 3 Sep 2009 11:05:07 -0700
X-Google-Sender-Auth: e7e5283132f0c7b1
Message-ID: <43e72e890909031105l347002a7me760daf10ff2caeb@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] kmemleak: fix sparse warning over overshadowed 
	flags
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 9:55 AM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> On Thu, 2009-09-03 at 01:35 -0400, Luis R. Rodriguez wrote:
>> This fixes this sparse warning:
>> mm/kmemleak.c:512:31: warning: symbol 'flags' shadows an earlier one
>> mm/kmemleak.c:448:23: originally declared here
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  mm/kmemleak.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
>> index 58c07b1..24e7a84 100644
>> --- a/mm/kmemleak.c
>> +++ b/mm/kmemleak.c
>> @@ -509,14 +509,14 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
>>        * random memory blocks.
>>        */
>>       if (node != &object->tree_node) {
>> -             unsigned long flags;
>> +             unsigned long flags_object;
>>
>>               kmemleak_stop("Cannot insert 0x%lx into the object search tree "
>>                             "(already existing)\n", ptr);
>>               object = lookup_object(ptr, 1);
>> -             spin_lock_irqsave(&object->lock, flags);
>> +             spin_lock_irqsave(&object->lock, flags_object);
>>               dump_object_info(object);
>> -             spin_unlock_irqrestore(&object->lock, flags);
>> +             spin_unlock_irqrestore(&object->lock, flags_object);
>
> As Pekka said, we only need spin_lock() variant here as the interrupts
> are already disabled.

OK will respin thanks.

  Luis
