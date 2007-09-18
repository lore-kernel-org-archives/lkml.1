Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXIRGXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXIRGXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbXIRGXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:23:08 -0400
Received: from sacred.ru ([62.205.161.221]:34070 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbXIRGXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:23:06 -0400
Message-ID: <46EF6E18.90801@openvz.org>
Date: Tue, 18 Sep 2007 10:20:08 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 5/5][NFS] Cleanup explicit check for mandatory locks
References: <46EE335C.3010106@openvz.org> <1190048620.6700.100.camel@heimdal.trondhjem.org>
In-Reply-To: <1190048620.6700.100.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 18 Sep 2007 10:22:30 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Mon, 2007-09-17 at 11:57 +0400, Pavel Emelyanov wrote:
>> The __mandatory_lock(inode) macro makes the same check, but
>> makes the code more readable.
> 
> Could we please avoid using underscores in macros. Also, why are we
> breaking the usual convention of capitalising macro names?

Sorry, I've forgot to change all the log - this is not a macro, 
but a static inline function. The underscores are here, because 
the mandatory_lock() one already exists and additionally checks 
for "if (IS_MANDLOCK(inode))"

Thanks,
Pavel

> Cheers
>   Trond
> 
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>> Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
>>
>> ---
>>
>>  fs/nfs/file.c |    3 +--
>>  1 files changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
>> index 73ddd2e..7a07be1 100644
>> --- a/fs/nfs/file.c
>> +++ b/fs/nfs/file.c
>> @@ -605,8 +605,7 @@ static int nfs_lock(struct file *filp, i
>>  	nfs_inc_stats(inode, NFSIOS_VFSLOCK);
>>  
>>  	/* No mandatory locks over NFS */
>> -	if ((inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID &&
>> -	    fl->fl_type != F_UNLCK)
>> +	if (__mandatory_lock(inode) && fl->fl_type != F_UNLCK)
>>  		return -ENOLCK;
>>  
>>  	if (IS_GETLK(cmd))
>>
> 
> 

