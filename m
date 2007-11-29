Return-Path: <linux-kernel-owner+w=401wt.eu-S1763355AbXK2UmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763355AbXK2UmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760151AbXK2UmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:42:01 -0500
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:64445 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259AbXK2UmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:42:00 -0500
X-Greylist: delayed 1682 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 15:41:59 EST
Message-ID: <474F1D96.3060606@cs.columbia.edu>
Date: Thu, 29 Nov 2007 15:14:14 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch -mm 2/4] mqueue namespace : add unshare support
References: <20071128163728.177495768@fr.ibm.com>>	<20071128164349.196734045@fr.ibm.com>>	<474DA61B.5030301@openvz.org> <474E944C.4020809@fr.ibm.com>
In-Reply-To: <474E944C.4020809@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Cedric Le Goater wrote:
>>> Index: 2.6.24-rc3-mm2/include/linux/sched.h
>>> ===================================================================
>>> --- 2.6.24-rc3-mm2.orig/include/linux/sched.h
>>> +++ 2.6.24-rc3-mm2/include/linux/sched.h
>>> @@ -27,6 +27,7 @@
>>>  #define CLONE_NEWUSER		0x10000000	/* New user namespace */
>>>  #define CLONE_NEWPID		0x20000000	/* New pid namespace */
>>>  #define CLONE_NEWNET		0x40000000	/* New network namespace */
>>> +#define CLONE_NEWMQ		0x80000000	/* New posix mqueue namespace */
>> That's it :) We've run out of clone flags on 32-bit platforms :(
> 
> yes. 
> 
> I have been giving some thoughts to a clone2() to extend the flags but
> andrew is preparing to recycle CLONE_DETACHED and CLONE_STOPPED for
> 2.6.26. Some we might have some more time in front of us.

Two comments:

1) Does it ever make any sense to clone the IPC namespace *without* doing
so also for the MQ namespace or vice versa ?  Unless there is a good
reason for doing so, a single CLONE_IPCMQ flag would suffice.

2) Before coming up with a new clone2() or other solution, what about the
proposed (and debated) sys_indrect() -- if it gets merged it can provide
the solution.

Oren.

> 
> C.
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
