Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZIND3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZIND3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZIND3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:29:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbZIND3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:29:35 -0400
Message-ID: <4AADB887.103@redhat.com>
Date: Mon, 14 Sep 2009 11:29:11 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: cl@linux-foundation.org, penberg@cs.helsinki.fi, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT BISECT] BUG kmalloc-8192: Object already free from kmem_cache_destroy
References: <1252866835.13780.37.camel@dhcp231-106.rdu.redhat.com>	 <4AADB5EE.9090902@redhat.com> <1252898739.5793.4.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1252898739.5793.4.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2009 11:25 AM, Eric Paris wrote:
> On Mon, 2009-09-14 at 11:18 +0800, Danny Feng wrote:
>> diff --git a/mm/slub.c b/mm/slub.c
>> index b627675..40e12d5 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3337,8 +3337,8 @@ struct kmem_cache *kmem_cache_create(const char
>> *name, size_t size,
>>                                  goto err;
>>                          }
>>                          return s;
>> -               }
>> -               kfree(s);
>> +               } else
>> +                       kfree(s);
>>          }
>>          up_write(&slub_lock);
>>
>
> Doesn't the return inside the conditional take care of this?  I'll give
> it a try in the morning, but I don't see how this can solve the
> problem....
>
> -Eric
>
>
err, you're right... let me try to find why. It's strange, if SLUB_DEBUG 
is not set, sysfs_slab_remove is just to free kmem_cache s. So I think 
if SLUB_DEBUG is not set, we also have the same issue....
