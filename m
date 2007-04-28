Return-Path: <linux-kernel-owner+w=401wt.eu-S1030871AbXD1Bwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030871AbXD1Bwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030895AbXD1Bwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:52:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:51436 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030871AbXD1Bws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:52:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=R9dU+3/JCktv6TAPgmeTt3DI+CYvDQuqSe8swGMHV4UOxtys1rodYzgPJh4MRTY374vfIJCdCwpxMD7BhGMO3ivIurbWZmwRbRLGxydC9dFP9+GqQVcwKhRU/jIiUJbqXC1cRsFhcGvM5qLXm+HgTzdw/FvAYMEgmcErqtdq40I=
Message-ID: <b6a2187b0704271852l1f05d230ga57a5c5d87fc3afd@mail.gmail.com>
Date: Sat, 28 Apr 2007 09:52:46 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.21 - BUG: at arch/i386/kernel/smp.c:177 send_IPI_mask_bitmask()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got this error just before suspend to disk. Suspend/resume without
problem, but only saw this after upgrading to 2.6.21 (no problem with
2.6.21-rc7, I think).

CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS unset
CONFIG_HPET_TIMER=y


ACPI: PCI interrupt for device 0000:00:1b.0 disabled
Disabling non-boot CPUs ...
swsusp: critical section:
swsusp: Need to copy 46874 pages
BUG: at arch/i386/kernel/smp.c:177 send_IPI_mask_bitmask()
 [<c0113b7e>] send_IPI_mask_bitmask+0x52/0xa4
 [<c0139311>] tick_do_broadcast_on_off+0x0/0xd3
 [<c01141fe>] __smp_call_function_single+0x44/0x64
 [<c0139311>] tick_do_broadcast_on_off+0x0/0xd3
 [<c01142e0>] smp_call_function_single+0xc2/0xeb
 [<c013942c>] tick_broadcast_on_off+0x48/0x63
 [<c013913c>] tick_notify+0x20/0x54
 [<c012e71d>] notifier_call_chain+0x1b/0x2d
 [<c0138cf5>] clockevents_notify+0x19/0x54
 [<c025f489>] acpi_processor_power_verify+0x7d/0x86
 [<c025f4c7>] acpi_processor_get_power_info+0x35/0x6c
 [<c025f535>] acpi_processor_cst_has_changed+0x37/0x55
 [<c025e334>] acpi_processor_notify+0x4c/0x5f
 [<c0244a33>] acpi_ev_notify_dispatch+0x52/0x5b
 [<c02449cf>] acpi_ev_queue_notify_request+0x9e/0xb0
 [<c024acc8>] acpi_ex_opcode_2A_0T_0R+0x68/0x96
 [<c02417bb>] acpi_ds_exec_end_op+0xc1/0x386
 [<c023fbdf>] acpi_os_release_object+0x5/0x8
 [<c0250c2d>] acpi_ps_complete_op+0x1cc/0x1db
 [<c0250fa6>] acpi_ps_parse_loop+0x271/0x2a7
 [<c023fbdf>] acpi_os_release_object+0x5/0x8
 [<c02504bc>] acpi_ps_parse_aml+0x69/0x219
 [<c0243888>] acpi_ds_init_aml_walk+0xb3/0x106
 [<c025152b>] acpi_ps_execute_method+0xaf/0xe5
 [<c024e6ef>] acpi_ns_evaluate+0x9b/0xf4
 [<c024dfe4>] acpi_evaluate_object+0x14c/0x1f3
 [<c024d55f>] acpi_leave_sleep_state+0x190/0x26d
 [<c0256a6b>] acpi_pm_finish+0x11/0x40
 [<c0140e99>] pm_suspend_disk+0x170/0x185
 [<c01401d8>] enter_state+0x44/0x76
 [<c0140321>] state_store+0x87/0x9e
 [<c014029a>] state_store+0x0/0x9e
 [<c0193a92>] subsys_attr_store+0x1c/0x24
 [<c0193c86>] flush_write_buffer+0x23/0x28
 [<c0193cd0>] sysfs_write_file+0x45/0x67
 [<c01624c2>] vfs_write+0x8b/0x106
 [<c01625e5>] sys_write+0x41/0x67
 [<c0103ea0>] syscall_call+0x7/0xb
 [<c0360000>] irttp_open_tsap+0x149/0x1d1
 =======================


Thanks,
Jeff.
