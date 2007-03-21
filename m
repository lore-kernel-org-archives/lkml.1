Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbXCUVkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbXCUVkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXCUVkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:40:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:51111 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbXCUVkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:40:17 -0400
Date: Wed, 21 Mar 2007 14:39:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070321143931.c822e855.randy.dunlap@oracle.com>
In-Reply-To: <46019D9C.4020909@lwfinger.net>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174433034.62033.16.camel@localhost>
	<20070320223643.d8cbc3f6.akpm@linux-foundation.org>
	<4601761F.4000302@lwfinger.net>
	<20070321185900.GC3801@tuxdriver.com>
	<20070321202225.GN10459@waste.org>
	<46019D9C.4020909@lwfinger.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 16:03:24 -0500 Larry Finger wrote:

> Matt Mackall wrote:
> > With the latest -mm, I'm now getting this:
> > 
> > Mar 21 15:06:52 cinder kernel: ipw2200: Detected Intel PRO/Wireless
> > 2200BG Network Connection
> > Mar 21 15:06:52 cinder kernel: firmware_loading_store: unexpected
> > value (0)
> > Mar 21 15:06:52 cinder kernel: ipw2200: ipw2200-bss.fw
> > request_firmware failed:
> > Reason -2
> > Mar 21 15:06:52 cinder kernel: ipw2200: Unable to load firmware: -2
> > Mar 21 15:06:52 cinder kernel: ipw2200: failed to register network
> > device
> 
> The problem for me is a general protection fault.
> 
> kernel: general protection fault: 0000 [1] SMP
> kernel: last sysfs file: class/firmware/0000:01:00.0/loading
> kernel: CPU 0
> kernel: Modules linked in: af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device
> cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table
> button battery ac nls_utf8 ntfs loop nfsd exportfs nfs lockd nfs_acl sunrpc sr_mod usb_storage
> libusual snd_hda_intel snd_hda_codec sdhci snd_pcm snd_timer ohci1394 mmc_core snd ieee1394
> forcedeth soundcore snd_page_alloc ohci_hcd ide_cd ehci_hcd cdrom usbcore i2c_nforce2 bcm43xx
> firmware_class ieee80211softmac ieee80211 ieee80211_crypt ext3 mbcache jbd sg edd fan sata_nv libata
> amd74xx thermal processor sd_mod scsi_mod ide_disk ide_core
> kernel: Pid: 4026, comm: cat Not tainted 2.6.21-rc4-mm1-mm1 #6
> kernel: RIP: 0010:[<ffffffff80251f99>]  [<ffffffff80251f99>] module_put+0x1f/0x35
> kernel: RSP: 0018:ffff810006f85ea8  EFLAGS: 00010256
> kernel: RAX: 6b6b6b6b6b6b6dab RBX: ffff810005dbe1f0 RCX: ffffffff803f6160
> kernel: RDX: 0000000000000001 RSI: ffffffff802ec3dc RDI: 6b6b6b6b6b6b6b6b
> kernel: RBP: ffff810006f85ea8 R08: 0000000000000000 R09: ffff810005918888
> kernel: R10: 0000000000000000 R11: ffffffff8811b020 R12: ffff81000850d000
> kernel: R13: ffff810004ec25a8 R14: ffff810006f38c18 R15: ffff8100034017c0
> kernel: FS:  00002b621c2f86f0(0000) GS:ffffffff8051e000(0000) knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> kernel: CR2: 00002b621c01d3c0 CR3: 0000000008154000 CR4: 00000000000006e0
> kernel: Process cat (pid: 4026, threadinfo ffff810006f84000, task ffff810005dd3140)
> kernel: Stack:  ffff810006f85ec8 ffffffff802cf4ba 0000000000000008 ffff810006f38c18
> kernel:  ffff810006f85f08 ffffffff80290a44 ffff81000853bde0 ffff810004ec25a8
> kernel:  ffff8100035d1cb0 0000000000000000 ffff810004ec25a8 00007fff8ed0f6d0
> kernel: Call Trace:
> kernel:  [<ffffffff802cf4ba>] release+0x3a/0x49
> kernel:  [<ffffffff80290a44>] __fput+0xca/0x180
> kernel:  [<ffffffff80290b0e>] fput+0x14/0x16
> kernel:  [<ffffffff8028e1aa>] filp_close+0x66/0x71
> kernel:  [<ffffffff8028f3c2>] sys_close+0x98/0xdd
> kernel:  [<ffffffff80209f6e>] system_call+0x7e/0x83
> kernel:
> kernel:
> kernel: Code: 48 ff 08 83 3f 02 75 0c 48 8b bf 50 22 00 00 e8 08 9d fd ff
> kernel: RIP  [<ffffffff80251f99>] module_put+0x1f/0x35
> kernel:  RSP <ffff810006f85ea8>

which is 'decq' instruction in the local_dec() below:

void module_put(struct module *module)
{
	if (module) {
		unsigned int cpu = get_cpu();
		local_dec(&module->ref[cpu].count);
		/* Maybe they're waiting for us to drop reference? */
		if (unlikely(!module_is_live(module)))
			wake_up_process(module->waiter);
		put_cpu();
	}
}

0000000000000f4e <module_put>:
module_put():
     f4e:	55                   	push   %rbp
     f4f:	48 85 ff             	test   %rdi,%rdi
     f52:	48 89 e5             	mov    %rsp,%rbp
     f55:	74 2a                	je     f81 <module_put+0x33>
     f57:	65 8b 04 25 24 00 00 	mov    %gs:0x24,%eax
     f5e:	00 
     f5f:	89 c0                	mov    %eax,%eax
     f61:	48 c1 e0 07          	shl    $0x7,%rax
     f65:	48 8d 84 38 00 02 00 	lea    0x200(%rax,%rdi,1),%rax
     f6c:	00 
*    f6d:	48 ff 08             	decq   (%rax)
     f70:	83 3f 02             	cmpl   $0x2,(%rdi)
     f73:	75 0c                	jne    f81 <module_put+0x33>
     f75:	48 8b bf 10 06 00 00 	mov    0x610(%rdi),%rdi
     f7c:	e8 00 00 00 00       	callq  f81 <module_put+0x33>
			f7d: R_X86_64_PC32	wake_up_process+0xfffffffffffffffc
     f81:	c9                   	leaveq 
     f82:	c3                   	retq 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
