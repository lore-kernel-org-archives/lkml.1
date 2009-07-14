Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZGNPAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZGNPAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZGNPAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:00:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43133 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbZGNPAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:00:38 -0400
Message-ID: <4A5C9D8E.1010809@redhat.com>
Date: Tue, 14 Jul 2009 23:00:30 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: sysfs fix mismatched queue_var_{store,show} in
 	64bit kernel
References: <1247572618-24073-1-git-send-email-dfeng@redhat.com> <2375c9f90907140653n3d689416jac8fbff43237fc15@mail.gmail.com>
In-Reply-To: <2375c9f90907140653n3d689416jac8fbff43237fc15@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2009 09:53 PM, Américo Wang wrote:
> On Tue, Jul 14, 2009 at 7:56 PM, Xiaotian Feng<dfeng@redhat.com> wrote:
>> In blk-sysfs.c, queue_var_store uses unsigned long to store data,
>> but queue_var_show uses unsigned int to show data. This causes,
>>
>>        # echo 70000000000 > /sys/block/<dev>/queue/read_ahead_kb
>>        # cat /sys/block/<dev>/queue/read_ahead_kb => get wrong value
>>
>> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
>> ---
>>  block/blk-sysfs.c |   13 +++++++------
>>  1 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index b1cd040..e177eb3 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -16,9 +16,9 @@ struct queue_sysfs_entry {
>>  };
>>
>>  static ssize_t
>> -queue_var_show(unsigned int var, char *page)
>> +queue_var_show(unsigned long var, char *page)
>>  {
>> -       return sprintf(page, "%d\n", var);
>> +       return sprintf(page, "lu\n", var);
>
>
> %lu
>
My mistake, correct in V2. Thank you.
>>   }
>>
>>   static ssize_t
>> @@ -77,7 +77,8 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
>>
>>   static ssize_t queue_ra_show(struct request_queue *q, char *page)
>>   {
>> -       int ra_kb = q->backing_dev_info.ra_pages<<  (PAGE_CACHE_SHIFT - 10);
>> +       unsigned long ra_kb = q->backing_dev_info.ra_pages<<
>> +                                       (PAGE_CACHE_SHIFT - 10);
>
>
> It looks like that your email client replaces tab's with spaces.
I use git send-email, and in my thunderbird, they're all tabs...
