Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbXJ0Elc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbXJ0Elc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 00:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXJ0ElP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 00:41:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbXJ0ElO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 00:41:14 -0400
Date: Fri, 26 Oct 2007 21:40:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Adrian Bunk <bunk@kernel.org>, kir@swsoft.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       kir@openvz.org, Cedric Le Goater <clg@fr.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
Message-Id: <20071026214046.c61e248d.akpm@linux-foundation.org>
In-Reply-To: <m18x5pte18.fsf@ebiederm.dsl.xmission.com>
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>
	<m1ve8ty1tq.fsf@ebiederm.dsl.xmission.com>
	<20071027002448.GH30533@stusta.de>
	<m18x5puyw7.fsf@ebiederm.dsl.xmission.com>
	<20071027020408.GO30533@stusta.de>
	<20071026191845.fd0f75c8.akpm@linux-foundation.org>
	<m18x5pte18.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 21:46:59 -0600 ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> >> On Sat, 27 Oct 2007 04:04:08 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> >> > be happy to hear if someone has a better idea.
> >> 
> >> There is a difference between "complete the feature" and "early adopters 
> >> to start playing with the feature" on the one side, and making something 
> >> available in a released kernel on the other side.
> >> 
> >> For development and playing with it it can depend on BROKEN (perhaps 
> >> with the dependency removed through the first -rc kernels), but as soon 
> >> as it's available in a -final kernel the ABI is fixed.
> >> 
> >
> > Yes, if we're not 100% certain that the interfaces are correnct and unchanging
> > and that the implementation is solid, we should disable the feature at Kconfig
> > time.
> 
> Reasonable.  So far things look good for a single pid namespace.  Multiple
> pid namespaces look iffy.
> 
> > The best option would be to fix things asap.  But assuming that option isn't
> > reasonable and/or safe, we can slip a `depends on BROKEN' into -rc6 then
> > resume development for 2.6.25.
> 
> I think we can make a lot of progress but there is enough development
> yet to do to reach the target of correct and unchanging interfaces,
> with a solid interface.  That unless we achieve a breakthrough I
> don't see us achieving that target for 2.6.24.
> 
> The outstanding issues I can think of off the top of my head:
> - signal handling for init on secondary pid namespaces.
> - Properly setting si_pid on signals that cross namespaces.
> - The kthread API conversion so we don't get kernel threads
>   trapped in pid namespaces and make them unfreeable.
> - At fork time I think we are doing a little bit too much work
>   in setting the session and the pgrp, and removing the controlling
>   tty.
> - AF_unix domain credential passing.
> - misc pid vs vpid sorting out (autofs autofs4, coda, arch specific
>   syscalls, others?)
> - Removal of task->pid, task->tgid, task->signal->__pgrp,
>   tsk->signal->__session or some other way to ensure that we have
>   touched and converted all of the kernel pid handling.
> - flock pid handling.

Given that a lot of this development will hopefully happen over the next
two months, ...

> It hurts me to even ponder what thinking makes it that 
> CONFIG_EXPERIMENTAL isn't enough to keep a stable distro
> from shipping the code in their stable kernel, and locking us into
> trouble.
> 
> With that said.  I think I should just respin the patchset now and add
> the "depends on BROKEN".  

it doesn't make sense to make it all dependent upon BROKEN now.  Better
would be to make it dependant upon CONFIG_SOMETHING_ELSE now, which depends
upon EXPERIMENTAL and which will, around -rc6, be changed to depend upon
BROKEN.

If that makes sense.

It's all a bit unusual and complex, but this is an exceptional set of
features - let's hang in there.


