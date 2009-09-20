Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbZITSBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbZITSBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZITSBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:01:52 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:44138 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbZITSBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ey4ddPkGV/5StOTPuvzfe1pmiuCqYhKT59DIHOXdKaMawW0WgtJiN6ztPYaMdOv6/G
         5VWzvDgdL4ozlJFHPZrqLloG7/jPnfzo9DsNHXd4CRd15QBdQBvwHauXwH3SDZZOiO20
         i+zXSglb4YK8y9FfGCtzZM5q+kNDX9VVYlOlc=
MIME-Version: 1.0
In-Reply-To: <20090920175803.GB23736@elte.hu>
References: <20090915080953.GA24958@elte.hu> <20090920072210.GA23787@elte.hu>
	 <19f34abd0909201035t3157948amee532a3a5e96dbab@mail.gmail.com>
	 <alpine.DEB.2.00.0909202046460.7394@melkki.cs.helsinki.fi>
	 <20090920175803.GB23736@elte.hu>
Date: Sun, 20 Sep 2009 21:01:53 +0300
X-Google-Sender-Auth: d9f8895c8ab9e3d8
Message-ID: <84144f020909201101g2f1dbc22wd2497e8309800d7e@mail.gmail.com>
Subject: Re: shmem_fill_super(): WARNING: kmemcheck: Caught 32-bit read from 
	uninitialized memory
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, hugh.dickins@tiscali.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sun, Sep 20, 2009 at 8:58 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>> Date: Sun, 20 Sep 2009 20:43:35 +0300
>> Subject: [PATCH] shmem: initialize struct shmem_sb_info to zero
>>
>> Fixes the following kmemcheck false positive:
>>
>> [    0.337000] Total of 1 processors activated (3088.38 BogoMIPS).
>> [    0.352000] CPU0 attaching NULL sched-domain.
>> [    0.360000] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (9f8020fc)
>> [    0.361000] a44240820000000041f6998100000000000000000000000000000000ff030000
>> [    0.368000]  i i i i i i i i i i i i i i i i u u u u i i i i i i i i i i u u
>> [    0.375000]                                                          ^
>> [    0.376000]
>> [    0.377000] Pid: 9, comm: khelper Not tainted (2.6.31-tip #206) P4DC6
>> [    0.378000] EIP: 0060:[<810a3a95>] EFLAGS: 00010246 CPU: 0
>> [    0.379000] EIP is at shmem_fill_super+0xb5/0x120
>> [    0.380000] EAX: 00000000 EBX: 9f845400 ECX: 824042a4 EDX: 8199f641
>> [    0.381000] ESI: 9f8020c0 EDI: 9f845400 EBP: 9f81af68 ESP: 81cd6eec
>> [    0.382000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> [    0.383000] CR0: 8005003b CR2: 9f806200 CR3: 01ccd000 CR4: 000006d0
>> [    0.384000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>> [    0.385000] DR6: ffff4ff0 DR7: 00000400
>> [    0.386000]  [<810c25fc>] get_sb_nodev+0x3c/0x80
>> [    0.388000]  [<810a3514>] shmem_get_sb+0x14/0x20
>> [    0.390000]  [<810c207f>] vfs_kern_mount+0x4f/0x120
>> [    0.392000]  [<81b2849e>] init_tmpfs+0x7e/0xb0
>> [    0.394000]  [<81b11597>] do_basic_setup+0x17/0x30
>> [    0.396000]  [<81b11907>] kernel_init+0x57/0xa0
>> [    0.398000]  [<810039b7>] kernel_thread_helper+0x7/0x10
>> [    0.400000]  [<ffffffff>] 0xffffffff
>> [    0.402000] khelper used greatest stack depth: 2820 bytes left
>> [    0.407000] calling  init_mmap_min_addr+0x0/0x10 @ 1
>> [    0.408000] initcall init_mmap_min_addr+0x0/0x10 returned 0 after 0 usecs
>>
>> Reported-by: Ingo Molnar <mingo@elte.hu>
>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>> ---
>>  mm/shmem.c |    5 +----
>>  1 files changed, 1 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index d713239..a8f54f3 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2307,17 +2307,14 @@ static int shmem_fill_super(struct super_block *sb,
>>       int err = -ENOMEM;
>>
>>       /* Round up to L1_CACHE_BYTES to resist false sharing */
>> -     sbinfo = kmalloc(max((int)sizeof(struct shmem_sb_info),
>> +     sbinfo = kzalloc(max((int)sizeof(struct shmem_sb_info),
>>                               L1_CACHE_BYTES), GFP_KERNEL);
>>       if (!sbinfo)
>>               return -ENOMEM;
>>
>> -     sbinfo->max_blocks = 0;
>> -     sbinfo->max_inodes = 0;
>>       sbinfo->mode = S_IRWXUGO | S_ISVTX;
>>       sbinfo->uid = current_fsuid();
>>       sbinfo->gid = current_fsgid();
>> -     sbinfo->mpol = NULL;
>>       sb->s_fs_info = sbinfo;
>
> That looks like a step forward even without kmemcheck considered, right?

Oh, sure. It usually less error prone to use kzalloc() for infrequent
allocations such as this.

                        Pekka
