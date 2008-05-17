Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYEQCSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYEQCSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 22:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYEQCSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 22:18:42 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61575 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYEQCSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 22:18:41 -0400
Message-ID: <482E3DDA.7050708@oracle.com>
Date: Fri, 16 May 2008 19:07:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>	<20080516170310.35d7b407.randy.dunlap@oracle.com> <20080516172816.9d98c0f2.akpm@linux-foundation.org>
In-Reply-To: <20080516172816.9d98c0f2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 16 May 2008 17:03:10 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Sun, 20 Apr 2008 07:20:53 -0700 Andrew Morton wrote:
>>
>>> These can be found at
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1
>>>
>>>
>>>
>>>  #
>>>  # documentation
>>>  #
>>>  documentation-build-source-files-in-documentation-sub-dir.patch
>>>  documentation-build-source-files-in-documentation-sub-dir-update.patch
>>>  documentation-build-source-files-in-documentation-sub-dir-disable.patch
>>>
>>> Merge
>> Hi,
>> What happened to/with these?
> 
> I was going to ask you that.  Last I heard,
> 
> a) stuff broke and
> 
> b) you had an updated version somewhere.

Oh yeah.  I think that this was fixed by
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b11caa7c7063ea92a0a58115d3fc6d038ed89510
but I'll check/verify/confirm that.


> On Thu, 10 Apr 2008 17:56:30 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Wed, 9 Apr 2008 14:54:09 -0700 Andrew Morton wrote:
>>
>>> make allmodconfig
>>> gcc -I$(/bin/pwd)/include Documentation/accounting/getdelays.c -o getdelays
>>>
>>> In file included from /usr/src/devel/include/linux/netlink.h:5,
>>>                  from /usr/src/devel/include/linux/genetlink.h:4,
>>>                  from Documentation/accounting/getdelays.c:26:
>>> /usr/src/devel/include/linux/types.h:203: error: expected specifier-qualifier-list before '__kernel_daddr_t'
>>
>> Those __kernel_* types shouldn't be used outside of the #ifdef __KERNEL__
>> block, should they?
>>
>> Patch below fixes kernel side for me.  Don't have any idea what it
>> may do to userspace users of the header file.
>>
>> ---
>>  include/linux/types.h |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- mmotm-2008-0410-0157.orig/include/linux/types.h
>> +++ mmotm-2008-0410-0157/include/linux/types.h
>> @@ -200,8 +200,8 @@ typedef u32 resource_size_t;
>>  #endif	/* __KERNEL__ */
>>  
>>  struct ustat {
>> -	__kernel_daddr_t	f_tfree;
>> -	__kernel_ino_t		f_tinode;
>> +	daddr_t			f_tfree;
>> +	ino_t			f_tinode;
>>  	char			f_fname[6];
>>  	char			f_fpack[6];
>>  };
> 
> I didn't apply that.  I guess the "Don't have any idea" bit was scary.


-- 
~Randy
