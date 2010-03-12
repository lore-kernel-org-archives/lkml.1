Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0CLEjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:39:41 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57490 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab0CLEjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:39:40 -0500
MIME-Version: 1.0
In-Reply-To: <20100312041518.GA31394@kroah.com>
References: <1268340652.2845.10.camel@edumazet-laptop> <20100312041518.GA31394@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 12 Mar 2010 05:39:23 +0100
Message-ID: <ac3eb2511003112039i7c2009a9gcadb760f128dab6c@mail.gmail.com>
Subject: Re: [PATCH] kobject: Fix kobject_set_name_vargs()
To: Greg KH <greg@kroah.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 05:15, Greg KH <greg@kroah.com> wrote:
> On Thu, Mar 11, 2010 at 09:50:52PM +0100, Eric Dumazet wrote:
>> In case of kvasprintf() failure, we can leak old kobject name.
>>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> ---
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index 8115eb1..1247c57 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>>               return 0;
>>
>>       kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
>> -     if (!kobj->name)
>> +     if (!kobj->name) {
>> +             kobj->name = old_name;
>>               return -ENOMEM;
>> +     }
>
> Are you sure?  I think we've been over this very thing many times in the
> past...
>
> Kay, I can't recall the issue here, can you?

I think we just lost attention to it, and never made a final decision.
There have been some issues, I also don't really remember.

I myself have an unsubmitted patch for this problem here since 9 months:
  http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kobj-leak.patch;hb=HEAD

Seems, we should start thinking about the problem again. And if we
decide to do nothing at least add a comment why we don't. :)

Thanks,
Kay
