Return-Path: <linux-kernel-owner+w=401wt.eu-S1161603AbXDYFTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161603AbXDYFTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 01:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161618AbXDYFTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 01:19:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:5485 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161603AbXDYFS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 01:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=F/5bKSeuI3fwGN+jncNpQLOTngzYAuISnuT/5VuVIO7H0Z3+aBPqxwQlUSPutTzvf+0YHdPvgqMHFjMcCQi2VNXuZGMKyFdgGwFzgUB8PH4+rwNKWEuXUx1sXir3Rjho8+0mUUUBOW748xVncLr6lEKehoJ+l6Nm7MhcYvJJRu8=
Message-ID: <462EE4B7.6000708@gmail.com>
Date: Wed, 25 Apr 2007 14:18:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- INFO: possible
 recursive locking detected
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>
In-Reply-To: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> [   59.677312] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
> recovery directory
> [   59.688633] NFSD: starting 90-second grace period
> [   60.221454]
> [   60.221456] =============================================
> [   60.221461] [ INFO: possible recursive locking detected ]
> [   60.221464] 2.6.21-rc7-mm1 #53
> [   60.221466] ---------------------------------------------
> [   60.221469] S20powernowd/3584 is trying to acquire lock:
> [   60.221472]  (&sd->s_active){----}, at: [<c01a2436>]
> sysfs_hash_and_remove+0x91/0x10e
> [   60.221486]
> [   60.221487] but task is already holding lock:
> [   60.221489]  (&sd->s_active){----}, at: [<c01a2a20>]
> sysfs_write_file+0xb9/0x14a
> [   60.221496]
> [   60.221497] other info that might help us debug this:
> [   60.221499] 4 locks held by S20powernowd/3584:
> [   60.221501]  #0:  (&sd->s_active){----}, at: [<c01a2a20>]
> sysfs_write_file+0xb9/0x14a
> [   60.221508]  #1:  (&sd->s_active){----}, at: [<c01a2a32>]
> sysfs_write_file+0xcb/0x14a
> [   60.221515]  #2:  (&per_cpu(cpu_policy_rwsem, cpu)){--..}, at:
> [<c024081b>] lock_policy_rwsem_write+0x20/0x37
> [   60.221524]  #3:  (userspace_mutex){--..}, at: [<c0299dfe>]
> mutex_lock+0x1f/0x23

Thanks for reporting.  We need to separate s_active users into two
classes - one for r/w the other for deleting for nodes which delete
other nodes when written to.  Will post a patch soon.

-- 
tejun
