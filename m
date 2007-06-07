Return-Path: <linux-kernel-owner+w=401wt.eu-S937467AbXFGX5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937467AbXFGX5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762685AbXFGX5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:57:00 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47237 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbXFGX5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:57:00 -0400
Message-ID: <46689B55.1020905@us.ibm.com>
Date: Thu, 07 Jun 2007 16:57:09 -0700
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:0.9.4.1) Gecko/20020508 Netscape6/6.2.3
X-Accept-Language: en-us
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Albert Cahalan <acahalan@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       ebiederm@xmission.com, torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
References: <20070606204432.b670a7b1.akpm@linux-foundation.org> <787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com> <1181233393.9995.14.camel@dyn9047017100.beaverton.ibm.com> <787b0d920706070943h6ac65b85nee5b01600905be08@mail.gmail.com> <1181235997.9995.23.camel@dyn9047017100.beaverton.ibm.com> <20070607124824.27e909fd.akpm@linux-foundation.org> <1181246363.9995.37.camel@dyn9047017100.beaverton.ibm.com> <20070607203757.GA531@vino.hallyn.com> <1181250968.9995.41.camel@dyn9047017100.beaverton.ibm.com> <20070607220820.GA1191@vino.hallyn.com> <20070607222246.GB1191@vino.hallyn.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:

>Quoting Serge E. Hallyn (serge@hallyn.com):
>
>>Quoting Badari Pulavarty (pbadari@us.ibm.com):
>>
>>>On Thu, 2007-06-07 at 15:37 -0500, Serge E. Hallyn wrote:
>>>
>>>>Quoting Badari Pulavarty (pbadari@us.ibm.com):
>>>>
>>>>>On Thu, 2007-06-07 at 12:48 -0700, Andrew Morton wrote:
>>>>>
>>>>>>On Thu, 07 Jun 2007 10:06:37 -0700
>>>>>>Badari Pulavarty <pbadari@us.ibm.com> wrote:
>>>>>>
>>>>>>>On Thu, 2007-06-07 at 12:43 -0400, Albert Cahalan wrote:
>>>>>>>
>>>>>>>>On 6/7/07, Badari Pulavarty <pbadari@us.ibm.com> wrote:
>>>>>>>>
>>>>>>>>>BTW, I agree with Eric that its would be nice to use shmid as part
>>>>>>>>>of name instead of forcing to be as inode number. It should be
>>>>>>>>>possible for pmap to workout shmid from "key" or name. Isn't it ?
>>>>>>>>>
>>>>>>>>It is not at all nice.
>>>>>>>>
>>>>>>>>1. it's incompatible ABI breakage
>>>>>>>>2. where will you put the key then, in the inode? :-)
>>>>>>>>
>>>>>>>Nope. Currently "key" is part of the name (but its not unique).
>>>>>>>
>>>>>>>>Changing to "SYSVID%d" is no good either. Look, people
>>>>>>>>are ***parsing*** this stuff in /proc. The /proc filesystem
>>>>>>>>is not some random sandbox to be playing in.
>>>>>>>>
>>>>>>>>Before you go messing with it, note that the device number
>>>>>>>>also matters. (it's per-boot dynamic, but that's OK)
>>>>>>>>That's how one knows that /SYSV00000000 is not just
>>>>>>>>a regular file; sadly these didn't get a non-/ prefix.
>>>>>>>>(and no you can't fix that now; it's way too late)
>>>>>>>>
>>>>>>>>Next time you feel like breaking an ABI, mind putting
>>>>>>>>"LET'S BREAK AN ABI!" in the subject of your email?
>>>>>>>>
>>>>>>>I am not breaking ABI. Its already broken in the current
>>>>>>>mainline. I am trying to fix it by putting back the ino#
>>>>>>>as shmid. Eric had a suggestion that, instead of depending
>>>>>>>on the inode# to be shmid, we could embed shmid into name
>>>>>>>(instead of "key" which is currently not unique).
>>>>>>>
>>>>>>>>BTW, I suspect this kind of thing also breaks:
>>>>>>>>a. fuser, lsof, and other resource usage display tools
>>>>>>>>b. various obscure emulators (similar to valgrind)
>>>>>>>>
>>>>>>>If you strongly feel that "old" behaviour needs to be retained, 
>>>>>>>
>>>>>>yup, we should put it back.  The change was, afaik, accidental.
>>>>>>
>>>>>>>here is the patch I originally suggested.
>>>>>>>
>>>>>>Confused.  Will this one-liner fix all the userspace breakage to which
>>>>>>Albert refers?
>>>>>>
>>>>>Yes. Albert, please correct me if I am wrong.
>>>>>
>>>>It will, but could lead to two different inodes with the same i_ino,
>>>>right?
>>>>
>>>Only if we generate same ID in two different namespaces. Is it currently
>>>possible ? 
>>>
>>Should be nothing stopping it.
>>
>
>(just to be more certain, a quick test showed I can get id 0 for
>different keys, and different ids for the same key 0xff, in different
>ipc namespaces)
>
Funny. I played with it and decided that it can happen :)

Thanks,
Badari



