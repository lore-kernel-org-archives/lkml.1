Return-Path: <linux-kernel-owner+w=401wt.eu-S966011AbXCSPWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966011AbXCSPWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966016AbXCSPWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:22:35 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48428 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966011AbXCSPWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:22:33 -0400
Date: Mon, 19 Mar 2007 18:30:13 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: linux-kernel@vger.kernel.org
Cc: davej@codemonkey.org.uk, gregkh@suse.de, akpm@osdl.org
Subject: Oops after cd /sys/.../cpufreq/; rmmod; cat stats/time_in_state
Message-ID: <20070319153013.GA6814@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steps to reproduce:

	# modprobe p4-clockmod
	$ cd /sys/devices/system/cpu/cpu0/cpufreq/
	# rmmod p4-clockmod
	$ cat stats/time_in_state
	Segmentation fault

p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
BUG: unable to handle kernel paging request at virtual address 6b6b6b6f
 printing eip:
c01906b4
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: speedstep_lib ohci_hcd af_packet e1000 ehci_hcd uhci_hcd usbcore xfs
CPU:    0
EIP:    0060:[<c01906b4>]    Not tainted VLI
EFLAGS: 00010202   (2.6.21-rc4-5851fadce8824d5d4b8fd02c22ae098401f6489e #2)
EIP is at sysfs_open_file+0xd3/0x259
eax: 6b6b6b6b   ebx: 00000000   ecx: f371b000   edx: 00000000
esi: c03a7330   edi: f35c8408   ebp: f371c9b0   esp: f371bee0
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process cat (pid: 6876, ti=f371b000 task=c192f550 task.ti=f371b000)
Stack: f3713b2c c0393400 00000000 f371c9b0 00000000 f3713b2c c01905e1 c0158575
       c18d3208 f71c4cd8 00000000 f371c9b0 00008000 f371bf38 ffffff9c c0158702
       f371c9b0 00000000 00000000 c0158744 00000000 f371bf38 f71c4cd8 c18d3208
Call Trace:
 [<c01905e1>] sysfs_open_file+0x0/0x259
 [<c0158575>] __dentry_open+0xec/0x1ec
 [<c0158702>] nameidata_to_filp+0x31/0x3a
 [<c0158744>] do_filp_open+0x39/0x40
 [<c0158478>] get_unused_fd+0xa1/0xb2
 [<c02d4cde>] _spin_unlock+0x25/0x3b
 [<c0158478>] get_unused_fd+0xa1/0xb2
 [<c0158785>] do_sys_open+0x3a/0x6d
 [<c01587f3>] sys_open+0x1c/0x20
 [<c0103e72>] sysenter_past_esp+0x5f/0x99
 =======================
Code: 00 f0 ff ff 8b 40 08 a8 08 0f 85 95 01 00 00 bb ed ff ff ff 8b 44 24 08 85 c0 0f 84 f8 00 00 00 8b 47 28 85 c0 0f 84 34 01 00 00 <8b> 40 04 85 c0 0f 84 29 01 00 00 8b 58 04 85 db 0f 84 0f 01 00
EIP: [<c01906b4>] sysfs_open_file+0xd3/0x259 SS:ESP 0068:f371bee0
Slab corruption: start=f35c83bc, len=256
Redzone: 0x5a2cf071/0x5a2cf071.
Last user: [<c0181d54>](load_elf_binary+0x161b/0x1ac7)
060: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
Prev obj: start=f35c82b0, len=256
Redzone: 0x170fc2a5/0x170fc2a5.
Last user: [<c0180758>](load_elf_binary+0x1f/0x1ac7)
000: 7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00
010: 02 00 03 00 01 00 00 00 b0 85 04 08 34 00 00 00
Next obj: start=f35c84c8, len=256
Redzone: 0x170fc2a5/0x170fc2a5.
Last user: [<c01807ea>](load_elf_binary+0xb1/0x1ac7)
000: 06 00 00 00 34 00 00 00 34 80 04 08 34 80 04 08
010: 00 01 00 00 00 01 00 00 05 00 00 00 04 00 00 00

