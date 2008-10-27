Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYJ0OkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYJ0OkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYJ0OkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:40:04 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:49991 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYJ0OkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:40:01 -0400
Message-ID: <4905D2AD.1070309@cs.columbia.edu>
Date: Mon, 27 Oct 2008 10:39:41 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>	<200810201614.36911.major@openvz.org>	<1224518105.1848.93.camel@nimitz> <200810271707.13580.major@openvz.org>
In-Reply-To: <200810271707.13580.major@openvz.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrey Mirkin wrote:
> On Monday 20 October 2008 19:55 Dave Hansen wrote:
>> On Mon, 2008-10-20 at 16:14 +0400, Andrey Mirkin wrote:
>>> Right now my patchset (v2) provides an ability to checkpoint and restart
>>> a group of processes. The process of checkpointing and restart can be
>>> initiated from external process (not from the process which should be
>>> checkpointed).
>> Absolutely.  Oren's code does it this way to make for a smaller patch at
>> first.  The syscall takes a pid argument so it is surely expected to be
>> expanded upon later.
>>
>>> Also I think that all the restart job (including process forking) should
>>> be done in kernel, as in this case we will not depend on user space and
>>> will be more secure. This is also implemented in my patchset.
>> Do you think that this is an approach that Oren's patches are married
>> to, or is this a "feature" we can add on later?
> 
> Well, AFAICS from Oren's patch set his approach is oriented on process 
> creation in user space. I think we should choose right now what approach will 
> be used for process creation.

This is inaccurate.

I intentionally did not address how processes will be created, by
simply allowing either way to be added to the patch.

I do agree that we probably want to decide how to do it. However,
there is also room to allow for both approaches, in a compatible
way, should we wish to explore both.

> We have two options here: fork processes in kernel or fork them in user space.
> If process will be forked in user space, then there will be a gap when process 
> will be in user space and can be killed with received signal before entering 

Why do we care about it ?
Why is there a difference if it is killed before or after entering
the kernel (e.g. user aborted restart, or kernel OOM kicked in) ?

> kernel. Also we will need a functionolity to create processes with predefined 
> PID. I think it is not very good to provide such ability to user space. That 
> is why we prefer in OpenVZ to do all the job in kernel.

This is the weak side of creating the processes in user space -
that we need such an interface. Note, however, that we can
easily "hide" it inside the interface of the sys_restart() call,
and restrict how it may be used.

Oren.

> 
>> I don't care which patch set we end up sticking in the kernel.  I'm
>> trying to figure out which code we can more easily build upon in the
>> future.  The fact that Oren's or yours can't do certain little things
>> right now does not bother me.
>>
>> Honestly, I'm a little more confident that everyone can work with Oren
>> since he managed to get 7 revisions of his patch out and make some
>> pretty large changes while in the same time the OpenVZ patch was only
>> released twice.  I'm not sure what has changed in the OpenVZ patch
>> between releases, either.
> 
> That is my fault. I am working right now on my Ph.D, that is why my activity 
> is not very high. But now I hope I will have more time for that.
> 
>> Are there any reasons that you absolutely can not use the code Oren
>> posted?  Will it not fulfill your needs somehow?  If so, could you
>> please elaborate on how?
> 
> We have one major difference with Oren's code - how processes are created 
> during restr.
> Right now I'm trying to port kernel process creation on top of Oren's patches.
> I agree that working in collaboration will speed up merging of checkpointing 
> to mainstream.
> 
> Andrey
> 
> P.S.: Sorry for late reply, my mailer attached your e-mail to wrong thread.
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
