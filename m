Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZC0IYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZC0IYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 04:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZC0IXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 04:23:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:49482 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbZC0IXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 04:23:48 -0400
Message-ID: <49CC8E41.9020403@suse.de>
Date: Fri, 27 Mar 2009 16:28:49 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reiserfs: select CRC32 and BITREVERSE for REISERFS_FS
 Kconfig entry
References: <49CA629E.7040701@suse.de> <49CA64BE.2090804@oracle.com>
In-Reply-To: <49CA64BE.2090804@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Randy Dunlap Wrote:
> Coly Li wrote:
>> In patch fs-reiserfs-return-f_fsid-for-statfs2-v2.patch (from mmotm), crc32_le()
>> is referenced. If reiserfs is compiled into kernel and crc32_le() is compiled as
>> kernel module, there might be a compiling error as:
>>     fs/built-in.o: In function `reiserfs_statfs':
>>     super.c:(.text+0x7332b): undefined reference to `crc32_le'
>>     super.c:(.text+0x7333f): undefined reference to `crc32_le'
>> This patch select CRC32 and BITREVERSE for REISERFS_FS Kconfig entry, which
>> indicates compiling crc32_le() into kernel.
>>
>> Thanks to Randy Dunlap for pointing out this error and providing helpful solution.
>>
>> Signed-off-by: Coly Li <coly.li@suse.de>
>> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Thanks.
> 

Hi Randy,

I just find only select CRC32 is enough, because crc32 code in sequence selects
BITREVERSE in lib/Kconfig. I verified it on my x86_64 machine.

BTW, in mmotm, only fs-reiserfs-return-f_fsid-for-statfs2-v2.patch of the
return-f_fsid-for-statfs2 patch serial which calls crc32_le(). Therefore I will
not update other patches and only merge the modification of fs/reiserfs/Kconfig
to fs-reiserfs-return-f_fsid-for-statfs2-v3.patch. I will Cc you as well.

Thanks.

>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  fs/reiserfs/Kconfig |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
>> index 949b8c6..9712bea 100644
>> --- a/fs/reiserfs/Kconfig
>> +++ b/fs/reiserfs/Kconfig
>> @@ -1,5 +1,7 @@
>>  config REISERFS_FS
>>  	tristate "Reiserfs support"
>> +	select CRC32
>> +	select BITREVERSE
>>  	help
>>  	  Stores not just filenames but the files themselves in a balanced
>>  	  tree.  Uses journalling.
> 
> 

-- 
Coly Li
SuSE Labs
