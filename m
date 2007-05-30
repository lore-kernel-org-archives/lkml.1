Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbXE3Bos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbXE3Bos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbXE3Bol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:44:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55879 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXE3Bok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:44:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Albert Cahalan" <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, jengelh@linux01.gwdg.de, holt@sgi.com,
       oleg@tv-sign.ru, roland@redhat.com
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
References: <787b0d920705282023v22316e6bk709dc8d3aa3213d7@mail.gmail.com>
	<m1646c8c33.fsf@ebiederm.dsl.xmission.com>
	<787b0d920705291733t7a2ca052tbad7e11bbe0b1eff@mail.gmail.com>
Date: Tue, 29 May 2007 19:43:27 -0600
In-Reply-To: <787b0d920705291733t7a2ca052tbad7e11bbe0b1eff@mail.gmail.com>
	(Albert Cahalan's message of "Tue, 29 May 2007 20:33:44 -0400")
Message-ID: <m1646b6q80.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Albert Cahalan" <acahalan@gmail.com> writes:

> On 5/29/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> "Albert Cahalan" <acahalan@gmail.com> writes:
>
> That's not what I mean. (the "-e" causes that of course)
> I'm asking about the parent-child relationships shown.
> The "-H" option is a bit different from the "f" option.

Yes.  Sorry on the unmodified ps the parent-child relationship
seems to be displayed properly.  

>>> I'd be a lot happier about breaking compatibility in this area
>>> if I could get a functional adoption flag. That is, I really
>>> would like to show a process as child of init if it naturally
>>> was created as a child of init. It's less informative to have
>>> fake children showing up the same as real ones. The original
>>> parent PID would do. (BTW, the original parent name and/or
>>> grandparent PID would be great to have) As a bonus, the kernel
>>> could reap these processes more quickly than init can... and
>>> then maybe we can stop caring if init is alive.
>>
>> Having the kernel not reparent user processes to init is an interesting
>> idea, especially when those processes have not existed.  I'm not
>> certain that is POSIX complaint and otherwise backwards compatible.
>
> I'm not suggesting that this be visible via POSIX APIs.
>
> It's almost certainly a given that getppid() must return 1, and
> probably /proc needs to show this as well. Without question,
> any process created by init must be reaped by init.
>
> Processes NOT created by init could be silently reaped by
> the kernel. They need to see their own PPID as 1, but there
> need not be any parent-child relationship in the kernel data
> structures. The kernel can fake the whole thing, which is nice
> because then the kernel isn't depending on userspace to
> correctly perform the pointless action of playing with zombies.
> (might setting the death signal to 0 be useful here?)
>
> For "ps fax" and such, I'd like to distinguish between init's
> real and adopted children. Right now the adopted children
> look like they were created by init, which is not true. I only
> need a simple boolean flag, set upon reparenting, to tell me.
> Such a flag may also be useful for optimizing away the whole
> wait/waitpid/wait4/waitid/wait3 nonsense when an adopted
> child dies.

I will keep it in mind.  A simple this process has been reparented
flag probably won't be too bad.   As for the rest I'm not certain.

With pid namespaces there is a certain sense in doing something like
this, but I'm not certain /sbin/init and all of it's replacements
don't care (although admittedly it would be a stretch to tell the
difference).

Eric

