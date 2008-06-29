Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbYF2Dmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbYF2Dmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 23:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYF2Dmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 23:42:40 -0400
Received: from il.qumranet.com ([212.179.150.194]:44122 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbYF2Dmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 23:42:38 -0400
Message-ID: <486704AC.2090207@qumranet.com>
Date: Sun, 29 Jun 2008 06:42:36 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org>
In-Reply-To: <4866F6FE.9000503@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Török Edwin wrote:
>> Hi,
>>
>> I have encountered the following situation several times, but I've been
>> unable to come up with a way to reproduce this until now:
>>  - some process is keeping the disk busy (some cron job for example:
>> updatedb, chkrootkit, ...)
>>  - other processes that want to do I/O have to wait (this is normal)
>>  - I have a (I/O bound) process running in my terminal, and I want to
>> interrupt it with Ctrl+C
>>  - I type Ctrl+C several times, and the process is not interrupted for
>> several seconds (10-30 secs)
>>  - if I type Ctrl+Z, and use kill %1 the process dies faster than
>> waiting for it to react to Ctrl+C
>>
>> This issue occurs both on my x86-64 machine that uses reiserfs, and on
>> my x86 machine that uses XFS, so it doesn't seem related to the
>> underlying FS.
>> I use 2.6.25-2 and 2.6.26-rc8 now; I don't recall seeing this behaviour
>> with old kernels (IIRC I see this since 2.6.21 or 2.6.23).
>>
>> Is this intended behaviour, or should I report a bug?
>>   
>
> Yes, it's intended behaviour.  Filesystem IO syscalls are considered 
> "fast" and are interruptible.  Usermode code can reasonably expect 
> that file IO will never return EINTR.

That's filesystem dependent; if you mount an nfs filesystem with the 
'intr' mount option, it will be interruptible (which makes sense, as it 
is impossible to guarantee the server's responsiveness).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

