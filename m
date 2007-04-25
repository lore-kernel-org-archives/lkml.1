Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbXDYFPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbXDYFPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 01:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbXDYFPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 01:15:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:3651 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbXDYFPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 01:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bV6AKWgnJ9I7tu1qoLTY3yCArp21js/Vw376EPsdWexbHgvFMSVKS/RWAqAOA/MkFp/+EfR1hGl/Qo/nsf2nEdzqCH6yzHXaXBDZ0MgLnp8OK4E/qVRaprzbtysKiVTSqwPzAtibgqRHGp/ep/zyl7koN2L2JGXFjCmRxCZlSLQ=
Message-ID: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>
Date: Tue, 24 Apr 2007 22:15:50 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       htejun@gmail.com
Subject: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- INFO: possible recursive locking detected
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[   59.677312] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
[   59.688633] NFSD: starting 90-second grace period
[   60.221454]
[   60.221456] =============================================
[   60.221461] [ INFO: possible recursive locking detected ]
[   60.221464] 2.6.21-rc7-mm1 #53
[   60.221466] ---------------------------------------------
[   60.221469] S20powernowd/3584 is trying to acquire lock:
[   60.221472]  (&sd->s_active){----}, at: [<c01a2436>]
sysfs_hash_and_remove+0x91/0x10e
[   60.221486]
[   60.221487] but task is already holding lock:
[   60.221489]  (&sd->s_active){----}, at: [<c01a2a20>]
sysfs_write_file+0xb9/0x14a
[   60.221496]
[   60.221497] other info that might help us debug this:
[   60.221499] 4 locks held by S20powernowd/3584:
[   60.221501]  #0:  (&sd->s_active){----}, at: [<c01a2a20>]
sysfs_write_file+0xb9/0x14a
[   60.221508]  #1:  (&sd->s_active){----}, at: [<c01a2a32>]
sysfs_write_file+0xcb/0x14a
[   60.221515]  #2:  (&per_cpu(cpu_policy_rwsem, cpu)){--..}, at:
[<c024081b>] lock_policy_rwsem_write+0x20/0x37
[   60.221524]  #3:  (userspace_mutex){--..}, at: [<c0299dfe>]
mutex_lock+0x1f/0x23
[   60.221534]
[   60.221535] stack backtrace:
[   60.221538]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
[   60.221543]  [<c0105a26>] show_trace+0x12/0x14
[   60.221547]  [<c0105ab3>] dump_stack+0x16/0x18
[   60.221551]  [<c0134d63>] __lock_acquire+0x12e/0xb4c
[   60.221557]  [<c01357e9>] lock_acquire+0x68/0x82
[   60.221561]  [<c012ddda>] down_write+0x3a/0x53
[   60.221567]  [<c01a2436>] sysfs_hash_and_remove+0x91/0x10e
[   60.221571]  [<c01a2bb0>] sysfs_remove_file+0x10/0x12
[   60.221575]  [<c0241756>] cpufreq_governor_userspace+0x10c/0x1dc
[   60.221579]  [<c023fd2b>] __cpufreq_governor+0x9c/0xd0
[   60.221583]  [<c023fed0>] __cpufreq_set_policy+0x171/0x209
[   60.221587]  [<c02400b5>] store_scaling_governor+0x14d/0x184
[   60.221591]  [<c0240bee>] store+0x3e/0x60
[   60.221594]  [<c01a2a85>] sysfs_write_file+0x11e/0x14a
[   60.221599]  [<c01699fb>] vfs_write+0x90/0x119
[   60.221605]  [<c0169eef>] sys_write+0x3d/0x61
[   60.221609]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
[   60.221613]  =======================
[   60.763809] Clocksource tsc unstable (delta = -75646443 ns)
