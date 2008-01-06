Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYAFU7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYAFU7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbYAFU7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:59:24 -0500
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:5395 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823AbYAFU7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:59:23 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.24-rc5: 'sysctl table check failed' when turning on printer
Date: Sun, 6 Jan 2008 21:59:18 +0100
User-Agent: KMail/1.9.7
References: <20080106150722.GA15887@elte.hu> <m1tzlqlmkd.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1tzlqlmkd.fsf@ebiederm.dsl.xmission.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801062159.20014.elendil@planet.nl>
X-OriginalArrivalTime: 06 Jan 2008 20:59:20.0700 (UTC) FILETIME=[023753C0:01C850A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 January 2008, Eric W. Biederman wrote:
> Short of two programs coming in and simultaneously trying to claim
> the parallel port and there being not exclusion in ppdev.c I don't
> have a clue what could cause the reported error.

That could well be the root cause as the full log shows:

Jan  6 01:21:02 faramir kernel: ppdev0: registered pardevice
Jan  6 01:21:03 faramir kernel: sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice  Sysctl already exists
Jan  6 01:21:03 faramir kernel: Pid: 11078, comm: hpijs Not tainted 2.6.24-rc6 #1
Jan  6 01:21:03 faramir kernel:
Jan  6 01:21:03 faramir kernel: Call Trace:
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c104>] set_fail+0x3f/0x47
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c5ba>] sysctl_check_table+0x4ae/0x4fb
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c0b6>] sysctl_check_lookup+0xc1/0xd0
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c5d0>] sysctl_check_table+0x4c4/0x4fb
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c0b6>] sysctl_check_lookup+0xc1/0xd0
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c5d0>] sysctl_check_table+0x4c4/0x4fb
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c0b6>] sysctl_check_lookup+0xc1/0xd0
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c5d0>] sysctl_check_table+0x4c4/0x4fb
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c0b6>] sysctl_check_lookup+0xc1/0xd0
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c5d0>] sysctl_check_table+0x4c4/0x4fb
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c0b6>] sysctl_check_lookup+0xc1/0xd0
Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c5d0>] sysctl_check_table+0x4c4/0x4fb
Jan  6 01:21:03 faramir kernel:  [<ffffffff8023ca8d>] register_sysctl_table+0x52/0x9d
Jan  6 01:21:03 faramir kernel:  [<ffffffff881ea7cb>] :parport:parport_device_proc_register+0xc3/0xe3
Jan  6 01:21:03 faramir kernel:  [<ffffffff881e8da7>] :parport:parport_register_device+0x206/0x267
Jan  6 01:21:03 faramir kernel:  [<ffffffff884151ae>] :ppdev:pp_irq+0x0/0x40
Jan  6 01:21:03 faramir kernel:  [<ffffffff8841574f>] :ppdev:pp_ioctl+0x13f/0x77c
Jan  6 01:21:03 faramir kernel:  [<ffffffff80296a55>] do_ioctl+0x55/0x6b
Jan  6 01:21:03 faramir kernel:  [<ffffffff80296cae>] vfs_ioctl+0x243/0x25c
Jan  6 01:21:03 faramir kernel:  [<ffffffff80296d18>] sys_ioctl+0x51/0x71
Jan  6 01:21:03 faramir kernel:  [<ffffffff8020beee>] system_call+0x7e/0x83
Jan  6 01:21:03 faramir kernel:
Jan  6 01:21:03 faramir kernel: ppdev0: registered pardevice
Jan  6 01:22:10 faramir kernel: ppdev0: released pardevice because user-space forgot
Jan  6 01:22:10 faramir kernel: ppdev0: unregistered pardevice
Jan  6 01:22:11 faramir kernel: ppdev0: unregistered pardevice
Jan  6 03:24:57 faramir kernel: fuse exit

Sorry for not providing that info earlier, but the first time I had this
issue I had two print jobs after eachother and because of that I overlooked
the double registering.

I am printing through CUPS on a fairly standard Debian unstable system
running the KDE desktop.
