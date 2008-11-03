Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYKCTgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYKCTgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYKCTfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:35:54 -0500
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:54359 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbYKCTfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:35:53 -0500
Message-ID: <490F5276.6050808@cs.columbia.edu>
Date: Mon, 03 Nov 2008 14:35:18 -0500
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
X-Enigmail-Version: 0.95.7
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
> We have two options here: fork processes in kernel or fork them in user space.
> If process will be forked in user space, then there will be a gap when process 
> will be in user space and can be killed with received signal before entering 

> kernel. Also we will need a functionolity to create processes with predefined 
> PID. I think it is not very good to provide such ability to user space. That 

Rethinking this -- if the user wishes she can construct a suitable
checkpoint image that would do exactly that. It takes more effort than
using a system call, but the result is similar.

What I had in mind for that special clone-with-pid is to restrict when
it can be used (e.g. when the container is in a "restarting" state or
something like that.

[...]

Oren.



