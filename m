Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbXIRGhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbXIRGhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXIRGg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:36:56 -0400
Received: from sacred.ru ([62.205.161.221]:55126 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbXIRGg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:36:56 -0400
Message-ID: <46EF7136.7080308@openvz.org>
Date: Tue, 18 Sep 2007 10:33:26 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Andrew Morton <akpm@osdl.org>, "J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
References: <46EE3724.80200@openvz.org>	 <1190037331.6700.14.camel@heimdal.trondhjem.org>	 <46EE8C52.80503@openvz.org> <1190044850.6700.81.camel@heimdal.trondhjem.org>
In-Reply-To: <1190044850.6700.81.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 18 Sep 2007 10:35:47 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Mon, 2007-09-17 at 18:16 +0400, Pavel Emelyanov wrote:
>> Trond Myklebust wrote:
>>> On Mon, 2007-09-17 at 12:13 +0400, Pavel Emelyanov wrote:
>>>> When the process is blocked on mandatory lock and someone changes 
>>>> the inode's permissions, so that the lock is no longer mandatory,
>>>> nobody wakes up the blocked process, but probably should.
>>> Please explain in more detail why we need this patch.
>> From "this fixes an OOPs/deadlock/leak" POV we do not. This is
>> just an attempt to make the locking code be more consistent and
>> clean.
> 
> Why do you think we get a deadlock or leak? AFAICS if the user turns off

I didn't' tell that.

> mandatory locks on the file, then the existing locks default back into
> advisory locks which use the same notification mechanism as the
> mandatory locks.

True.

> IOW: the process that is waiting in locks_mandatory_area() will be
> released as soon as the advisory lock is dropped. If that theory is
> broken in practice, then that is the bug that we need to fix. We neither
> want to add a load of locking crap to notify_change(), nor should we
> need to.

We have this for inotify already. Adding wakeup for mandatory lock
is not that bad.

Anyway - I noticed, that the system state can become not consistent
and proposed the way to fix it. If this inconsistency is not a big
deal, and nobody cares, than I'm fine with forgetting this patch, 
since I have no other arguments to protect it, but "this is just not
very nice without this patch".

> Cheers
>    Trond
> 
> 

Thanks,
Pavel
