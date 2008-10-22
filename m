Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYJVLvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYJVLvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYJVLvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:51:38 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:38542 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYJVLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:51:37 -0400
Message-ID: <48FF13C0.6000805@fr.ibm.com>
Date: Wed, 22 Oct 2008 13:51:28 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, linux-api@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [RFC v7][PATCH 0/9] Kernel based checkpoint/restart
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>	<20081021122135.4bce362c.akpm@linux-foundation.org>	<1224621667.1848.228.camel@nimitz> <20081022092024.GC12453@elte.hu>
In-Reply-To: <20081022092024.GC12453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
>> On Tue, 2008-10-21 at 12:21 -0700, Andrew Morton wrote:
>>> On Mon, 20 Oct 2008 01:40:28 -0400
>>> Oren Laadan <orenl@cs.columbia.edu> wrote:
>>>> These patches implement basic checkpoint-restart [CR]. This version
>>>> (v7) supports basic tasks with simple private memory, and open files
>>>> (regular files and directories only).
>>> - how useful is this code as it stands in real-world usage?
>> Right now, an application must be specifically written to use these 
>> mew system calls.  It must be a single process and not share any 
>> resources with other processes.  The only file descriptors that may be 
>> open are simple files and may not include sockets or pipes.
>>
>> What this means in practice is that it is useful for a simple app 
>> doing computational work.
> 
> say a chemistry application doing calculations. Or a raytracer with a 
> large job. Both can take many hours (days!) even on very fast machine 
> and the restrictions on rebootability can hurt in such cases.
> 
> You should reach a minimal level of initial practical utility: say some 
> helper tool that allows testers to checkpoint and restore a real PovRay 
> session - without any modification to a stock distro PovRay.

There are the liblxc userspace tools doing that.

http://sourceforge.net/projects/lxc/

There are the lxc-checkpoint and lxc-restart commands to test the Oren's 
patches with the external checkpoint Cedric did. These commands are 
experimental and under development so a hack may be necessary for 
checkpoint/restart.

I didn't tried with Oren's external checkpoint yet, but I think the 
commands should work. Actually these commands relies on the freezer, so 
the checkpoint command does freeze, checkpoint, unfreeze. (and kill if 
specified).

	lxc-create -n foo

	lxc-start -n foo mypovray

	lxc-checkpoint -s -n foo > myckptfile

	lxc-restart -n foo < myckptfile

Thanks
   -- Daniel
