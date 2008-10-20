Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYJTRYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYJTRYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbYJTRR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:17:59 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:46910 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbYJTRR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:17:57 -0400
Message-ID: <48FCBD24.7070902@cs.columbia.edu>
Date: Mon, 20 Oct 2008 13:17:24 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: devel@openvz.org, containers@lists.linux-foundation.org,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>	<1224286383.1848.65.camel@nimitz> <200810201614.36911.major@openvz.org>
In-Reply-To: <200810201614.36911.major@openvz.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrey Mirkin wrote:
> On Saturday 18 October 2008 03:33 Dave Hansen wrote:
>> On Wed, 2008-09-03 at 14:57 +0400, Andrey Mirkin wrote:
>>> This patchset introduces kernel based checkpointing/restart as it is
>>> implemented in OpenVZ project. This patchset has limited functionality
>>> and are able to checkpoint/restart only single process. Recently Oren
>>> Laaden sent another kernel based implementation of checkpoint/restart.
>>> The main differences between this patchset and Oren's patchset are:
>> Hi Andrey,
>>
>> I'm curious what you want to happen with this patch set.  Is there
>> something specific in Oren's set that deficient which you need
>> implemented?  Are there some technical reasons you prefer this code?
> 
> Hi Dave,
> 
> Right now my patchset (v2) provides an ability to checkpoint and restart a 
> group of processes. The process of checkpointing and restart can be initiated 
> from external process (not from the process which should be checkpointed).

Both patchsets share the same design, namely be able to checkpoint and
restart multiple processes, with the operation initiated by an external
processes.

I deliberately left out the part that handles multiple processes to
keeps things simple for initial review, and until we decide on the
question of kernel- or user- based process creation on restart.

> Also I think that all the restart job (including process forking) should be 
> done in kernel, as in this case we will not depend on user space and will be 
> more secure. This is also implemented in my patchset.

I'm not convinced that creating the processes in the kernel makes it
more secure.  Can you elaborate ?  for the discussion, let's compare
these two basic scenarios:

1) container and processes are created in user space; each process
calls "sys_restart()" which eventually calls "do_restart()" that
does kernel-based restart.

2) container and processes are created in kernel space; each process
calls "do_restart()" to do kernel-based restart.

In fact, creating in user based makes it easier to enforce capabilities
and limits of the user. It also simplifies the debugging significantly,
and allows us to delegate the entire issue of containers and namespace
management back to user space, where it probably belongs.

On the other hand, doing it in kernel space likely to produce simpler
code for the creation of the processes.

Thanks,

Oren.

