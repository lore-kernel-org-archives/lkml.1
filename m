Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab0BOBWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 20:22:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45273 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab0BOBWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 20:22:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 15 Feb 2010 10:19:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Anton Starikov <ant.starikov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: 2.6.31 and OOM killer = bug?
Message-Id: <20100215101917.15552a51.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <E0975165-4185-47A9-A15F-B46774A5F6DA@gmail.com>
References: <E0975165-4185-47A9-A15F-B46774A5F6DA@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Feb 2010 00:43:02 +0100
Anton Starikov <ant.starikov@gmail.com> wrote:

> Hi,
> 
> The setup:
> is 16-core opteron node, diskless with NFS root, swapless, 64GB of RAM. Operating under OpenSUSE 11.2. With kernel version 2.6.31. Although it isn't vanilla, I think probably more right is to submit this into LKML.
> 

At first, what is the version of kernel you are comparing with ? 2.6.22?(If OpenSuse10)
If so, many changes since that..

> The problem:
> On this node user run MPI job with 16 processes, local job by using shared memory communication.  
> At some point this processes are trying to use more memory that available.
> Normally, all of them or part of them would be killed by OOM killer, and it use to work for years over many versions of kernel.
> 
> Now, with fresh setup I got something new. OOM tried to kill, but didn't succeed, and even more, brought system in unusable state. All those processes are locked and un-killable. some of other processes are also locked and un-killable/inaccessible. kswapd consume 100% CPU (which I think is expected behavior when there is no free memory). 
> No free memory obviously, cause all original processes are still in memory.
> 
> I tried to test OOM behavior and it always happens like that now.
> 
> Here I attach full gzipped log of all related information captured by logserver (sent by logserver and netconsole, so it can be partly doubled). Sorry that it is too big, but I didn't know what information can be important.
> 

Anyway, I think it's not appreciated to depend on OOM-Kill on swapless-system.
I recommend you to use cgroup "memory" to encapsulate your apps (but please check
the performance regression can be seen or not..)

Thanks,
-Kame

