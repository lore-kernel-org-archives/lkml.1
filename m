Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbXIWBw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbXIWBw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbXIWBwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:52:22 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40068 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751307AbXIWBwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:52:21 -0400
Message-ID: <390512340.25655@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 23 Sep 2007 09:52:17 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [BUG 2.6.23-rc6-mm1] NMI Watchdog detected LOCKUP on CPU 0
Message-ID: <20070923015217.GA5956@mail.ustc.edu.cn>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070923014214.GA16766@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070923014214.GA16766@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2007 at 09:42:14AM +0800, Fengguang Wu wrote:
> On Tue, Sep 18, 2007 at 01:18:41AM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> > 
> > 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> 
> 
> This bug appears in 2.6.23-rc3-mm1, too.
> 
> The message:
> 
> [ 3267.844826] NMI Watchdog detected LOCKUP on CPU 0
> [ 3267.849515] CPU 0 
> [ 3267.851525] Modules linked in: binfmt_misc ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 iptable_filter ip_tables x_tables nf_nat_tftp nf_nat_ftp nf_nat nf_conntrack_tftp nf_conntrack_ftp nf_conntrack nfnetlink fan ac battery ipv6 eeprom lm85 hwmon_vid i2c_core tun fuse kvm snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd sg soundcore snd_page_alloc thermal sr_mod pcspkr evdev button processor cdrom
> [ 3267.889547] Pid: 13507, comm: gcc Not tainted 2.6.23-rc6-mm1 #4
> [ 3267.895442] RIP: 0033:[<00002ab84e34cd44>]  [<00002ab84e34cd44>]
> [ 3267.901438] RSP: 002b:00007fff5c9e03f8  EFLAGS: 00000287
> [ 3267.906726] RAX: 0000000000000000 RBX: 00007fff5c9e0580 RCX: 0000000000000000
> [ 3267.913833] RDX: 0000000000000013 RSI: 00007fff5c9e0680 RDI: 00000000012a7010
> [ 3267.920939] RBP: 00007fff5c9e0550 R08: 0000000000000050 R09: 0000000000000000
> [ 3267.928045] R10: 0000000000000000 R11: 00000000012a7410 R12: 0000000000000002
> [ 3267.935151] R13: 0000000000000003 R14: 0000000000000005 R15: 000000000000001f
> [ 3267.942258] FS:  00002ab84f144170(0000) GS:ffffffff814f3000(0000) knlGS:0000000000000000
> [ 3267.950317] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3267.956038] CR2: 00002ab84e3a7430 CR3: 000000000d618000 CR4: 00000000000006e0
> [ 3267.963144] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 3267.970250] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 3267.977357] Process gcc (pid: 13507, threadinfo ffff81000ebe6000, task ffff810008b849d0)
> [ 3267.985416] 
> [ 3267.997480] Unable to handle kernel paging request at 00000000fffffffe RIP: 
> [ 3268.002082]  [<00000000fffffffe>]
> [ 3268.007827] PGD ea85067 PUD 0 
> [ 3268.010887] Oops: 0010 [1] SMP 
> [ 3268.014035] last sysfs file: /devices/pci0000:00/0000:00:1e.0/0000:05:04.0/resource
> [ 3268.021662] CPU 0 
> [ 3268.023674] Modules linked in: binfmt_misc ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 iptable_filter ip_tables x_tables nf_nat_tftp nf_nat_ftp nf_nat nf_conntrack_tftp nf_conntrack_ftp nf_conntrack nfnetlink fan ac battery ipv6 eeprom lm85 hwmon_vid i2c_core tun fuse kvm snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd sg soundcore snd_page_alloc thermal sr_mod pcspkr evdev button processor cdrom
> [ 3268.061688] Pid: 13507, comm: gcc Not tainted 2.6.23-rc6-mm1 #4
> [ 3268.067584] RIP: 0010:[<00000000fffffffe>]  [<00000000fffffffe>]
> [ 3268.073578] RSP: 0000:ffffffff8157ce38  EFLAGS: 00010296
> [ 3268.078867] RAX: 0000000000002710 RBX: ffff810009787050 RCX: ffff8100036788e0
> [ 3268.085973] RDX: 000000000000018d RSI: ffffffff810ba000 RDI: ffff810009787080
> [ 3268.093080] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [ 3268.100185] R10: 0000000000000000 R11: 0000000000000001 R12: ffff810008b849d0
> [ 3268.107293] R13: ffff810008b850d0 R14: 0000000000000001 R15: ffffffff8157cf58
> [ 3268.114399] FS:  00002ab84f144170(0000) GS:ffffffff814f3000(0000) knlGS:0000000000000000
> [ 3268.122455] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 3268.128178] CR2: 00000000fffffffe CR3: 0000000006bfd000 CR4: 00000000000006e0
> [ 3268.135283] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 3268.142388] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 3268.149495] Process gcc (pid: 13507, threadinfo ffff81000ebe6000, task ffff810008b849d0)
> [ 3268.157552] last branch before last exception/interrupt
> [ 3268.162753]  from  [<ffffffff811b1843>] serial_in+0x23/0x80
> [ 3268.168316]  to  [<ffffffff811b1832>] serial_in+0x12/0x80
> [ 3268.173701] Stack:  ffffffff8157ce78 ffffffff812e214f ffff81000ebe7fd8 0000000000000000
> [ 3268.181728]  0000000000000000 000000000ebe7f2d 000000000000003d ffffffff8157cf58
> [ 3268.189133]  ffffffff8157ce88 ffffffff812e218d ffffffff8157ce98 ffffffff812e21a1
> [ 3268.196358] Call Trace:
> [ 3268.198974] Inexact backtrace:
> [ 3268.202014]  <NMI>  [<ffffffff812e214f>] notifier_call_chain+0x3f/0x70
> [ 3268.208531]  [<ffffffff812e218d>] __atomic_notifier_call_chain+0xd/0x10
> [ 3268.215118]  [<ffffffff812e21a1>] atomic_notifier_call_chain+0x11/0x20
> [ 3268.221619]  [<ffffffff81056dde>] notify_die+0x2e/0x30
> [ 3268.226736]  [<ffffffff812e0b1c>] nmi_watchdog_tick+0x4c/0x1e0
> [ 3268.232545]  [<ffffffff812e0257>] default_do_nmi+0x67/0x1e0
> [ 3268.238093]  [<ffffffff812e0cdf>] do_nmi+0x2f/0x50
> [ 3268.242863]  [<ffffffff812dffef>] nmi+0x7f/0x90
> [ 3268.247377]  [<ffffffff81151c3e>] __delay+0xe/0x20
> [ 3268.252147]  <<EOE>> 
> [ 3268.254416] 
> [ 3268.254416] Code:  Bad RIP value.
> [ 3268.259216] RIP  [<00000000fffffffe>]
> [ 3268.262871]  RSP <ffffffff8157ce38>
> [ 3268.266342] CR2: 00000000fffffffe
> [ 3268.269821] Fixing recursive fault but reboot is needed!

