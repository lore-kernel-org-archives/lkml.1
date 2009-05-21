Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZEUU0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZEUU0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZEUU0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:26:38 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:64034 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZEUU0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Ii621P+9obpPyCdnI/Gt1y0DzQHnTfbNnXC95ev0dEBgfRJyx7RopNKkcAcv8k/Epl
         PHgbFVnQDinJr8aS1zG1dFil7jimwkaMBsga0RagIztKR3qEhKjP1kscSh5rJ3Tx3oUZ
         b0sIg0uB19O0Hy7/6MntSk/JFYZhIfqR+1lBk=
Date: Thu, 21 May 2009 17:26:55 -0300
From: Matheus Izvekov <mizvekov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] parport issue on 2.6.29
Message-ID: <20090521202655.GA13944@izvekov>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning happens whenever a specific parallel port control app is run 
without a device attached to it. After the first timeout, the app hangs,
and needs SIGKILL to exit.

WARNING: at kernel/sysctl.c:2021 unregister_sysctl_table+0xa3/0x110()
Hardware name:         
Modules linked in:
Pid: 12161, comm: x-killer.exe Not tainted 2.6.29.4 #14
Call Trace:
[<ffffffff8024c910>] warn_slowpath+0xd0/0x130
[<ffffffff80269859>] ? sched_clock_cpu+0xb9/0x190
[<ffffffff802484b4>] ? try_to_wake_up+0x174/0x330
[<ffffffff80268554>] ? up+0x34/0x50
[<ffffffff8024d1cd>] ? release_console_sem+0x1bd/0x210
[<ffffffff80aaa4d4>] ? printk+0x67/0x69
[<ffffffff80254ec3>] unregister_sysctl_table+0xa3/0x110
[<ffffffff806b3128>] parport_device_proc_unregister+0x28/0x40
[<ffffffff806b05f5>] parport_unregister_device+0x15/0x180
[<ffffffff806a0acc>] pp_release+0xbc/0x1f0
[<ffffffff802d3883>] __fput+0xc3/0x1e0
[<ffffffff802d39bd>] fput+0x1d/0x30
[<ffffffff802d0220>] filp_close+0x50/0x80
[<ffffffff8024ec74>] put_files_struct+0x84/0xe0
[<ffffffff8024ed1e>] exit_files+0x4e/0x60
[<ffffffff80250696>] do_exit+0x196/0x930
[<ffffffff80250e6e>] do_group_exit+0x3e/0xb0
[<ffffffff8025bda4>] get_signal_to_deliver+0x2a4/0x420
[<ffffffff8020b7aa>] do_notify_resume+0xba/0x900
[<ffffffff8023c16e>] ? __wake_up+0x4e/0x70
[<ffffffff8026c4a9>] ? getnstimeofday+0x59/0xe0
[<ffffffff80267a09>] ? ktime_get_ts+0x59/0x60
[<ffffffff80274314>] ? compat_sys_futex+0xb4/0x140
[<ffffffff8020c8b5>] int_signal+0x12/0x17
--[ end trace ff1bd583c825c0c5 ]---
pdev0: unregistered pardevice
