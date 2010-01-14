Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087Ab0ANCrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0ANCrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318Ab0ANCrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:47:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43603 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0ANCrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=D3D4P9GUB6541Ik3CPT8kggawkaSK1ycfBXONuErzzXrDNtKP9ABldTBcGlhTPpSvK
         3C63VFJCfOKHHZnbhhLqKGxtRz2ALnSjdmvTZMJmxwYnOsDNwFjYdRsluaX2ITrpJhIz
         Zrnkm4pCwATuujurgQLmZ6K+mUHEshEoTlYVw=
MIME-Version: 1.0
In-Reply-To: <m1wrzpbcmi.fsf@fess.ebiederm.org>
References: <a44ae5cd1001060454g22fb5a0ay8185bc680cd4fc67@mail.gmail.com>
	 <2375c9f91001100058w4bac1cf9s183fc37eafbfde75@mail.gmail.com>
	 <m13a2dho1o.fsf@fess.ebiederm.org> <201001101935.31882.rjw@sisk.pl>
	 <m1wrzpbcmi.fsf@fess.ebiederm.org>
Date: Wed, 13 Jan 2010 21:47:11 -0500
Message-ID: <a44ae5cd1001131847l582ad373j9a5c944327a06a0a@mail.gmail.com>
Subject: Re: 2.6.33-rc3 -- INFO: possible recursive locking -- 
	(s_active){++++.+}, at: [<c10d2941>] sysfs_hash_and_remove+0x3d/0x4f
From: Miles Lane <miles.lane@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm.  I tried your patch applied to a clean 2.6.33-rc4 tree, and used
the same .config file.  This time the INFO looks a lot like my
original bug report.  Weird.  Maybe I am doing something wrong!

[  291.124830] =============================================
[  291.124837] [ INFO: possible recursive locking detected ]
[  291.124846] 2.6.33-rc4 #3
[  291.124851] ---------------------------------------------
[  291.124858] pm-suspend/4725 is trying to acquire lock:
[  291.124865]  (s_active){++++.+}, at: [<c10f6115>]
sysfs_hash_and_remove+0x3d/0x4f
[  291.124888]
[  291.124890] but task is already holding lock:
[  291.124896]  (s_active){++++.+}, at: [<c10f792d>]
sysfs_get_active_two+0x16/0x34
[  291.124914]
[  291.124917] other info that might help us debug this:
[  291.124925] 6 locks held by pm-suspend/4725:
[  291.124930]  #0:  (&buffer->mutex){+.+.+.}, at: [<c10f68d0>]
sysfs_write_file+0x25/0xeb
[  291.124949]  #1:  (s_active){++++.+}, at: [<c10f792d>]
sysfs_get_active_two+0x16/0x34
[  291.124968]  #2:  (s_active/1){.+.+.+}, at: [<c10f7938>]
sysfs_get_active_two+0x21/0x34
[  291.124990]  #3:  (pm_mutex){+.+.+.}, at: [<c1066f92>] enter_state+0x26/0x114
[  291.125010]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<c10359dc>]
cpu_maps_update_begin+0xf/0x11
[  291.125030]  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<c1035a0a>]
cpu_hotplug_begin+0x1d/0x40
[  291.125049]
[  291.125051] stack backtrace:
[  291.125060] Pid: 4725, comm: pm-suspend Not tainted 2.6.33-rc4 #3
[  291.125067] Call Trace:
[  291.125081]  [<c12f458f>] ? printk+0xf/0x18
[  291.125094]  [<c105c00d>] __lock_acquire+0x811/0xb67
[  291.125108]  [<c105ae18>] ? mark_held_locks+0x43/0x5b
[  291.125121]  [<c105b1f6>] ? debug_check_no_locks_freed+0x108/0x126
[  291.125134]  [<c105b0b9>] ? trace_hardirqs_on_caller+0x119/0x141
[  291.125147]  [<c10f6115>] ? sysfs_hash_and_remove+0x3d/0x4f
[  291.125160]  [<c105c406>] lock_acquire+0xa3/0xcd
[  291.125172]  [<c10f6115>] ? sysfs_hash_and_remove+0x3d/0x4f
[  291.125186]  [<c10f77c2>] sysfs_addrm_finish+0xa6/0x10a
[  291.125198]  [<c10f6115>] ? sysfs_hash_and_remove+0x3d/0x4f
[  291.125214]  [<c10f6115>] sysfs_hash_and_remove+0x3d/0x4f
[  291.125227]  [<c10f867d>] sysfs_remove_group+0x52/0x81
[  291.125240]  [<c12f2b05>] mc_cpu_callback+0x73/0x9a
[  291.125253]  [<c104fa68>] notifier_call_chain+0x51/0x78
[  291.125266]  [<c104faf4>] __raw_notifier_call_chain+0xe/0x10
[  291.125278]  [<c12e6cad>] _cpu_down+0x7a/0x235
[  291.125291]  [<c1035a85>] disable_nonboot_cpus+0x58/0xe0
[  291.125305]  [<c1066e90>] suspend_devices_and_enter+0xc1/0x19d
[  291.125318]  [<c1067034>] enter_state+0xc8/0x114
[  291.125330]  [<c1066899>] state_store+0x93/0xa7
[  291.125342]  [<c1066806>] ? state_store+0x0/0xa7
[  291.125355]  [<c1165ad5>] kobj_attr_store+0x16/0x22
[  291.125368]  [<c10f696b>] sysfs_write_file+0xc0/0xeb
[  291.125381]  [<c10f68ab>] ? sysfs_write_file+0x0/0xeb
[  291.125394]  [<c10b749e>] vfs_write+0x80/0xdf
[  291.125407]  [<c10b7591>] sys_write+0x3b/0x5d
[  291.125420]  [<c10031e3>] sysenter_do_call+0x12/0x3c
[  291.228068] CPU 1 is now offline
