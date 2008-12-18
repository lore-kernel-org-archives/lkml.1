Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752165AbYLRIld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbYLRIld (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 03:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYLRIlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 03:41:21 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:17741 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751297AbYLRIlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 03:41:20 -0500
Message-ID: <494A0CAC.2010700@panasas.com>
Date: Thu, 18 Dec 2008 10:41:16 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        open-osd <osd-dev@open-osd.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] exofs: super_operations and file_system_type
References: <4947BFAA.4030208@panasas.com> <4947C9D2.5080405@panasas.com> <20081217222255.GA6317@joi>
In-Reply-To: <20081217222255.GA6317@joi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2008 08:41:18.0352 (UTC) FILETIME=[65388100:01C960EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz wrote:
> On Tue, Dec 16, 2008 at 05:31:30PM +0200, Boaz Harrosh wrote:
>> This patch ties all operation vectors into a file system superblock
>> and registers the exofs file_system_type at module's load time.
>>
>> * The file system control block (AKA on-disk superblock) resides in
>>   an object with a special ID (defined in common.h).
>>   Information included in the file system control block is used to
>>   fill the in-memory superblock structure at mount time. This object
>>   is created before the file system is used by mkexofs.c It contains
>>   information such as:
>> 	- The file system's magic number
>> 	- The next inode number to be allocated
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> Some minor comments below.
> 

Thank you Marcin for your comments. They are all true and I will
fix them.

Just as a side note, most of your comments are on code inherited from
ext2. Though it is a good chance to fix them here.

>> ---
<snip>
>> +	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>> +	if (!sbi)
>> +		return -ENOMEM;
>> +	sb->s_fs_info = sbi;
>> +
>> +	/* use mount options to fill superblock */
>> +	sbi->s_dev = osduld_path_lookup(opts->dev_name);
>> +	if (IS_ERR(sbi->s_dev)) {
>> +		ret = PTR_ERR(sbi->s_dev);
>> +		sbi->s_dev = NULL;
>> +		goto free_sbi;
>> +	}
>> +
>> +	sbi->s_pid = opts->pid;
>> +	sbi->s_timeout = opts->timeout;
>> +
>> +	/* fill in some other data by hand */
>> +	memset(sb->s_id, 0, sizeof(sb->s_id));
> 
> wasn't it zeroed by kzalloc?
> 

That is a different kzalloc, though I agree that a memset is a bit hysterical
for a strcpy

>> +	strcpy(sb->s_id, "exofs");

Thanks
Boaz
