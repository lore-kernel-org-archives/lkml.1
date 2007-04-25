Return-Path: <linux-kernel-owner+w=401wt.eu-S1161475AbXDYOtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161475AbXDYOtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161478AbXDYOtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:49:01 -0400
Received: from ag-out-0708.google.com ([72.14.246.245]:47619 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161475AbXDYOs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V9DmLFR+T1qiQW+fZUP1b8+cUhveg1udDBoTtaYD5cl/3SUsKWoebBoJUruGhxKkNDEqfJgVf254oc0mk6PdnMR7n7NnX8VbgyMg+XtBnisDxKqQbjuEuynH+1cNc5TkcXSxBQi95clNU0D/KsHABXf8UMY2ngdfcwrHuYQMFwo=
Subject: Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- INFO: possible
	recursive locking detected
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <462EE4B7.6000708@gmail.com>
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>
	 <462EE4B7.6000708@gmail.com>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 22:48:48 +0800
Message-Id: <1177512528.4856.15.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 14:18 +0900, Tejun Heo wrote:
> Miles Lane wrote:
> > [   59.677312] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
> > recovery directory
> > [   59.688633] NFSD: starting 90-second grace period
> > [   60.221454]
> > [   60.221456] =============================================
> > [   60.221461] [ INFO: possible recursive locking detected ]
> > [   60.221464] 2.6.21-rc7-mm1 #53
> > [   60.221466] ---------------------------------------------
> > [   60.221469] S20powernowd/3584 is trying to acquire lock:
> > [   60.221472]  (&sd->s_active){----}, at: [<c01a2436>]
> > sysfs_hash_and_remove+0x91/0x10e
> > [   60.221486]
> > [   60.221487] but task is already holding lock:
> > [   60.221489]  (&sd->s_active){----}, at: [<c01a2a20>]
> > sysfs_write_file+0xb9/0x14a
> > [   60.221496]
> > [   60.221497] other info that might help us debug this:
> > [   60.221499] 4 locks held by S20powernowd/3584:
> > [   60.221501]  #0:  (&sd->s_active){----}, at: [<c01a2a20>]
> > sysfs_write_file+0xb9/0x14a
> > [   60.221508]  #1:  (&sd->s_active){----}, at: [<c01a2a32>]
> > sysfs_write_file+0xcb/0x14a
> > [   60.221515]  #2:  (&per_cpu(cpu_policy_rwsem, cpu)){--..}, at:
> > [<c024081b>] lock_policy_rwsem_write+0x20/0x37
> > [   60.221524]  #3:  (userspace_mutex){--..}, at: [<c0299dfe>]
> > mutex_lock+0x1f/0x23
> 
> Thanks for reporting.  We need to separate s_active users into two
> classes - one for r/w the other for deleting for nodes which delete
> other nodes when written to.  Will post a patch soon.
> 

I'm still getting this, with or without this patch applied. After this,
none of the ethernet cards work.

eth0 renamed to eth54
BUG: atomic counter underflow at:
 [<c0104378>] show_trace_log_lvl+0x1a/0x30
 [<c0104ec9>] show_trace+0x12/0x14
 [<c0104f22>] dump_stack+0x16/0x18
 [<c01bd575>] _atomic_dec_and_lock+0x29/0x4c
 [<c0174388>] dput+0x34/0x103
 [<c019d181>] sysfs_drop_dentry+0x141/0x149
 [<c019d212>] sysfs_hash_and_remove+0x89/0x10e
 [<c019f1fc>] sysfs_remove_link+0xe/0x10
 [<c0221839>] device_rename+0x110/0x181
 [<c025420a>] dev_change_name+0x11e/0x1ca
 [<c02545e6>] dev_ifsioc+0x330/0x3d7
 [<c0254d25>] dev_ioctl+0x350/0x46e
 [<c0249792>] sock_ioctl+0x1be/0x1ca
 [<c016f3c0>] do_ioctl+0x1c/0x53
 [<c016f5e3>] vfs_ioctl+0x1ec/0x203
 [<c016f643>] sys_ioctl+0x49/0x62
 [<c0103cde>] sysenter_past_esp+0x5f/0x99
 =======================
eth1 renamed to eth44
BUG: atomic counter underflow at:
 [<c0104378>] show_trace_log_lvl+0x1a/0x30
 [<c0104ec9>] show_trace+0x12/0x14
 [<c0104f22>] dump_stack+0x16/0x18
 [<c01bd575>] _atomic_dec_and_lock+0x29/0x4c
 [<c0174388>] dput+0x34/0x103
 [<c019d181>] sysfs_drop_dentry+0x141/0x149
 [<c019d212>] sysfs_hash_and_remove+0x89/0x10e
 [<c019f1fc>] sysfs_remove_link+0xe/0x10
 [<c0221839>] device_rename+0x110/0x181
 [<c025420a>] dev_change_name+0x11e/0x1ca
 [<c02545e6>] dev_ifsioc+0x330/0x3d7
 [<c0254d25>] dev_ioctl+0x350/0x46e
 [<c0249792>] sock_ioctl+0x1be/0x1ca
 [<c016f3c0>] do_ioctl+0x1c/0x53
 [<c016f5e3>] vfs_ioctl+0x1ec/0x203
 [<c016f643>] sys_ioctl+0x49/0x62
 [<c0103cde>] sysenter_past_esp+0x5f/0x99
 =======================
ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [LNKC] -> GSI 10 (level,
low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:11.5 to 64
eth2 renamed to eth1
BUG: atomic counter underflow at:
 [<c0104378>] show_trace_log_lvl+0x1a/0x30
 [<c0104ec9>] show_trace+0x12/0x14
 [<c0104f22>] dump_stack+0x16/0x18
 [<c01bd575>] _atomic_dec_and_lock+0x29/0x4c
 [<c0174388>] dput+0x34/0x103
 [<c019d181>] sysfs_drop_dentry+0x141/0x149
 [<c019d212>] sysfs_hash_and_remove+0x89/0x10e
 [<c019f1fc>] sysfs_remove_link+0xe/0x10
 [<c0221839>] device_rename+0x110/0x181
 [<c025420a>] dev_change_name+0x11e/0x1ca
 [<c02545e6>] dev_ifsioc+0x330/0x3d7
 [<c0254d25>] dev_ioctl+0x350/0x46e
 [<c0249792>] sock_ioctl+0x1be/0x1ca
 [<c016f3c0>] do_ioctl+0x1c/0x53
 [<c016f5e3>] vfs_ioctl+0x1ec/0x203
 [<c016f643>] sys_ioctl+0x49/0x62
 [<c0103cde>] sysenter_past_esp+0x5f/0x99
 =======================

Tony

