Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYFVQUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYFVQUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 12:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYFVQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 12:20:34 -0400
Received: from bu3sch.de ([62.75.166.246]:49903 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYFVQUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:20:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Oops when using growisofs
Date: Sun, 22 Jun 2008 18:18:24 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806221818.24372.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following oops happend when trying to append data to a DVD
with growisofs -M.

Burning DVD...
Executing 'genisoimage -C 16,737776 -M /dev/fd/3 -R -J foobar | builtin_dd of=/dev/dvd obs=32k seek=46111'
I: -input-charset not specified, using utf-8 (detected in locale settings)
Rock Ridge signatures found
/dev/dvd: "Current Write Speed" is 8.2x1352KBps.
:-( unable to WRITE@LBA=b41f0h: Input/output error
:-( write failed: Input/output error

This is a wireless-testing.git kernel, which corresponds to 2.6.26-rc6

[28375.893176] Unable to handle kernel paging request for data at address 0x00000008
[28375.893181] Faulting instruction address: 0xc00000000012df84
[28375.893186] Oops: Kernel access of bad area, sig: 11 [#1]
[28375.893189] PREEMPT SMP NR_CPUS=4 NUMA PowerMac
[28375.893200] Modules linked in: nls_cp437 isofs udf rfkill_input hci_usb nfsd exportfs auth_rpcgss deadline_iosched nbd ppdev lp parport nfs lockd sunrpc fuse sr_mod sbp2 arc4 ecb b43 evdev af_packet mac80211 cfg80211 rfkill appledisplay usbhid ssb ide_pci_generic ohci1394 ieee1394 uninorth_agp agpgart
[28375.893287] NIP: c00000000012df84 LR: c00000000012df70 CTR: c000000000137b00
[28375.893293] REGS: c000000116aeb300 TRAP: 0300   Not tainted  (2.6.26-rc6-wl)
[28375.893296] MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 28004842  XER: 000fffff
[28375.893316] DAR: 0000000000000008, DSISR: 0000000040000000
[28375.893320] TASK = c00000011636db00[4667] 'kded' THREAD: c000000116ae8000 CPU: 2
[28375.893327] GPR00: c00000000012df70 c000000116aeb580 c00000000090ff20 0000000000000000 
[28375.893340] GPR04: 0000000000010000 0000000000000001 c00000011bfe37a0 0000000000000010 
[28375.893352] GPR08: f00000000694d280 0000000000000000 c0000000008c0be0 0000000000000000 
[28375.893364] GPR12: 0000000028004842 c000000000941700 0000000000000004 c000000116aeb840 
[28375.893377] GPR16: c0000001195d8f78 c0000000008c0cb8 c0000000000bd064 0000000000000003 
[28375.893389] GPR20: 0000000000000000 c0000001195d8d68 0000000000000004 c0000001195d8f80 
[28375.893402] GPR24: c00000000082c700 0000000000010000 f00000000694d280 0000000000000000 
[28375.893415] GPR28: 0000000000000000 f00000000694d280 c00000000088e640 c000000116aeb580 
[28375.893428] NIP [c00000000012df84] .create_empty_buffers+0x44/0x180
[28375.893439] LR [c00000000012df70] .create_empty_buffers+0x30/0x180
[28375.893446] Call Trace:
[28375.893451] [c000000116aeb580] [c00000000012df70] .create_empty_buffers+0x30/0x180 (unreliable)
[28375.893463] [c000000116aeb620] [c0000000001331a4] .block_read_full_page+0x464/0x480
[28375.893473] [c000000116aeb750] [c000000000137b28] .blkdev_readpage+0x28/0x50
[28375.893483] [c000000116aeb7d0] [c0000000000bd2c8] .__do_page_cache_readahead+0x368/0x390
[28375.893496] [c000000116aeb8e0] [c0000000000bd698] .ondemand_readahead+0x158/0x270
[28375.893505] [c000000116aeb9a0] [c0000000000bd8fc] .page_cache_sync_readahead+0x3c/0x50
[28375.893513] [c000000116aeba20] [c0000000000b2994] .generic_file_aio_read+0x4f4/0x630
[28375.893523] [c000000116aebb50] [c0000000000f6fa4] .do_sync_read+0xe4/0x180
[28375.893534] [c000000116aebcf0] [c0000000000f79c4] .vfs_read+0xf4/0x1c0
[28375.893542] [c000000116aebd90] [c0000000000f8234] .sys_read+0x54/0xa0
[28375.893550] [c000000116aebe30] [c0000000000076d4] syscall_exit+0x0/0x40
[28375.893560] Instruction dump:
[28375.893566] f8010010 f821ff61 7cbb2b78 38a00001 7c7d1b78 7c3f0b78 4bfffe65 7c7c1b78 
[28375.893586] 7c691b78 4800000c 60000000 7d695b78 <e9690008> e8090000 2fab0000 7c00db78 
[28375.893607] ---[ end trace d2a7775e4472c36e ]---

-- 
Greetings Michael.
