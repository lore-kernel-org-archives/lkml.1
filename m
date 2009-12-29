Return-Path: <linux-kernel-owner+w=401wt.eu-S1751575AbZL2Uvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbZL2Uvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbZL2Uvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:51:35 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37707 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZL2Uvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:51:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kbPgBClI7qOuSgfpW86gaJRVWoaacFZRCZ7+yLpSg1XL9MMvheeescJsHVxpudkcR7
         KxbyYO1cGyxvIvr+3wIDYZoVlctmOg/G+EfQkeyvDZ+W79USMBl9Lmq/rFm3FSE7Ztbu
         c6ymtnSnlClejhxfCPNLbnQUCwqAskacKLzRk=
MIME-Version: 1.0
In-Reply-To: <4B3A6BA5.60103@gmail.com>
References: <cover.1260663000.git.re.emese@gmail.com>
	 <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com>
	 <84144f020912250331h23b8b724v73cf70c384d385ec@mail.gmail.com>
	 <4B355AEF.3060508@gmail.com>
	 <alpine.DEB.2.00.0912281244400.12772@chino.kir.corp.google.com>
	 <4B3A6BA5.60103@gmail.com>
Date: Tue, 29 Dec 2009 22:51:33 +0200
X-Google-Sender-Auth: 90880698efa62467
Message-ID: <84144f020912291251n4c8ceb2akbb55d3bc4a0f9329@mail.gmail.com>
Subject: Re: [PATCH 3/4] Constify struct kset_uevent_ops for 
	2.6.32-git-053fe57ac v2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Emese Revfy <re.emese@gmail.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emese,

On Tue, Dec 29, 2009 at 10:50 PM, Emese Revfy <re.emese@gmail.com> wrote:
> David Rientjes wrote:
>> On Sat, 26 Dec 2009, Emese Revfy wrote:
>>
>>>>> diff --git a/mm/slub.c b/mm/slub.c
>>>>> index 4996fc7..fb63aca 100644
>>>>> --- a/mm/slub.c
>>>>> +++ b/mm/slub.c
>>>>> @@ -4522,7 +4522,7 @@ static int uevent_filter(struct kset *kset, struct kobject *kobj)
>>>>>        return 0;
>>>>>  }
>>>>>
>>>>> -static struct kset_uevent_ops slab_uevent_ops = {
>>>>> +static const struct kset_uevent_ops slab_uevent_ops = {
>>>>>        .filter = uevent_filter,
>>>>>  };
>>>>   CC      mm/slub.o
>>>> mm/slub.c: In function 'slab_sysfs_init':
>>>> mm/slub.c:4679: warning: passing argument 2 of 'kset_create_and_add'
>>>> discards qualifiers from pointer target type
>>>> include/linux/kobject.h:164: note: expected 'struct kset_uevent_ops *'
>>>> but argument is of type 'const struct kset_uevent_ops *'
>>>>
>>>> Hmm?
>>>>
>>> I double checked both the declaration and definitions of the affected
>>> function/structure and they are consistently const here.
>>> Can you tell me what patch/tree combination you encountered this warning with?
>>> Thanks, Emese
>>>
>>
>> The warning emitted by gcc is pretty explicit; the second formal of
>> kset_create_and_add() takes a 'struct kset_uevent_ops *' type while you're
>> now passing 'const struct kset_uevent_ops *' as the result of your change.
>> That said, kset_create() could probably be modified with the const
>> qualifier, but that's outside the scope of your patchset and would have to
>> be proposed seperately.
>
> I see what you mean, this was part of [PATCH 1/4] that I forgot to CC to you.

Then you might as well fold everything in one patch and send it to
Andrew. I can't apply both in my tree and I don't want to apply
something that doesn't compile cleanly.

                         Pekka
