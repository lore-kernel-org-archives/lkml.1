Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYKCST2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYKCST2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYKCSTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:19:21 -0500
Received: from www17.your-server.de ([213.133.104.17]:46295 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYKCSTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:19:20 -0500
Subject: BUG: sleeping function called from invalid context at
	kernel/sched.c:5558
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 19:19:21 +0100
Message-Id: <1225736361.5126.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

False positive, while suspend/resume-to/from-disk?

[19332.352863] BUG: sleeping function called from invalid context at kernel/sched.c:5558
[19332.352866] in_atomic(): 0, irqs_disabled(): 1, pid: 3287, name: pm-hibernate
[19332.352869] Pid: 3287, comm: pm-hibernate Tainted: G        W  2.6.28-rc2 #97
[19332.352871] Call Trace:
[19332.352878]  [<c0436408>] __might_sleep+0xdc/0xe3
[19332.352882]  [<c043bbde>] __cond_resched+0x12/0x36
[19332.352886]  [<c09d29a8>] _cond_resched+0x27/0x32
[19332.352889]  [<c0697d9c>] acpi_ps_complete_op+0x1e0/0x1ef
[19332.352892]  [<c069884e>] ? acpi_ps_alloc_op+0x82/0x84
[19332.352896]  [<c0689814>] ? acpi_ds_exec_end_op+0x30c/0x370
[19332.352899]  [<c069839f>] acpi_ps_parse_loop+0x5f4/0x721
[19332.352902]  [<c069779c>] acpi_ps_parse_aml+0x6d/0x267
[19332.352905]  [<c06989e1>] acpi_ps_execute_method+0x11c/0x1d7
[19332.352909]  [<c069563c>] acpi_ns_evaluate+0x11c/0x1e4
[19332.352913]  [<c069d223>] ? acpi_ut_create_internal_object_dbg+0x15/0x6d
[19332.352916]  [<c0699c0b>] acpi_rs_set_srs_method_data+0xb7/0xd2
[19332.352919]  [<c0699768>] acpi_set_current_resources+0x2e/0x39
[19332.352923]  [<c06a5cfb>] acpi_pci_link_set+0xff/0x1a4
[19332.352926]  [<c06a5de9>] irqrouter_resume+0x49/0x60
[19332.352930]  [<c06fb1ac>] __sysdev_resume+0x14/0x38
[19332.352933]  [<c06fb1f1>] sysdev_resume+0x21/0x54
[19332.352936]  [<c06ff712>] device_power_up+0xb/0x15
[19332.352940]  [<c0463819>] hibernation_snapshot+0x149/0x1ba
[19332.352943]  [<c0463936>] hibernate+0xac/0x17d
[19332.352945]  [<c04628c9>] ? state_store+0x0/0xa8
[19332.352948]  [<c046291f>] state_store+0x56/0xa8
[19332.352951]  [<c04628c9>] ? state_store+0x0/0xa8
[19332.352954]  [<c0645565>] kobj_attr_store+0x1a/0x22
[19332.352958]  [<c04e08cb>] sysfs_write_file+0xb4/0xdf
[19332.352961]  [<c04e0817>] ? sysfs_write_file+0x0/0xdf
[19332.352964]  [<c04a557d>] vfs_write+0x84/0xdf
[19332.352967]  [<c04a5671>] sys_write+0x3b/0x60
[19332.352970]  [<c0417b15>] sysenter_do_call+0x12/0x21
[19332.352986] Enabling non-boot CPUs ...


