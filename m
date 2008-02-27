Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYB0Rio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYB0Rio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYB0Rig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:38:36 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:6773 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYB0Rig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:38:36 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Roland Dreier <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
Date: Wed, 27 Feb 2008 17:37:59 +0000
Subject: RE: hpwdt oops in clflush_cache_range
Thread-Topic: hpwdt oops in clflush_cache_range
Thread-Index: Ach5Y2VB8SiGpL5mRLijDSeiS2kD9wABAO2g
Message-ID: <E14D1C2A44812C4F9C3ED321127EDF6505829D5348@G3W0854.americas.hpqcorp.net>
References: <adad4qiwcmz.fsf@cisco.com>
In-Reply-To: <adad4qiwcmz.fsf@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What generation is the DL380 server? G5 I hope.


Tom

-----Original Message-----
From: Roland Dreier [mailto:rdreier@cisco.com]
Sent: Wednesday, February 27, 2008 11:08 AM
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar; Mingarelli, Thomas
Subject: hpwdt oops in clflush_cache_range

With an up-to-date git tree (head 7704a8b6) I'm seeing the oops below
when the hpwdt driver gets loaded during boot on an HP DL380 system.
I don't think I've seen any previous reports of this, and I guess it
doesn't really count as a regression since the hpwdt driver was only
added after 2.6.25-rc2.

I haven't tried to debug this at all yet but any guidance about what
information is useful for what looks to be an issue with c_p_a would
be appreciated.

 - R.


 BUG: unable to handle kernel paging request at ffffc20001a08000
 IP: [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
 PGD 1bf80e067 PUD 1bf80f067 PMD 1bb1ab067 PTE 80000047000ee17b
 Oops: 0009 [1] SMP
 CPU 2
 Modules linked in: ide_pci_generic(+) ipmi_si ib_mthca container piix thermal ib_mad serio_raw ipmi_msghandler bnx2 evdev hpwdt(+) ib_core zlib_inflate ehci_hcd uhci_hcd button processor pcspkr psmouse ide_core
 Pid: 1291, comm: modprobe Not tainted 2.6.25-rc3 #51
 RIP: 0010:[<ffffffff8021dacc>]  [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
 RSP: 0018:ffff8101bd421bc0  EFLAGS: 00010293
 RAX: ffff8101bb1ab040 RBX: 0000000000000000 RCX: 00000001bb1ab001
 RDX: ffffc20001a08fff RSI: 0000000000001000 RDI: ffffc20001a08000
 RBP: ffffc20001a08000 R08: ffff810000000000 R09: 00003ffffffff000
 R10: ffffc20001a08000 R11: 000000008807c350 R12: ffff8101bd421bf4
 R13: 0000000000000000 R14: 0000000000000001 R15: 800000000000017b
 FS:  00007f62818166e0(0000) GS:ffff8101bf802c00(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: ffffc20001a08000 CR3: 00000001bbdc6000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process modprobe (pid: 1291, threadinfo ffff8101bd420000, task ffff8101bbd34000)
 Stack:  ffffffff8021e60b ffffc20001a09000 0000000000000018 0000000000000000
  0000000100000001 00000000047000ee 0000000100001000 0000000000001000
  ffffc20001a08000 00240047000ee000 ffff8101bbcd5f00 00240047000ee000
 Call Trace:
  [<ffffffff8021e60b>] ? change_page_attr_set_clr+0x140/0x18b
  [<ffffffff8021d94c>] ? __ioremap+0x197/0x1cd
  [<ffffffff8807a566>] ? :hpwdt:hpwdt_init_one+0x1c3/0x386
  [<ffffffff803351fe>] ? pci_device_probe+0xb3/0xfb
  [<ffffffff80393ffe>] ? driver_probe_device+0xb5/0x132
  [<ffffffff8039411d>] ? __driver_attach+0x0/0x93
  [<ffffffff80394177>] ? __driver_attach+0x5a/0x93
  [<ffffffff803933fa>] ? bus_for_each_dev+0x47/0x72
  [<ffffffff80393c1e>] ? bus_add_driver+0xb1/0x1fb
  [<ffffffff80394391>] ? driver_register+0x59/0xce
  [<ffffffff80335487>] ? __pci_register_driver+0x5a/0x8b
  [<ffffffff802526a1>] ? sys_init_module+0x18ff/0x1a08
  [<ffffffff8023ea31>] ? param_get_int+0x0/0x14
  [<ffffffff8024a6be>] ? trace_hardirqs_on+0xef/0x113
  [<ffffffff8041e1fa>] ? trace_hardirqs_on_thunk+0x35/0x3a
  [<ffffffff8020be5b>] ? system_call_after_swapgs+0x7b/0x80


 Code: 00 e8 de 09 02 00 31 d2 48 85 c0 74 0d 48 8b 40 08 b2 01 48 89 83 80 00 00 00 5b 89 d0 c3 90 89 f6 48 8d 54 37 ff 0f ae f0 eb 0d <0f> ae 3f 0f b7 05 4e ce 36 00 48 01 c7 48 39 d7 72 ee 0f ae 3a
 RIP  [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
  RSP <ffff8101bd421bc0>
 CR2: ffffc20001a08000
 ---[ end trace 5e3e8191157a34b6 ]---
