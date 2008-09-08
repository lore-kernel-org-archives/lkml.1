Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYIHQUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYIHQUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYIHQUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:20:04 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:63481 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYIHQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:20:03 -0400
Message-ID: <48C54DDC.3090704@fr.ibm.com>
Date: Mon, 08 Sep 2008 18:07:56 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrey Mirkin <amirkin@parallels.com>
CC: devel@openvz.org, jeremy@goop.org, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, Andrey Mirkin <major@openvz.org>
Subject: Re: [Devel] Re: [RFC v3][PATCH 1/9] Create syscalls: sys_checkpoint,
 sys_restart
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>	<Pine.LNX.4.64.0809040401320.5982@takamine.ncl.cs.columbia.edu>	<20080904144223.GA19364@us.ibm.com> <200809081902.33709.amirkin@parallels.com>
In-Reply-To: <200809081902.33709.amirkin@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> --- /dev/null
>>> +++ b/checkpoint/sys.c
>>> @@ -0,0 +1,35 @@
>>> +/*
>>> + *  Generic container checkpoint-restart
>>> + *
>>> + *  Copyright (C) 2008 Oren Laadan
>>> + *
>>> + *  This file is subject to the terms and conditions of the GNU General
>>> Public + *  License.  See the file COPYING in the main directory of the
>>> Linux + *  distribution for more details.
>>> + */
>>> +
>>> +#include <linux/sched.h>
>>> +#include <linux/kernel.h>
>>> +
>>> +/**
>>> + * sys_checkpoint - checkpoint a container
>>> + * @pid: pid of the container init(1) process
>>> + * @fd: file to which dump the checkpoint image
>>> + * @flags: checkpoint operation flags
>>> + */
>>> +asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags)
>>> +{
>>> +	pr_debug("sys_checkpoint not implemented yet\n");
>>> +	return -ENOSYS;
>>> +}
>>> +/**
>>> + * sys_restart - restart a container
>>> + * @crid: checkpoint image identifier
>> So can we compare your api to Andrey's?

Jumping in the API thread : how will this API interact with the namespaces ? 

I think the exact question is how are we seeing the restart sequence ?
shall we (1) restart from inside a set of pre established namespaces or 
(2) restore the state of the namespaces upon restart ? 

I think (1) is the best option in semantic, because it's closer to what
the kernel does:  create a directory (a container) and then fill it with
files (tasks). That's how the cgroup framework works and I have the
feeling we will be using this framework to build the 'super' container
object. nop ?

This direction has an impact on the API because the restart sequence 
will depend on a set of preliminary settings to create an 'empty' 
container which can then be used to exec() tasks or restart() tasks. This 
is a very different API than a magical restart() syscall creating 
hundreds of namespaces and zillions of tasks from scratch using an 
opaque binary blob. less attractive for sure but it feels more kernel 
friendly :)


But, may be you have addressed this topic at the summit and the question
is closed ?

C. 
