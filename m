Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYEUVJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYEUVJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759134AbYEUVI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:08:56 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:9566 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbYEUVIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=i0PsVNW0UlG8On/kxirPDAKy64UhJHMN7yRXS5bMLu+8+WxLbI9Cg/kCfSJRjUZYdpQZ7KLnKO+akczy66DWnWPeOkCiQ04fS4cL6RApY3508xrLx4ilLJG9JBqr6groLrX0E3duCkkJeyWFiZlr3FTs+8F7yKdwZ2ytLS9hMFc=
Message-ID: <82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>
Date: Wed, 21 May 2008 14:08:53 -0700
From: mark <markkicks@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48348AFA.1070900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
	 <20080521132845.72db5748.randy.dunlap@oracle.com>
	 <82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
	 <48348AFA.1070900@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 1:50 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> mark wrote:
>>
>> On Wed, May 21, 2008 at 1:28 PM, Randy Dunlap <randy.dunlap@oracle.com>
>> wrote:
>>>
>>> On Tue, 20 May 2008 11:26:47 -0700 mark wrote:
>>>>
>>>> I upgraded to 2.6.25.3-18.fc9.x86_64 fedora core 9, now I get this
>>>> error when I try to login to the box, kill a pr start a python app, or
>>>> do anything on a regular basis.
>>>>
>>>> fork: Resource temporarily unavailable
>>>>
>>>> I have over 10GB RAM free, and zero swap spaced used. The box is a
>>>> dual quad core Intel Xeon 5405 with 16GB RAM.
>>>>
>>>> There is no error message in /var/log/messages or dmesg ...
>>>> how do I identify the problem?
>>>> thanks!
>>>>
>>>> uname -a
>>>> Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
>>>> x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>>
>>>> free -m
>>>>            total       used       free     shared    buffers     cached
>>>> Mem:         16086       3189      12896          0         42
>>>>  666
>>>> -/+ buffers/cache:       2481      13605
>>>> Swap:         1983          0       1983
>>>>
>>>>
>>>> have only 505 processes running
>>>> ps aux | wc -l
>>>> 505
>>>>
>>>>
>>>> uptime
>>>>  11:24:15 up 39 min,  1 user,  load average: 3.54, 3.47, 2.87
>>>>
>>>> ulimit -a
>>>> core file size          (blocks, -c) 0
>>>> data seg size           (kbytes, -d) unlimited
>>>> scheduling priority             (-e) 0
>>>> file size               (blocks, -f) unlimited
>>>> pending signals                 (-i) 137216
>>>> max locked memory       (kbytes, -l) 32
>>>> max memory size         (kbytes, -m) unlimited
>>>> open files                      (-n) 32768
>>>> pipe size            (512 bytes, -p) 8
>>>> POSIX message queues     (bytes, -q) 819200
>>>> real-time priority              (-r) 0
>>>> stack size              (kbytes, -s) 10240
>>>> cpu time               (seconds, -t) unlimited
>>>> max user processes              (-u) 1024
>>>> virtual memory          (kbytes, -v) unlimited
>>>> file locks                      (-x) unlimited
>>>
>>> The only place that fork() returns EAGAIN is for number of
>>> processes being >= its limit.  Does this user already have >= 1024
>>> processes?
>>
>> No, it is around 400
>
> Well, my comment was wrong anyway.  There are several other tests just
> below number of user processes that also return EAGAIN, like:
>
> - total number of threads being too large
> - error on grabbing a module reference count (?)
> - error on grabbing a binfmt module reference

as a user how do i identify what is wrong, and fix this? for total
number of threads -> is there anyway i can find out if this is causing
the problem? my system is running around 80 multi-threaded python web
apps.



>> my webserver is now throwing this error:
>>
>> setuid(500) failed (11: Resource temporarily unavailable)
>
> That's all of the useful information??

Yes. i get this error  when i restart the web server. if i kill all
other apps, and then start it again it starts fine.

this is the complete error message,
2008/05/21 08:02:19 [emerg] 30558#0: setuid(500) failed (11: Resource
temporarily unavailable)
2008/05/21 08:02:19 [alert] 30557#0: worker process 30558 exited with
fatal code 2 and can not be respawn