Here are more messages on rebooting(I didn't mount any fuse fs though):

[ 3869.554219] slab error in verify_redzone_free(): cache `ext3_inode_cache': memory outside object was overwritten
[ 3869.564417] 
[ 3869.564418] Call Trace:
[ 3869.568422]  [<ffffffff8100dbc9>] dump_trace+0x3f9/0x4a0
[ 3869.573756]  [<ffffffff8100dcb3>] show_trace+0x43/0x60
[ 3869.578926]  [<ffffffff8100dce5>] dump_stack+0x15/0x20
[ 3869.584085]  [<ffffffff8109afa4>] __slab_error+0x24/0x30
[ 3869.589431]  [<ffffffff8109ba23>] cache_free_debugcheck+0x143/0x1e0
[ 3869.595716]  [<ffffffff8109dd60>] kfree+0xa0/0x240
[ 3869.600541]  [<ffffffff8114bb30>] kobject_cleanup+0x90/0xa0
[ 3869.606136]  [<ffffffff8114bb4d>] kobject_release+0xd/0x10
[ 3869.611654]  [<ffffffff8114cca3>] kref_put+0x43/0x80
[ 3869.616638]  [<ffffffff8114ba99>] kobject_put+0x19/0x20
[ 3869.621895]  [<ffffffff8114bcab>] kobject_unregister+0x2b/0x40
[ 3869.627745]  [<ffffffff8114bcd2>] kset_unregister+0x12/0x20
[ 3869.633349]  [<ffffffff8114bce9>] subsystem_unregister+0x9/0x10
[ 3869.639291]  [<ffffffff88122550>] :fuse:fuse_sysfs_cleanup+0x10/0x20
[ 3869.645669]  [<ffffffff88123b4c>] :fuse:fuse_exit+0x1c/0x2c
[ 3869.651265]  [<ffffffff81063bf1>] sys_delete_module+0x1b1/0x290
[ 3869.657202]  [<ffffffff8100c40e>] system_call+0x7e/0x83
[ 3869.662449]  [<00007f5c807c6ef7>]
[ 3869.665797] 
[ 3869.667317] ffffffff881245f3: redzone 1:0x786574756d5f74, redzone 2:0x0.
[ 3869.674050] ------------[ cut here ]------------
[ 3869.678688] kernel BUG at mm/slab.c:2901!
[ 3869.682717] invalid opcode: 0000 [2] SMP 
[ 3869.686812] last sysfs file: /devices/pci0000:00/0000:00:1e.0/0000:05:04.0/class
[ 3869.694231] CPU 0 
[ 3869.696302] Modules linked in: binfmt_misc ipt_MASQUERADE iptable_mangle iptable_nat nf_conntrack_ipv4 iptable_filter ip_tables x_tables nf_nat_tftp nf_nat_ftp nf_nat nf_conntrack_tftp nf_conntrack_ftp nf_conntrack nfnetlink fan ac battery ipv6 eeprom lm85 hwmon_vid i2c_core tun fuse kvm snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd sg soundcore snd_page_alloc thermal sr_mod pcspkr evdev button processor cdrom
[ 3869.735440] Pid: 5754, comm: rmmod Tainted: G      D 2.6.23-rc6-mm1 #4
[ 3869.741982] RIP: 0010:[<ffffffff8109ba9a>]  [<ffffffff8109ba9a>] cache_free_debugcheck+0x1ba/0x1e0
[ 3869.750994] RSP: 0018:ffff8100096cbd98  EFLAGS: 00010002
[ 3869.756324] RAX: 001f446745213ca4 RBX: ffff8100059ca440 RCX: ffff8100081240c0
[ 3869.763469] RDX: 00000000001f4467 RSI: ffffffff881245f3 RDI: ffff8100059ca440
[ 3869.770616] RBP: ffff8100096cbdc8 R08: 0000000000000000 R09: 0000000000000001
[ 3869.777762] R10: 0000000000000000 R11: ffffffff8130b040 R12: ffffffff881245f3
[ 3869.784909] R13: 00786574756d5f74 R14: 0000000000000000 R15: ffff810008124080
[ 3869.792057] FS:  00007f5c80c496e0(0000) GS:ffffffff814f3000(0000) knlGS:0000000000000000
[ 3869.800171] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3869.805932] CR2: 00007f5c807684e0 CR3: 000000000663b000 CR4: 00000000000006e0
[ 3869.813079] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3869.820226] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3869.827372] Process rmmod (pid: 5754, threadinfo ffff8100096ca000, task ffff810006478080)
[ 3869.835572] last branch before last exception/interrupt
[ 3869.840812]  from  [<ffffffff811b1843>] serial_in+0x23/0x80
[ 3869.846436]  to  [<ffffffff811b1832>] serial_in+0x12/0x80
[ 3869.851884] Stack:  ffffffff8114bb30 ffff8100059ca440 ffff8100059cbea8 ffffffff881245fb
[ 3869.860079]  ffffffff8812b310 0000000000000286 ffff8100096cbe18 ffffffff8109dd60
[ 3869.867634]  ffff8100096cbe18 ffffffff810f2516 ffff810007ce92d8 ffffffff8812b270
[ 3869.874968] Call Trace:
[ 3869.877660]  [<ffffffff8109dd60>] kfree+0xa0/0x240
[ 3869.882470]  [<ffffffff8114bb30>] kobject_cleanup+0x90/0xa0
[ 3869.888059]  [<ffffffff8114bb4d>] kobject_release+0xd/0x10
[ 3869.893561]  [<ffffffff8114cca3>] kref_put+0x43/0x80
[ 3869.898545]  [<ffffffff8114ba99>] kobject_put+0x19/0x20
[ 3869.903789]  [<ffffffff8114bcab>] kobject_unregister+0x2b/0x40
[ 3869.909638]  [<ffffffff8114bcd2>] kset_unregister+0x12/0x20
[ 3869.915226]  [<ffffffff8114bce9>] subsystem_unregister+0x9/0x10
[ 3869.921165]  [<ffffffff88122550>] :fuse:fuse_sysfs_cleanup+0x10/0x20
[ 3869.927539]  [<ffffffff88123b4c>] :fuse:fuse_exit+0x1c/0x2c
[ 3869.933133]  [<ffffffff81063bf1>] sys_delete_module+0x1b1/0x290
[ 3869.939069]  [<ffffffff8100c40e>] system_call+0x7e/0x83
[ 3869.944313]  [<00007f5c807c6ef7>]
[ 3869.947650] 
[ 3869.949170] 
[ 3869.949170] Code: 0f 0b eb fe 66 90 0f 0b eb fe 48 8b 52 10 e9 8b fe ff ff 0f 
[ 3869.958656] RIP  [<ffffffff8109ba9a>] cache_free_debugcheck+0x1ba/0x1e0
[ 3869.965317]  RSP <ffff8100096cbd98>
[ 3869.968831] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[ 3869.976526] in_atomic():0, irqs_disabled():1
[ 3869.980816] 
[ 3869.980817] Call Trace:
[ 3869.984808]  [<ffffffff8100dbc9>] dump_trace+0x3f9/0x4a0
[ 3869.990139]  [<ffffffff8100dcb3>] show_trace+0x43/0x60
[ 3869.995296]  [<ffffffff8100dce5>] dump_stack+0x15/0x20
[ 3870.000454]  [<ffffffff81031f51>] __might_sleep+0xc1/0xe0
[ 3870.005873]  [<ffffffff810561fd>] down_read+0x1d/0x30
[ 3870.010945]  [<ffffffff81067d25>] acct_collect+0x45/0x1d0
[ 3870.016361]  [<ffffffff8103f9f0>] do_exit+0x190/0xad0
[ 3870.021431]  [<ffffffff812e0161>] oops_end+0x91/0xa0
[ 3870.026414]  [<ffffffff8100e0fe>] die+0x5e/0x90
[ 3870.030965]  [<ffffffff812e0612>] do_trap+0x132/0x140
[ 3870.036035]  [<ffffffff8100e620>] do_invalid_op+0x90/0xb0
[ 3870.041452]  [<ffffffff812dfd4d>] error_exit+0x0/0x84
[ 3870.046523]  [<ffffffff8109ba9a>] cache_free_debugcheck+0x1ba/0x1e0
[ 3870.052804]  [<ffffffff8109dd60>] kfree+0xa0/0x240
[ 3870.057616]  [<ffffffff8114bb30>] kobject_cleanup+0x90/0xa0
[ 3870.063206]  [<ffffffff8114bb4d>] kobject_release+0xd/0x10
[ 3870.068708]  [<ffffffff8114cca3>] kref_put+0x43/0x80
[ 3870.073693]  [<ffffffff8114ba99>] kobject_put+0x19/0x20
[ 3870.078936]  [<ffffffff8114bcab>] kobject_unregister+0x2b/0x40
[ 3870.084786]  [<ffffffff8114bcd2>] kset_unregister+0x12/0x20
[ 3870.090375]  [<ffffffff8114bce9>] subsystem_unregister+0x9/0x10
[ 3870.096312]  [<ffffffff88122550>] :fuse:fuse_sysfs_cleanup+0x10/0x20
[ 3870.102687]  [<ffffffff88123b4c>] :fuse:fuse_exit+0x1c/0x2c
[ 3870.108279]  [<ffffffff81063bf1>] sys_delete_module+0x1b1/0x290
[ 3870.114216]  [<ffffffff8100c40e>] system_call+0x7e/0x83
[ 3870.119459]  [<00007f5c807c6ef7>]
[ 3870.122796] 

