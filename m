Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZLHKKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZLHKKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZLHKKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:10:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZLHKKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:10:41 -0500
Message-ID: <4B1E26CC.1090009@redhat.com>
Date: Tue, 08 Dec 2009 18:13:32 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [Patch] fs: remove a useless BUG()
References: <20091201023714.3863.92566.sendpatchset@localhost.localdomain> <20091202141458.66b5f069.akpm@linux-foundation.org>
In-Reply-To: <20091202141458.66b5f069.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 30 Nov 2009 21:34:14 -0500
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> This BUG() is suspicious, it makes its following statements
>> unreachable, and it seems to be useless, since the caller
>> of this function already handles the failure properly.
>> Remove it.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Jens Axboe <jens.axboe@oracle.com>
>> Cc: Nick Piggin <npiggin@suse.de>
>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>>
>> ---
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 6fa5302..ac111d7 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -1041,7 +1041,6 @@ grow_dev_page(struct block_device *bdev, sector_t block,
>>  	return page;
>>  
>>  failed:
>> -	BUG();
>>  	unlock_page(page);
>>  	page_cache_release(page);
>>  	return NULL;
> 
> The caller doesn't handle this properly.  If we return zero here,
> grow_buffers() will say sheesh and will retry and the kernel goes into
> an infinite retry loop.
> 
> If there is a blockdev page which is sitting in pagecache and for some
> reason it has buffers and we cannot release them, we're kind of stuck
> and don't know what to do.  Going BUG() is a decent thing to do here.
> 
> I don't think I've ever seen a report of the BUG triggering.  It could
> happen as a result of memory corruption or a missed bh_put() or
> whatever.
> 

Oh, good explanation!

> I think a better patch would be to remove the
> unlock_page()/page_cache_release(), add a comment (culled from the
> above) and leave the BUG() there.
> 

Ok, I will prepare a patch tomorrow.

Thanks!


