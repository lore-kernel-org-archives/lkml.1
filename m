Return-Path: <linux-kernel-owner+w=401wt.eu-S936434AbYEUUy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936434AbYEUUy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYEUUyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:54:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41275 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYEUUyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:54:18 -0400
Message-ID: <48348AFA.1070900@oracle.com>
Date: Wed, 21 May 2008 13:50:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: mark <markkicks@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>	 <20080521132845.72db5748.randy.dunlap@oracle.com> <82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
In-Reply-To: <82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mark wrote:
> On Wed, May 21, 2008 at 1:28 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Tue, 20 May 2008 11:26:47 -0700 mark wrote:
>>> I upgraded to 2.6.25.3-18.fc9.x86_64 fedora core 9, now I get this
>>> error when I try to login to the box, kill a pr start a python app, or
>>> do anything on a regular basis.
>>>
>>> fork: Resource temporarily unavailable
>>>
>>> I have over 10GB RAM free, and zero swap spaced used. The box is a
>>> dual quad core Intel Xeon 5405 with 16GB RAM.
>>>
>>> There is no error message in /var/log/messages or dmesg ...
>>> how do I identify the problem?
>>> thanks!
>>>
>>> uname -a
>>> Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
>>> x86_64 x86_64 x86_64 GNU/Linux
>>>
>>>
>>> free -m
>>>             total       used       free     shared    buffers     cached
>>> Mem:         16086       3189      12896          0         42        666
>>> -/+ buffers/cache:       2481      13605
>>> Swap:         1983          0       1983
>>>
>>>
>>> have only 505 processes running
>>> ps aux | wc -l
>>> 505
>>>
>>>
>>> uptime
>>>  11:24:15 up 39 min,  1 user,  load average: 3.54, 3.47, 2.87
>>>
>>> ulimit -a
>>> core file size          (blocks, -c) 0
>>> data seg size           (kbytes, -d) unlimited
>>> scheduling priority             (-e) 0
>>> file size               (blocks, -f) unlimited
>>> pending signals                 (-i) 137216
>>> max locked memory       (kbytes, -l) 32
>>> max memory size         (kbytes, -m) unlimited
>>> open files                      (-n) 32768
>>> pipe size            (512 bytes, -p) 8
>>> POSIX message queues     (bytes, -q) 819200
>>> real-time priority              (-r) 0
>>> stack size              (kbytes, -s) 10240
>>> cpu time               (seconds, -t) unlimited
>>> max user processes              (-u) 1024
>>> virtual memory          (kbytes, -v) unlimited
>>> file locks                      (-x) unlimited
>> The only place that fork() returns EAGAIN is for number of
>> processes being >= its limit.  Does this user already have >= 1024
>> processes?
> 
> No, it is around 400

Well, my comment was wrong anyway.  There are several other tests just
below number of user processes that also return EAGAIN, like:

- total number of threads being too large
- error on grabbing a module reference count (?)
- error on grabbing a binfmt module reference


> ps ax | wc -l
> 417
> 
> I also I increased max process to unlimited, and I still get the error
> randomly..
> 
> ulimit -u
> unlimited
> 
> my webserver is now throwing this error:
> 
> setuid(500) failed (11: Resource temporarily unavailable)

That's all of the useful information??

> 
> cat /etc/passwd | grep mark
> mark:x:500:500::/home/mark:/bin/bash
> 
> I also increased this, but still the same error
> kernel.pid_max =  65536


-- 
~Randy
