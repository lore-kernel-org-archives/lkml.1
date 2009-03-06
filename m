Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZCFOGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZCFOGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbZCFOGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:06:40 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:40771 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZCFOGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:06:39 -0500
Message-ID: <49B12DE6.6020908@cosmosbay.com>
Date: Fri, 06 Mar 2009 15:06:30 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: g3vbv@blueyonder.co.uk
CC: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Strange problem with FUTEX_WAIT_PRIVATE
References: <49B04565.2060708@blueyonder.co.uk> <49B06BDE.4060103@us.ibm.com> <49B09099.90009@blueyonder.co.uk> <49B09F7D.2060201@cosmosbay.com> <49B119CF.8020003@blueyonder.co.uk>
In-Reply-To: <49B119CF.8020003@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 06 Mar 2009 15:06:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sid Boyce a écrit :
> Eric Dumazet wrote:
>> Sid Boyce a écrit :
>>> Darren Hart wrote:
>>>> Sid Boyce wrote:
>>>>> I don't know if it's a kernel problem, I have already posted to openSUSE
>>>>> Factory list without any response. It's either an openSUSE problem or
>>>>> one encountered since about 2.6.29-rc4 I'd guess and through to
>>>>> 2.6.29-rc7-git1.
>>>>> If I execute certain applications as root I never get the GUI output, as
>>>>> user everything works as expected.
>>>>> Below is part of the strace output from "qjackctl". VirtualBox  and
>>>>> others do the same.
>>>>> <<<Previous lines deleted>>
>>>>> stat("/etc/kde4/share/config/oxygenrc", {st_mode=S_IFREG|0644,
>>>>> st_size=55, ...}) = 0
>>>>> stat("/etc/kde4/share/config/oxygenrc", {st_mode=S_IFREG|0644,
>>>>> st_size=55, ...}) = 0
>>>>> fstat(8, {st_mode=S_IFREG|0644, st_size=55, ...}) = 0
>>>>> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)
>>>>> = 0x7fba0d1a9000
>>>>> read(8, "[Windeco]\nBlendTitlebarColors=false\nShowStripes=false\n\n",
>>>>> 4096) = 55
>>>>> read(8, "", 4096)                       = 0
>>>>> close(8)                                = 0
>>>>> munmap(0x7fba0d1a9000, 4096)            = 0
>>>>> socket(PF_FILE, SOCK_STREAM, 0)         = 8
>>>>> connect(8, {sa_family=AF_FILE, path=@"/tmp/dbus-8XYkB058j7"}, 23) = 0
>>>>> fcntl(8, F_GETFL)                       = 0x2 (flags O_RDWR)
>>>>> fcntl(8, F_SETFL, O_RDWR|O_NONBLOCK)    = 0
>>>>> fcntl(8, F_GETFD)                       = 0
>>>>> fcntl(8, F_SETFD, FD_CLOEXEC)           = 0
>>>>> geteuid()                               = 0
>>>>> rt_sigaction(SIGPIPE, {0x1, [PIPE], SA_RESTORER|SA_RESTART,
>>>>> 0x7fba0869d6e0}, {SIG_DFL, [], 0}, 8) = 0
>>>>> poll([{fd=8, events=POLLOUT}], 1, 0)    = 1 ([{fd=8, revents=POLLOUT}])
>>>>> write(8, "\0", 1)                       = 1
>>>>> write(8, "AUTH EXTERNAL 30\r\n", 18)    = 18
>>>>> poll([{fd=8, events=POLLIN}], 1, -1)    = 1 ([{fd=8, revents=POLLIN}])
>>>>> read(8, "OK 7c5d389345212834a5f2258649afe483\r\n", 2048) = 37
>>>>> poll([{fd=8, events=POLLOUT}], 1, -1)   = 1 ([{fd=8, revents=POLLOUT}])
>>>>> write(8, "BEGIN\r\n", 7)                = 7
>>>>> poll([{fd=8, events=POLLIN|POLLOUT}], 1, -1) = 1 ([{fd=8,
>>>>> revents=POLLIN|POLLOUT|POLLHUP}])
>>>>> read(8, "", 2048)                       = 0
>>>>> close(8)                                = 0
>>>>> sched_yield()                           = 0
>>>>> sched_yield()                           = 0
>>>>> sched_yield()                           = 0
>>>>> sched_yield()                           = 0
>>>>> <<< many lines of the same truncated>>>
>>>>> sched_yield()                           = 0
>>>>> sched_yield()                           = 0
>>>> tsk tsk tsk
>>>>
>>>>> futex(0x7722ac, FUTEX_WAIT_PRIVATE, 1, NULL
>>>>>
>>>>> It never moves beyond that point and I have to CTRL-C back to the prompt.
>>>>> Regards
>>>>> Sid.
>>>> So without an accompanying FUTEX_WAKE this thread will never return
>>>> (since the timeout is NULL).  I suggest 'strace -f' to follow all
>>>> threads - do you see the FUTEX_WAKE?  Do you see it when not running as
>>>> root?
>>>>
>>> It was run with "strace -s 256 -f" and FUTEX_WAKE occurs earlier in the
>>> strace, it just hangs on the last one. Attaching the full strace output.
>>> Regards
>>> Sid.
>>>
>> grep futex QJ.out
>>
>> futex(0x7fff861119dc, FUTEX_WAKE_PRIVATE, 1) = 0
>> futex(0x7ff17b172b60, FUTEX_WAKE_PRIVATE, 2147483647) = 0
>> futex(0x7ff1798acf40, FUTEX_WAKE_PRIVATE, 2147483647) = 0
>> futex(0x7ff17a2310ec, FUTEX_WAKE_PRIVATE, 2147483647) = 0
>> futex(0x7ff17a019b88, FUTEX_WAKE_PRIVATE, 2147483647) = 0
>> futex(0x76deac, FUTEX_WAIT_PRIVATE, 1, NULL
>>
>> So nothing calls futex(0x76deac, FUTEX_WAKE_PRIVATE, 1)
>>
>> According to your strace, this program is monothreaded (no additional 
>> thread was created), so I would say program has a bug.
>>
>> Maybe not 64bit clean, since 0x76deac seems 32bit truncated...
>>
>>
>>
>>
> 
> The apps used to work and are 64-bit. VirtualBox x86_64 stops with ---
> futex(0x69a5bc, FUTEX_WAIT_PRIVATE, 1, NULL
> Attached -- strace from VirtualBox.
> No problems when the apps are run as user.
> Regards
> Sid.
> 

If run from ordinary user, you can see futex(...FUTEX_WAIT_PRIVATE)
interrupted by a signal.

So, when *working*, this program receives a signal from another program.

When running as 'root' user, then the other program is not able to send the signal.
(-> EPERM), since the other program is probably not run by root...

Just my guess.

