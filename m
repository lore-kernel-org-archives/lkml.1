Return-Path: <linux-kernel-owner+w=401wt.eu-S1767345AbXCIQNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767345AbXCIQNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767346AbXCIQNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:13:32 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55284 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767345AbXCIQNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:13:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Catalin Marinas" <catalin.marinas@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Possible "struct pid" leak from tty_io.c
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	<m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703090253r690e1f21qf8d7a1edfd08561b@mail.gmail.com>
Date: Fri, 09 Mar 2007 09:13:15 -0700
In-Reply-To: <b0943d9e0703090253r690e1f21qf8d7a1edfd08561b@mail.gmail.com>
	(Catalin Marinas's message of "Fri, 9 Mar 2007 10:53:01 +0000")
Message-ID: <m1y7m64cpw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Catalin Marinas" <catalin.marinas@gmail.com> writes:

> On 08/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> "Catalin Marinas" <catalin.marinas@gmail.com> writes:
>
> I think it's only the pid_chain and rcu member that could be placed in
> a list and kmemleak scans the memory for these two offsets as well.
> I'll check those lists anyway but I doubt it's a more fundamental
> problem with how kmemleak handles struct pid as I should've probably
> got more reports.

Right.  I was pointing out the possibilities but because we do
some tricky things.  Mostly I was wondering about the hlist for
the list of tasks.  Now if a task is on that list we should have
a struct pid_link pointing at our struct pid, so it shouldn't fool
kmemleak but I'm still a little curious if all of those hlist_heads are
NULL pointers.

>> In most any other layer we cache pids indefinitely and a situation
>> where we have a pointer to a struct pid with a ref count of 1 long
>> after the process goes away is expected.
>
> Yes, indeed, but what kmemleak reports is that the pid structure
> wasn't freed yet and there is no way to determine its pointer directly
> or via container_of on members (by scanning the memory), hence it is
> considered a leak.

Yes that sounds like a leak.

>> I don't understand your situation enough to guess what is going wrong
>> yet.  Hopefully I have given you enough information to get started.
>
> Yes, many thanks. I'll dig further and let you know.

Thanks....

Eric
