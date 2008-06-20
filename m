Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYFTTN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYFTTN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYFTTNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:13:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYFTTNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:13:15 -0400
Date: Fri, 20 Jun 2008 15:05:38 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Subject: Re: [WATCHDOG] v2.6.26 hpwdt.c fixes
Message-ID: <20080620190538.GA30161@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wim Van Sebroeck <wim@iguana.be>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Mingarelli <Thomas.Mingarelli@hp.com>
References: <20080618194917.GC2741@infomag.infomag.iguana.be> <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806181256010.2907@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 01:09:43PM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Wed, 18 Jun 2008, Wim Van Sebroeck wrote:
 > > 
 > >     Revert "[WATCHDOG] hpwdt: Fix NMI handling."
 > >     
 > >     To get this driver working we need the CFLAGS_hpwdt.o += -O in the Makefile.
 > >
 > >     The driver needs the asmlinkage tag and the CFLAGS line in the Makefile.
 > >     Without it the driver doesn't work.
 > 
 > The driver is unbelievable shit, and should just be removed, I think.

FWIW, we coincidentally got the below oops reported yesterday.
This was against 2.6.25.4, but this doesn't seem related to the NMI path,
so probably unfixed ?

	Dave


BUG: unable to handle kernel paging request at 5bf393fd
IP: [<f6559dc8>]
*pdpt = 00000000369a4001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
Modules linked in: hpwdt(+) ipmi_si(+) sg iTCO_wdt ipmi_msghandler i5000_edac
button iTCO_vendor_support bnx2 sr_mod edac_core joydev pcspkr cdrom ata_piix
libata cciss sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last
unloaded: scsi_wait_scan]

Pid: 1141, comm: modprobe Not tainted (2.6.25.4-10.fc8PAE #1)
EIP: 0060:[<f6559dc8>] EFLAGS: 00210286 CPU: 1
EIP is at 0xf6559dc8
EAX: 5f32335f EBX: 000f0000 ECX: 00cd0100 EDX: 00000000
ESI: d0ffffff EDI: c39bd09b EBP: f6559da8 ESP: f6559d78
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 1141, ti=f6559000 task=f6570e70 task.ti=f6559000)
Stack: f89694a9 f7920060 f655007b 00200286 f7927000 ffffffed f6559da8 f6559da8
       c00ffee0 00000000 000f1fff c00f0000 f6559dc8 c00f0000 c00ffee0 f6559dc8
       c00f0000 f896a5d0 f896a5a0 f7927000 f6559ddc c050659d f7927054 00000000
Call Trace:
 [<f89694a9>] ? hpwdt_init_one+0x18b/0x3a3 [hpwdt]
 [<c050659d>] ? pci_device_probe+0x39/0x5b
 [<c056a66b>] ? driver_probe_device+0xc0/0x137
 [<c056a806>] ? __driver_attach+0x73/0xa9
 [<c0569baf>] ? bus_for_each_dev+0x37/0x5c
 [<c056a4f0>] ? driver_attach+0x14/0x16
 [<c056a793>] ? __driver_attach+0x0/0xa9
 [<c056a2fd>] ? bus_add_driver+0x90/0x1b7
 [<c056a9fc>] ? driver_register+0x47/0xa2
 [<c0506740>] ? __pci_register_driver+0x35/0x61
 [<f88c8017>] ? hpwdt_init+0x17/0x19 [hpwdt]
 [<c044649d>] ? sys_init_module+0x1610/0x177a
 [<c062e63c>] ? do_page_fault+0x528/0x909
 [<c0437238>] ? param_get_int+0x0/0x15
 [<c0484bd3>] ? do_sync_read+0x0/0xe9
 [<c0485896>] ? sys_read+0x3b/0x60
 [<c0404b7a>] ? syscall_call+0x7/0xb
 =======================
Code: 00 00 00 ff 1f 0f 00 00 00 0f c0 c8 9d 55 f6 00 00 0f c0 e0 fe 0f c0 c8 9d
55 f6 00 00 0f c0 d0 a5 96 f8 a0 a5 96 f8 00 70 92 f7 <dc> 9d 55 f6 9d 65 50 c0
54 70 92 f7 00 <6>udev: renamed network interface eth0 to eth10
00 00 00 d0 a5 96 f8 f4
EIP: [<f6559dc8>] 0xf6559dc8 SS:ESP 0068:f6559d78
---[ end trace f60151d50a977a2e ]---


-- 
http://www.codemonkey.org.uk
