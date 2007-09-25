Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbXIYIew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbXIYIew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbXIYIep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:34:45 -0400
Received: from sacred.ru ([62.205.161.221]:50554 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbXIYIeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:34:44 -0400
Message-ID: <46F8C740.6040003@openvz.org>
Date: Tue, 25 Sep 2007 12:30:56 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix messed hunks in generic_setlease
References: <46F8BF79.40405@openvz.org> <20070925010728.b65e5b27.akpm@linux-foundation.org>
In-Reply-To: <20070925010728.b65e5b27.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 25 Sep 2007 12:33:22 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 25 Sep 2007 11:57:45 +0400 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> I have noticed, that one hunk was lost and one duplicated 
>> during merging the fix-potential-oops-in-generic_setlease(-xxx) 
>> patches. One of the fixes is already in the hot-fixes, but the
>> second one is still lost.
>>
>> The returned pointer was not the one allocated, but some temporary
>> used to scan through the inode's locks list. This caused and OOPS 
>> during Kamalesh's testing.
>>
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>>
>> ---
>>
>> diff --git a/fs/locks.c b/fs/locks.c
>> index c0fe71a..c1198e3 100644
>> --- a/fs/locks.c
>> +++ b/fs/locks.c
>> @@ -1423,7 +1418,7 @@ int generic_setlease(struct file *filp, 
>>  	locks_copy_lock(new_fl, lease);
>>  	locks_insert_lock(before, new_fl);
>>  
>> -	*flp = fl;
>> +	*flp = new_fl;
>>  	return 0;
>>  
>>  out:
> 
> argh, what a mess - there are way too many trees playing with fs/locks.c.
> 
> umm, I think this is not a mismerge and that the original patch
> (http://lkml.org/lkml/2007/9/20/141) had this bug in it.

Indeed... :(

> And I've just sent that buggy patch to Linus.  Do you agree?

Shame on me... Sorry :(

(going to the blackboard to write "I will check my patches twice before
 sending them to Andrew" for 100 times)
