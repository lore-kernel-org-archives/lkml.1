Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZHDNap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZHDNap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 09:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZHDNap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 09:30:45 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:54343 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbZHDNao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:30:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
X-IronPort-AV: E=Sophos;i="4.43,321,1246831200";   d="scan'208";a="21453532"
Message-id: <4A7837E6.9020301@nets.rwth-aachen.de>
Date: Tue, 04 Aug 2009 15:30:14 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
To: LKML <linux-kernel@vger.kernel.org>
Subject: stuck process in D state
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a process in D state on one of our servers. How can I get it killed?
Seems to be hanging on nfs (but nfs server is up and running).
Other processes have no problems accessing files on same nfs mount.

t sysrq shows:

ld            D C0119B81     0 24688    408                     (NOTLB)
       e6ca7dc4 00200282 e6ca7da8 c0119b81 00000000 c0544b80 00000027 c0544b80
       c0544b80 e6ca7d98 99ebeb27 0010351e 00abc680 0000000a d4247000 99ed612c
       0010351e 00012df2 d4247110 c1001200 00009deb 00000000 99ec333a 0010351e
Call Trace:
 [<c0119b81>] try_to_wake_up+0x41/0x360
 [<c0134924>] autoremove_wake_function+0x14/0x40
 [<c03f4206>] io_schedule+0x26/0x30
 [<c0145835>] sync_page+0x35/0x40
 [<c03f45d2>] __wait_on_bit+0x42/0x70
 [<c0145800>] sync_page+0x0/0x40
 [<c0145a2e>] wait_on_page_bit+0x5e/0x70
 [<c0134950>] wake_bit_function+0x0/0x60
 [<c0146665>] wait_on_page_writeback_range+0xa5/0x110
 [<c0146ab7>] filemap_write_and_wait+0x37/0x50
 [<c01cafbd>] nfs_sync_mapping+0x4d/0x80
 [<c01cb816>] nfs_revalidate_mapping+0x116/0x150
 [<c01c9bd4>] nfs_file_read+0x64/0xe0
 [<c016a194>] do_sync_read+0xc4/0x100
 [<c0134910>] autoremove_wake_function+0x0/0x40
 [<c01c99b0>] nfs_file_llseek+0x0/0x70
 [<c03f31ef>] __down_failed+0x7/0xc
 [<c03f5c72>] .text.lock.kernel_lock+0x18/0x34
 [<c016a0d0>] do_sync_read+0x0/0x100
 [<c016ac1f>] vfs_read+0xbf/0x170
 [<c0169f2c>] vfs_llseek+0x3c/0x50
 [<c016b161>] sys_read+0x41/0x70
 [<c010547f>] syscall_call+0x7/0xb


kill -9 24688
did not work :-(

Best regards,
Arnd
