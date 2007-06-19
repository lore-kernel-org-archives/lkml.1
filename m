Return-Path: <linux-kernel-owner+w=401wt.eu-S1758355AbXFSGeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355AbXFSGeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXFSGeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:34:08 -0400
Received: from mail.rialcom.ru ([80.71.245.247]:55551 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbXFSGeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:34:07 -0400
X-Greylist: delayed 1698 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 02:34:07 EDT
X-Spam-Flag: SKIP
X-Spam-Yversion: Spamooborona 1.7.0
Message-ID: <46777224.60201@clusterfs.com>
Date: Tue, 19 Jun 2007 10:05:24 +0400
From: Alex Tomas <alex@clusterfs.com>
Organization: Cluster Filesystems, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070302 Fedora/1.5.0.10-1.fc6 pango-text Thunderbird/1.5.0.10 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: cmm@us.ibm.com
CC: Dmitriy Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4:fix unexpected error from ext4_reserve_global
References: <20070614152927.GC6517@localhost.sw.ru> <1181950884.3808.16.camel@dyn9047017103.beaverton.ibm.com>
In-Reply-To: <1181950884.3808.16.camel@dyn9047017103.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK, of course.

thanks, Alex

Mingming Cao wrote:
> On Thu, 2007-06-14 at 19:29 +0400, Dmitriy Monakhov wrote:
>> I just cant belive my eyes then i saw this at the first time...
>> simple test: strace dd if=/dev/zero of=/mnt/file
>>
> Thanks for reporting it. 
> 
>> open("/dev/zero", O_RDONLY)             = 0
>> close(1)                                = 0
>> open("/mnt/test/file", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 1
>> read(0, "\0\0\0\0\0\0\0\0\0"..., 512) = 512
>> write(1, "\0\0\0\0\0\0\0\0"..., 512) = 512
>> read(0, "\0\0\0\0\0\0\0\0\0"..., 512) = 512
>> write(1, "\0\0\0\0\0\0\0\0"..., 512) = -1 ENOENT (No such fil
>> e or directory)
>>
>> This strange error returned from ext4_reserve_global().
>> It's just typo because:
>> a) In fact this is 100% ENOSPC situation
>> b) simular function ext4_reserve_local() returns -ENOSPC
>>
> I agree.
> 
> Patch is put in ext4 patch queue. Alex if you can Ack, that would be
> great.
> 
> 
> Thanks,
> 
> Mingming
>> Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
>> ---
>>  fs/ext4/balloc.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
>> index 4d7bfd2..43ae8f8 100644
>> --- a/fs/ext4/balloc.c
>> +++ b/fs/ext4/balloc.c
>> @@ -1920,7 +1920,7 @@ int ext4_reserve_global(struct super_block *sb, int blocks)
>>  {
>>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>>  	struct ext4_reservation_slot *rs;
>> -	int i, rc = -ENOENT;
>> +	int i, rc = -ENOSPC;
>>  	__u64 free = 0;
>>
>>  	rs = sbi->s_reservation_slots;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


