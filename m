Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYLaPg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYLaPg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 10:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYLaPgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 10:36:17 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:17595 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755846AbYLaPgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 10:36:16 -0500
Message-ID: <495B916C.7090205@panasas.com>
Date: Wed, 31 Dec 2008 17:36:12 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] exofs: file and file_inode operations
References: <4947BFAA.4030208@panasas.com>	<4947C685.1000800@panasas.com> <20081229123443.36c022bc.akpm@linux-foundation.org>
In-Reply-To: <20081229123443.36c022bc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Dec 2008 15:36:10.0875 (UTC) FILETIME=[81B0D4B0:01C96B5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 16 Dec 2008 17:17:25 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> implementation of the file_operations and inode_operations for
>> regular data files.
>>
>> Most file_operations are generic vfs implementations except:
>> - exofs_truncate will truncate the OSD object as well
>> - Generic file_fsync is not good for none_bd devices so open code it
>> - The default for .flush in Linux is todo nothing so call exofs_fsync
>>   on the file.
>>
>> ...
>>
>> +int exofs_file_fsync(struct file *filp, struct dentry *dentry, int datasync)
>> +{
>> +	int ret1, ret2;
>> +	struct address_space *mapping = filp->f_mapping;
>> +
>> +	ret1 = filemap_write_and_wait(mapping);
>> +	ret2 = file_fsync(filp, dentry, datasync);
>> +
>> +	return ret1 ? : ret2;
> 
> mutter.  That gccism always makes me fall over dazed and confused. 
> Maybe that's just me.
> 

I've seen it done and felt like you exactly, only I liked the feeling. I'll change
it.

> Did we really want to call file_fsync() if filemap_write_and_wait() failed?
> 

I think it cannot hurt, other places do the same including generic code.

