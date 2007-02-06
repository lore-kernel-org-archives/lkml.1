Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbXBFCzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbXBFCzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 21:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965165AbXBFCzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 21:55:38 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:57662 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930AbXBFCzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 21:55:37 -0500
Date: Mon, 05 Feb 2007 20:55:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: 2.6.20-rc6-mm3 and NTFS: BUG: at arch/i386/mm/highmem.c:52
 kmap_atomic()
To: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45C7EE27.1020802@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing these BUGs on 2.6.20-rc6-mm3 when mounting an NTFS partition. I 
saw some reports of something like this on -mm1, was this supposed to be 
patched already?

BUG: at arch/i386/mm/highmem.c:52 kmap_atomic()
  [<c041f810>] kmap_atomic+0xb4/0x1cd
  [<e0de8276>] ntfs_end_buffer_async_read+0x276/0x2db [ntfs]
  [<c048f92b>] end_bio_bh_io_sync+0x0/0x39
  [<c048f959>] end_bio_bh_io_sync+0x2e/0x39
  [<c049138f>] bio_endio+0x5b/0x63
  [<c05ffe97>] _spin_lock_irqsave+0x9/0xd
  [<c042f3f6>] lock_timer_base+0x15/0x2f
  [<c04d9f03>] __end_that_request_first+0x176/0x421
  [<e08c45a6>] scsi_delete_timer+0xf/0x50 [scsi_mod]
  [<e08c6817>] scsi_request_fn+0x2d4/0x324 [scsi_mod]
  [<e092ee7b>] ata_scsi_qc_complete+0x344/0x354 [libata]
  [<c04dba71>] __blk_run_queue+0x17/0x35
  [<e08c5601>] scsi_end_request+0x1a/0xa8 [scsi_mod]
  [<e08c5826>] scsi_io_completion+0x15a/0x32b [scsi_mod]
  [<c0409f81>] pit_next_event+0x2b/0x2f
  [<e08505c9>] sd_rw_intr+0x21b/0x245 [sd_mod]
  [<e08c13ff>] scsi_finish_command+0x84/0x8b [scsi_mod]
  [<c04dc19b>] blk_done_softirq+0x49/0x54
  [<c042b645>] __do_softirq+0x5d/0xba
  [<c042b6d4>] do_softirq+0x32/0x36
  [<c042b926>] irq_exit+0x38/0x6b
  [<c0406eb7>] do_IRQ+0x87/0x9c
  [<c0405837>] common_interrupt+0x23/0x28
  [<c043007b>] __dequeue_signal+0x97/0x14e
  [<c052709f>] acpi_processor_idle+0x209/0x3ca
  [<c0526e96>] acpi_processor_idle+0x0/0x3ca
  [<c0403410>] cpu_idle+0xaa/0xd0
  [<c071ca1f>] start_kernel+0x435/0x43d
  [<c071c1ae>] unknown_bootoption+0x0/0x202
  =======================

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

