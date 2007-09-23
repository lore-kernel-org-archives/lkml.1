Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbXIWEXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbXIWEXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 00:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbXIWEXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 00:23:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbXIWEXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 00:23:12 -0400
Date: Sat, 22 Sep 2007 21:22:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.23-rc6-mm1] NMI Watchdog detected LOCKUP on CPU 0
Message-Id: <20070922212236.db145c57.akpm@linux-foundation.org>
In-Reply-To: <390511737.19669@ustc.edu.cn>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<390511737.19669@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Sep 2007 09:42:14 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Tue, Sep 18, 2007 at 01:18:41AM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> > 
> > 2.6.23-rc6-mm1 is a 29MB diff against 2.6.23-rc6.
> 
> 
> This bug appears in 2.6.23-rc3-mm1, too.

hm, there isn't much info here.

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

Looks like it oopsed in the middle of handling an NMI watchdog expiry,
perhaps.

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

That's interensting.  serial_in().  We have had NMI watchdog expiries when
the kernel is printing a large amount of stuff out a slow serial port with
interrutps disabled.  But I thought we'd pretty much plugged those problems
by sprinkling touch_nmi_watchdog() in various places.

Do you think this is what was happening on your system?

