Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYF2MLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYF2MLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYF2MLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:11:09 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:9467 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYF2MLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:11:08 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: =?utf-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
From: Andi Kleen <andi@firstfloor.org>
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org>
Date: Sun, 29 Jun 2008 14:10:42 +0200
In-Reply-To: <4866F6FE.9000503@goop.org> (Jeremy Fitzhardinge's message of "Sat, 28 Jun 2008 19:44:14 -0700")
Message-ID: <8763rsphkt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Jun 2008 12:03:23.0814 (UTC) FILETIME=[21822C60:01C8D9E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

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
>
> That said, if a program is blocking for tens of seconds in block IO,
> then that could be a problem in itself.

Still there's the effect that Ctrl-Z+kill works faster than Ctrl-C
that is not explained by this. This has often annoyed me too.
I'm not sure why it is. In theory they should be the same unless
someone blocks SIGINT.

-Andi
