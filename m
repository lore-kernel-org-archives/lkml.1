Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbXJIRZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbXJIRZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXJIRZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:25:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48213 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXJIRZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:25:20 -0400
Message-ID: <470BB933.8010402@oracle.com>
Date: Tue, 09 Oct 2007 10:24:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: Rob Landley <rob@landley.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH] Stop docproc segfaulting when SRCTREE isn't set.
References: <200710090125.19089.rob@landley.net> <20071009130315.GB4245@Ahmed> <20071009085500.e7be49a0.randy.dunlap@oracle.com> <20071009171949.GA11579@Ahmed>
In-Reply-To: <20071009171949.GA11579@Ahmed>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ahmed S. Darwish wrote:
> On Tue, Oct 09, 2007 at 08:55:00AM -0700, Randy Dunlap wrote:
>> On Tue, 9 Oct 2007 15:03:15 +0200 Ahmed S. Darwish wrote:
>>
>>> Hi Rob,
>>>
>>> On Tue, Oct 09, 2007 at 01:25:18AM -0500, Rob Landley wrote:
>>> [...]
>>>>  	FILE * infile;
>>>> +
>>>> +	srctree = getenv("SRCTREE");
>>>> +	if (!srctree) srctree = getcwd(NULL,0);
>>>>  	if (argc != 3) {
>>>>  		usage();
>>>>  		exit(1);
>>> $ man getcwd
>>>
>>>  char *getcwd(char *buf, size_t size);
>>>       
>>>  As an extension to the POSIX.1 standard, Linux (libc4, libc5, glibc) getcwd() 
>>>  allocates the buffer dynamically using malloc() if buf is NULL on call.
>>>
>>> Shouldn't "srctree" be free()ed in case getenv("SRCTREE") failed ?
>> What is there to free() at that point?  If getenv() fails (i.e.,
>> the env. variable is not found), it returns NULL.
>> or do I need another cup of coffee?
>>
> 
> I meant if getenv() failed, "srctree = getcwd(NULL, 0)" will let 
> "srctree" point to a _ malloc()ed _ buffer representing PWD. 
> As said in the manpage, this buffer needs to be free()ed after usage.
> Right or I'm the one who needs that cup of coffee :) ?

so it needs to be freed at program termination, is that what you are
saying?  That will happen automatically (along with any open files being
closed, etc.).

-- 
~Randy
