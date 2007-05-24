Return-Path: <linux-kernel-owner+w=401wt.eu-S1764161AbXEXEX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764161AbXEXEX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 00:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbXEXEXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 00:23:20 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:38534 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532AbXEXEXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 00:23:20 -0400
Message-ID: <46551335.7030909@alcatel-lucent.com>
Date: Thu, 24 May 2007 12:23:17 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org
Subject: Re: How to produce a core
References: <4655064F.1030808@alcatel-lucent.com> <20070524034913.GN943@1wt.eu>
In-Reply-To: <20070524034913.GN943@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2007 04:22:28.0289 (UTC) FILETIME=[23787310:01C79DBB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Thu, May 24, 2007 at 11:28:15AM +0800, gshan wrote:
>   
>> This morning, I tried command "kill -7 [pid]" but didn't see the core 
>> file. Anybody has ideas?
>>     
>
> do the following before starting your program :
>
> # ulimit -c unlimited
>
> You can check before and after that the core size changed from 0 to
> "unlimited" :
>
> # ulimit -a
>
> Willy
>
>   
Willy,

Thank you very much. The command "kill -7 [pid]" really works with 
"ulimit -c unlimited"

# /bin/sh                                   
# ps
PID   USER     COMMAND
    1 0        init 
    2 0        [ksoftirqd/0]
    3 0        [desched/0]
    4 0        [events/0]
    5 0        [khelper]
   10 0        [kthread]
   31 0        [kblockd/0]
   60 0        [pdflush]
   61 0        [pdflush]
   63 0        [aio/0]
   62 0        [kswapd0]
   64 0        [jfsIO]
   65 0        [jfsCommit]
   66 0        [jfsSync]
   67 0        [xfslogd/0]
   68 0        [xfsdatad/0]
   69 0        [xfsbufd]
  706 0        [mtdblockd]
  730 0        -sh
  788 0        /bin/sh
  789 0        ps
# ulimit -c unlimited
# kill -7 788
Bus error (core dumped)
# ls -al
drwxr-xr-x   12 0        0               0 Jan  1 00:55 .
drwxr-xr-x   12 0        0               0 Jan  1 00:55 ..
drwxr-xr-x    2 1000     1000            0 Jan  1 00:00 bin
-rw-------    1 0        0          417792 Jan  1 00:55 
core                                       <<< Here is the corefile
drwxr-xr-x    2 0        0               0 Jan  1 00:00 dev
drwxr-xr-x    3 0        0               0 Jan  1 00:00 etc
lrwxrwxrwx    1 0        0              12 Jan  1 00:00 init -> /bin/busybox
drwxr-xr-x    2 0        0               0 Jan  1 00:00 lib
drwxr-xr-x    2 0        0               0 Jan  1 00:00 misc
dr-xr-xr-x   32 0        0               0 Jan  1 00:00 proc
drwx------    2 0        0               0 Jan  1 00:00 root
drwxr-xr-x    2 0        0               0 Jan  1 00:00 sbin
drwxr-xr-x    2 0        0               0 Jan  1 00:00 sys
drwxr-xr-x    4 0        0               0 Jan  1 00:00 usr
#

Thanks,
Gavin
