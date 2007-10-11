Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbXJKVQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbXJKVQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbXJKVQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:16:29 -0400
Received: from [212.12.190.171] ([212.12.190.171]:56387 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755700AbXJKVQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:16:28 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reserve N process to root
Date: Fri, 12 Oct 2007 00:02:37 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710120002.37341.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Valdis.Kletnieks@vt.edu wrote:
> > What David meant was that "root will always have a slot" doesn't
> > *actually* help unless you *also* have a way to actually *spawn* such a
> > process.  In order to do the ps, kill, and so on that you need to
> > recover, you need to already have either a root shell available, or a
> > way to *get* a root shell that doesn't rely on a non-root process (so
> > /bin/su doesn't help here).
>
> That's right, although it's worse than that.  You need to have a process
> with CAP_SYS_ADMIN.  If root processes normally have that capability
> then the reserved slots may well disappear before you notice a problem.
> If root processes normally don't have it, then you need to guarantee
> that one is already running.

I once posted a patch to handle this DoS, but, as usual, it wasn't accepted.  
Go figure...

Here is an excerpt:

Re: [PATCH 1/1] threads_max: Simple lockout prevention patch

From: Al Boldi <a1426z@gawab.com>
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org
Date: 04/24/06 02:12 pm

Andrew Morton wrote:
> Al Boldi <a1426z@gawab.com> wrote:
> > This is a another resend, which was ignored before w/o comment.
> > Andrew, can you at least comment on it?  Thanks!
>
> I don't have a clue what it's for.

Quoting from the 'Resource limits' thread on lkml on 27/09/05:
>>>>> Consider this dilemma:
>>>>> Runaway proc/s hit the limit.
>>>>> Try to kill some and you are denied due to the resource limit.
>>>>> Use some previously running app like top, hope it hasn't been killed
>>>>> by some OOM situation, try killing some procs and another one takes
>>>>> it's place because of the runaway situation.
>>>>> Raise the limit, and it gets filled by the runaways.
>>>>> You are pretty much stuck.
>>>>
>>>> Not really, this is the sort of thing ulimit is meant for.  To keep
>>>> processes from any one user from running away.  It lets you limit the
>>>> damage it can do, until such time as you can control it and fix the
>>>> runaway application.
>>>
>>> threads-max = 1024
>>> ulimit = 100 forks
>>> 11 runaway procs hitting the threads-max limit
>>
>> This is incorrect.  If you ulimit a user to 100 forks, and 11 processes
>> running with that uid
> 
> Different uid.
> 
Then yes, if you set a system-wide limit that is less than the sum of the 
limits imposed on each accountable part of the system you can have lock out.  
But thats your fault for misconfiguring the system.  Don't do that.

-- end of quote

Thanks!

--
Al

