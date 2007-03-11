Return-Path: <linux-kernel-owner+w=401wt.eu-S934001AbXCKTBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbXCKTBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934002AbXCKTBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:01:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50051 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001AbXCKTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:01:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelianov <xemul@sw.ru>
Cc: balbir@in.ibm.com, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/7] Resource counters
References: <45ED7DEC.7010403@sw.ru> <45ED7F69.60108@sw.ru>
	<45EE39A5.7010804@in.ibm.com> <45EE6769.9060701@sw.ru>
	<20070309163711.GA3647@MAIL.13thfloor.at>
Date: Sun, 11 Mar 2007 13:00:15 -0600
In-Reply-To: <20070309163711.GA3647@MAIL.13thfloor.at> (Herbert Poetzl's
	message of "Fri, 9 Mar 2007 17:37:11 +0100")
Message-ID: <m1fy8bwqps.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Poetzl <herbert@13thfloor.at> writes:

>
> Linux-VServer does the accounting with atomic counters,
> so that works quite fine, just do the checks at the
> beginning of whatever resource allocation and the
> accounting once the resource is acquired ...

Atomic operations versus locks is only a granularity thing.
You still need the cache line which is the cost on SMP.

Are you using atomic_add_return or atomic_add_unless or
are you performing you actions in two separate steps which
is racy?  What I have seen indicates you are using a racy two separate
operation form.

>> If we'll remove failcnt this would look like
>>    while (atomic_cmpxchg(...))
>> which is also not that good.
>> 
>> Moreover - in RSS accounting patches I perform page list
>> manipulations under this lock, so this also saves one atomic op.
>
> it still hasn't been shown that this kind of RSS limit
> doesn't add big time overhead to normal operations
> (inside and outside of such a resource container)
>
> note that the 'usual' memory accounting is much more
> lightweight and serves similar purposes ...

Perhaps....

Eric
