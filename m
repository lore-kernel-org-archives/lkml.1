Return-Path: <linux-kernel-owner+w=401wt.eu-S1030362AbXBTSyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030362AbXBTSyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 13:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030365AbXBTSyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 13:54:15 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:63299 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030362AbXBTSyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 13:54:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZSMqCfus7/qeHbIqDfSx75zVw3oxMnuze7JyCcii0a+nMBcYOcul+mUzyp9fvv3W/vFpeW1YimZSW6ywVSa7RDp3iZzev4X+jLWO9zJqDoxx1VrBlogryZ+sTlgoHFxaPO1e1aXAjV/CPsJhsq/iWOLJgYdX+VLa6dUKVWdwn1c=
Message-ID: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
Date: Tue, 20 Feb 2007 19:54:12 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a problem with timers.

NOHZ: local_softirq_pending 20
NOHZ: local_softirq_pending 20
BUG: soft lockup detected on CPU#0!
 [<c01050f9>] show_trace_log_lvl+0x1a/0x2f
 [<c01057e0>] show_trace+0x12/0x14
 [<c0105892>] dump_stack+0x16/0x18
 [<c0151214>] softlockup_tick+0xa7/0xb9
 [<c012a18f>] run_local_timers+0x12/0x14
 [<c012a54b>] update_process_times+0x3e/0x63
 [<c0139e34>] tick_sched_timer+0x66/0xaa
 [<c01366d2>] hrtimer_interrupt+0x113/0x19d
 [<c0114c45>] smp_apic_timer_interrupt+0x77/0x89
 [<c0104beb>] apic_timer_interrupt+0x33/0x38
 [<c026b945>] scsi_dispatch_cmd+0x1a8/0x1e5
 [<c026ff86>] scsi_request_fn+0x224/0x2ec
 [<c01e1779>] __generic_unplug_device+0x20/0x23
 [<c01e1b49>] generic_unplug_device+0x18/0x26
 [<c01e2c48>] blk_backing_dev_unplug+0x76/0x7e
 [<c018e289>] sync_buffer+0x2e/0x37
 [<c0311041>] __wait_on_bit+0x36/0x5d
 [<c03110c3>] out_of_line_wait_on_bit+0x5b/0x63
 [<c018e1f9>] __wait_on_buffer+0x27/0x2b
 [<c018ec74>] sync_dirty_buffer+0xa0/0xd6
 [<c01bc5c1>] journal_commit_transaction+0xca4/0x11d3
  [<c01bff86>] kjournald+0xab/0x1e8
  [<c0133639>] kthread+0xb5/0xe0
 [<c0104d8f>] kernel_thread_helper+0x7/0x10
 =======================
Clocksource tsc unstable (delta = 18743203260 ns)
Time: acpi_pm clocksource has been installed.

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20-git15/git-dmesg
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20-git15/git-config

Might it be 6ba9b346e1e0eca65ec589d32de3a9fe32dc5de6 commit?

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
