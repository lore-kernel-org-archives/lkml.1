Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYF2HKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYF2HKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 03:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYF2HKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 03:10:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:49663 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYF2HKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 03:10:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QlJbq1V+g68+RuD8mL3yUXcm+IUe3RExH9wJuZuC01nmHnzW5GsdJpNDvs4p/j7Xbx
         iL67RJuopLF1nNp6yeQ5sVKjRnKgMRZDp65wUVk1q7OdniypwfoDgVRJb+Axc5/OvIKT
         LX/Od1WWZlXEM2eUX/RAQDq56Zk29feUAlzS0=
Message-ID: <48673544.5020408@gmail.com>
Date: Sun, 29 Jun 2008 10:09:56 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org>
In-Reply-To: <4866F6FE.9000503@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
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

Ok.

>
> That said, if a program is blocking for tens of seconds in block IO,
> then that could be a problem in itself.

In that case I don't think that a program doing heavy I/O (writeout of
100Mb+) should be able to block other processes waiting for I/O on the
same device for tens of seconds.
I am using CFQ as I/O scheduler now, I will try the other I/O schedulers
(especially deadline) and see if I get better behaviour.

Is there any documentation on the tunable values for CFQ? (in
Documentation/block there is only about anticipatory and deadline).

Best regards,
--Edwin

