Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249Ab0A0OUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0A0OUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230Ab0A0OT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:19:59 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:52459 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab0A0OT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:19:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LRG5OU/w+ljy45gJ2TkOtSroHYqSfKWfsZkxF36kUo0/k7AK85wGcVyus+RbLIM+yz
         ZxpBsL8DJ5odphr4FvPVmyMliYUZtygRjf6tZ3T3/Oy1PowDcHwMdVirVlXd6BpGEvpq
         PnIHjL+ElbH88QadQezYh6TZBFch8iflOYYiQ=
Message-ID: <4B604B86.9040307@gmail.com>
Date: Wed, 27 Jan 2010 22:19:50 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Yan, Zheng " <yanzheng@21cn.com>
CC: chris.mason@oracle.com, jbacik@redhat.com, jens.axboe@oracle.com,
       linux-btrfs <linux-btrfs@vger.kernel.org>, linux-kernel@vger.kernel.org,
       strongzgy@gmail.com
Subject: Re: [PATCH]btrfs: avoid comparing with NULL pointer
References: <4B5FDCD1.8060806@gmail.com> <3d0408631001270000w49fc9100yb1e3b59df2e032e9@mail.gmail.com>
In-Reply-To: <3d0408631001270000w49fc9100yb1e3b59df2e032e9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2010年01月27日 16:00, Yan, Zheng 写道:
> 2010/1/27 Liuwenyi<qingshenlwy@gmail.com>:
>    
>> In this patch, I adjust the seqence of if-conditions.
>> It will assess the page->private situation.
>> First, we make sure the page->private is not null.
>> And then, we can do some with this page->private.
>>
>> ---
>> Signed-off-by: Liuwenyi<qingshenlwy@gmail.com>
>> Cc: Chris Mason<chris.mason@oracle.com>
>> Cc: Yan Zheng<zheng.yan@oracle.com>
>> Cc: Josef Bacik<jbacik@redhat.com>
>> Cc: Jens Axboe<jens.axboe@oracle.com>
>> Cc: linux-btrfs@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>>
>> ---
>> fs/btrfs/disk-io.c | 4 ++--
>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 009e3bd..a300dca 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -1407,11 +1407,11 @@ static int bio_ready_for_csum(struct bio *bio)
>>
>> bio_for_each_segment(bvec, bio, i) {
>> page = bvec->bv_page;
>> - if (page->private == EXTENT_PAGE_PRIVATE) {
>> + if (!page->private) {
>> length += bvec->bv_len;
>> continue;
>> }
>> - if (!page->private) {
>> + if (page->private == EXTENT_PAGE_PRIVATE) {
>> length += bvec->bv_len;
>> continue;
>> }
>> --
>>      
> Why do you want to do this? The code is perfect safe even
> page->private is NULL. Furthermore, your patch is malformed.
>
> Yan, Zheng
>    
Yes, I agree with you, this code is safe.
But I think we should check whether the pointer is available first.
It is unnecessary judge the "(page->private == EXTENT_PAGE_PRIVATE)"
while page->private is null.


---
Best Regards,
Liuwenyi
2010-1-27

