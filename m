Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab0CMXxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 18:53:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab0CMXxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 18:53:32 -0500
Date: Sat, 13 Mar 2010 15:53:28 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linuxppc-dev@ozlabs.org
Subject: 2.6.34-rc1: Badness at fs/proc/generic.c:316
Message-ID: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+MnC+V0nQj4AlFpHS5n+FAJa1Hef4sDhTkN9z
 1Wgu3Oj6+/AF+T5+gO+UygHTLGszWmfuHnz8y4Ap2im+Ox//gt
 eLAg7GzDTn/RsicMlkBYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after upgrading from 2.6.33 to today's latest mainline (daf9fe2...), I'm 
getting this during bootup on a powerpc machine (Powerbook G4):

[    0.002187] ------------[ cut here ]------------
[    0.002197] Badness at fs/proc/generic.c:316
[    0.002207] NIP: c00e1130 LR: c00e1130 CTR: c01fb970
[    0.002219] REGS: c044bdc0 TRAP: 0700   Not tainted  (2.6.34-rc1)
[    0.002230] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 22000022  XER: 20000000
[    0.002255] TASK = c042c410[0] 'swapper' THREAD: c044a000
[    0.002266] GPR00: c00e1130 c044be70 c042c410 00000024 000012ff ffffffff ffffffff 00000000 
[    0.002291] GPR08: ef808320 c04492d0 00000000 000012ff 42000028 00000000 00ca59bc 00ca56a8 
[    0.002315] GPR16: 00cc8420 00ca5998 00ca55b8 00ca569c 00240e18 00240e20 00ca5644 00240e24 
[    0.002340] GPR24: 00000000 0048b000 c044be98 c044bec8 c0d90a42 c0d90a42 00000006 00000000 
[    0.002376] NIP [c00e1130] __xlate_proc_name+0xd0/0xf8
[    0.002389] LR [c00e1130] __xlate_proc_name+0xd0/0xf8
[    0.002399] Call Trace:
[    0.002408] [c044be70] [c00e1130] __xlate_proc_name+0xd0/0xf8 (unreliable)
[    0.002426] [c044be90] [c00e16a4] __proc_create+0x60/0xf0
[    0.002441] [c044bec0] [c00e1e0c] proc_create_data+0x54/0xc4
[    0.002465] [c044bee0] [c00e5f8c] __proc_device_tree_add_prop+0x64/0xd4
[    0.002486] [c044bf00] [c00e6130] proc_device_tree_add_node+0x134/0x164
[    0.002506] [c044bf20] [c00e60b0] proc_device_tree_add_node+0xb4/0x164
[    0.002527] [c044bf40] [c00e60b0] proc_device_tree_add_node+0xb4/0x164
[    0.002548] [c044bf60] [c00e60b0] proc_device_tree_add_node+0xb4/0x164
[    0.002568] [c044bf80] [c00e60b0] proc_device_tree_add_node+0xb4/0x164
[    0.002592] [c044bfa0] [c0412c8c] proc_device_tree_init+0x4c/0x78
[    0.002612] [c044bfb0] [c04126f4] proc_root_init+0xcc/0xf0
[    0.002632] [c044bfc0] [c03ff798] start_kernel+0x230/0x284
[    0.002649] [c044bff0] [00003444] 0x3444
[    0.002662] Instruction dump:
[    0.002675] 93ba0000 38600000 93fb0000 80010024 bb410008 38210020 7c0803a6 4e800020 
[    0.002707] 3c60c03b 7f84e378 38631d54 48267a3d <0fe00000> 80010024 3860fffe bb410008 


Is this something to worry about? The machine seems to run fine so far...

Full dmesg and .config: 
http://nerdbynature.de/bits/2.6.34-rc1/xlate_proc_name/

Thanks,
Christian.
-- 
BOFH excuse #37:

heavy gravity fluctuation, move computer to floor rapidly
