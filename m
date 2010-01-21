Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828Ab0AUTSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab0AUTSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 14:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747Ab0AUTSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 14:18:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab0AUTSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:18:24 -0500
Date: Thu, 21 Jan 2010 14:18:12 -0500
From: Dave Jones <davej@redhat.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, venkatesh.pallipadi@intel.com,
       shaohua.li@intel.com
Subject: Re: 2.6.33-rc4-git7 -- head/6104 is trying to acquire lock:
 (cpuidle_lock){+.+.+.}, at: [<c129e2ec>] show_current_governor+0x12/0x4e
Message-ID: <20100121191812.GA1840@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Miles Lane <miles.lane@gmail.com>, Andi Kleen <andi@firstfloor.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>, venkatesh.pallipadi@intel.com,
	shaohua.li@intel.com
References: <a44ae5cd1001210950h34d57a5cq8b484ec4d3dbb48b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd1001210950h34d57a5cq8b484ec4d3dbb48b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 12:50:09PM -0500, Miles Lane wrote:
 > I was scanning the first few characters of all the files in /proc and
 > /sys.  I will attempt to determine which file(s) triggered this.


Dropped cpufreq-list from Cc, added cpuidle maintainers.
While they sound similar, they are unrelated.

	Dave



 > [15096.108361] [ INFO: possible circular locking dependency detected ]
 > [15096.108372] 2.6.33-rc4-git7 #13
 > [15096.108380] -------------------------------------------------------
 > [15096.108389] head/6104 is trying to acquire lock:
 > [15096.108398]  (cpuidle_lock){+.+.+.}, at: [<c129e2ec>]
 > show_current_governor+0x12/0x4e
 > [15096.108430]
 > [15096.108432] but task is already holding lock:
 > [15096.108441]  (s_active){++++.+}, at: [<c10f8c2e>]
 > sysfs_get_active_two+0x21/0x34
 > [15096.108468]
 > [15096.108471] which lock already depends on the new lock.
 > [15096.108474]
 > [15096.108482]
 > [15096.108484] the existing dependency chain (in reverse order) is:
 > [15096.108493]
 > [15096.108495] -> #1 (s_active){++++.+}:
 > [15096.108513]        [<c105cfe5>] __lock_acquire+0x9f5/0xb67
 > [15096.108533]        [<c105d1fa>] lock_acquire+0xa3/0xcd
 > [15096.108549]        [<c10f8ab8>] sysfs_addrm_finish+0x9a/0xfe
 > [15096.108566]        [<c10f8bb1>] sysfs_remove_dir+0x5e/0x6c
 > [15096.108580]        [<c11651c4>] kobject_del+0xf/0x2c
 > [15096.108595]        [<c1165213>] kobject_release+0x32/0x50
 > [15096.108609]        [<c1165d39>] kref_put+0x39/0x42
 > [15096.108624]        [<c116515d>] kobject_put+0x37/0x3c
 > [15096.108640]        [<c129e1f8>] cpuidle_free_state_kobj+0x18/0x36
 > [15096.108659]        [<c129e22a>] cpuidle_remove_state_sysfs+0x14/0x1e
 > [15096.108676]        [<c129dae8>] cpuidle_disable_device+0x3a/0x43
 > [15096.108693]        [<c129de48>] cpuidle_switch_governor+0x34/0x16c
 > [15096.108710]        [<c129e08a>] cpuidle_register_governor+0x8f/0xa9
 > [15096.108727]        [<c15191cb>] init_menu+0xd/0xf
 > [15096.108745]        [<c1001139>] do_one_initcall+0x4c/0x159
 > [15096.108761]        [<c14f4321>] kernel_init+0x128/0x179
 > [15096.108780]        [<c1003742>] kernel_thread_helper+0x6/0x1a
 > [15096.108797]
 > [15096.108800] -> #0 (cpuidle_lock){+.+.+.}:
 > [15096.108820]        [<c105cee7>] __lock_acquire+0x8f7/0xb67
 > [15096.108838]        [<c105d1fa>] lock_acquire+0xa3/0xcd
 > [15096.108856]        [<c131b1db>] __mutex_lock_common+0x39/0x44d
 > [15096.108873]        [<c131b67e>] mutex_lock_nested+0x2b/0x33
 > [15096.108889]        [<c129e2ec>] show_current_governor+0x12/0x4e
 > [15096.108907]        [<c1227b0d>] sysdev_class_show+0x1a/0x1e
 > [15096.108924]        [<c10f7d34>] sysfs_read_file+0x8e/0xf4
 > [15096.108939]        [<c10b9ff4>] vfs_read+0x7d/0xdc
 > [15096.108954]        [<c10ba0e7>] sys_read+0x3b/0x5d
 > [15096.108969]        [<c10031e3>] sysenter_do_call+0x12/0x3c
 > [15096.108986]
 > [15096.108989] other info that might help us debug this:
 > [15096.108992]
 > [15096.109003] 3 locks held by head/6104:
 > [15096.109010]  #0:  (&buffer->mutex){+.+.+.}, at: [<c10f7cca>]
 > sysfs_read_file+0x24/0xf4
 > [15096.109039]  #1:  (s_active){++++.+}, at: [<c10f8c23>]
 > sysfs_get_active_two+0x16/0x34
 > [15096.109057]  #2:  (s_active){++++.+}, at: [<c10f8c2e>]
 > sysfs_get_active_two+0x21/0x34
 > [15096.109057]
 > [15096.109057] stack backtrace:
 > [15096.109057] Pid: 6104, comm: head Not tainted 2.6.33-rc4-git7 #13
 > [15096.109057] Call Trace:
 > [15096.109057]  [<c131a026>] ? printk+0xf/0x11
 > [15096.109057]  [<c105c2b4>] print_circular_bug+0x8a/0x96
 > [15096.109057]  [<c105cee7>] __lock_acquire+0x8f7/0xb67
 > [15096.109057]  [<c129e2ec>] ? show_current_governor+0x12/0x4e
 > [15096.109057]  [<c105d1fa>] lock_acquire+0xa3/0xcd
 > [15096.109057]  [<c129e2ec>] ? show_current_governor+0x12/0x4e
 > [15096.109057]  [<c131b1db>] __mutex_lock_common+0x39/0x44d
 > [15096.109057]  [<c129e2ec>] ? show_current_governor+0x12/0x4e
 > [15096.109057]  [<c105d1fa>] ? lock_acquire+0xa3/0xcd
 > [15096.109057]  [<c10f8c2e>] ? sysfs_get_active_two+0x21/0x34
 > [15096.109057]  [<c131b67e>] mutex_lock_nested+0x2b/0x33
 > [15096.109057]  [<c129e2ec>] ? show_current_governor+0x12/0x4e
 > [15096.109057]  [<c129e2ec>] show_current_governor+0x12/0x4e
 > [15096.109057]  [<c129e2da>] ? show_current_governor+0x0/0x4e
 > [15096.109057]  [<c1227b0d>] sysdev_class_show+0x1a/0x1e
 > [15096.109057]  [<c10f7d34>] sysfs_read_file+0x8e/0xf4
 > [15096.109057]  [<c1146736>] ? security_file_permission+0xf/0x11
 > [15096.109057]  [<c10f7ca6>] ? sysfs_read_file+0x0/0xf4
 > [15096.109057]  [<c10b9ff4>] vfs_read+0x7d/0xdc
 > [15096.109057]  [<c10ba0e7>] sys_read+0x3b/0x5d
 > [15096.109057]  [<c10031e3>] sysenter_do_call+0x12/0x3c
 
