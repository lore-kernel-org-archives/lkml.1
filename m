Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYICTCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYICTCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYICTCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:02:07 -0400
Received: from web52912.mail.re2.yahoo.com ([206.190.49.22]:28165 "HELO
	web52912.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754377AbYICTCF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:02:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=5LfGCb1Xhzb0ZHwubkc+i7jeU5NVQPh+0TLFSzae927zCocrIObAUtAGn33GVKEEWT7EjDHyBc/GoHFVW5OdD9GcTfDDig7xKaPkerzwNqKkHok2pZXz9zVePaTIrGJrUHU/HOtSN3gi50LMEDxvkT7tM02rb226LAJXm7CsONI=;
X-YMail-OSG: RPkVjTIVM1lNLhiDNOIb7mfjBKlF1gzwh3eVSC_X5migVJcpapXKh5oQaLBqLLP_1w--
X-Mailer: YahooMailWebService/0.7.218.2
Date: Wed, 3 Sep 2008 12:02:03 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: rankincj@yahoo.com
Subject: Linux 2.6.26.3: parallel port trouble
To: linux-kernel@vger.kernel.org
Cc: tim@cyberelk.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <378641.67469.qm@web52912.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone,

I'm seeing some strange output in the dmesg log with a 2.6.26.3 UP kernel when it prints to an old HP OfficeJet parallel port printer:

ppdev0: registered pardevice
sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice  Sysctl already exists
Pid: 3268, comm: hpijs Not tainted 2.6.26.3 #1
 [<c0129dd8>] set_fail+0x30/0x39
 [<c012a1f2>] sysctl_check_table+0x411/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c011c802>] __register_sysctl_paths+0xa0/0x102
 [<c011c87e>] register_sysctl_paths+0x1a/0x1c
 [<d9955458>] parport_device_proc_register+0xa2/0xbc [parport]
 [<d99537e1>] parport_register_device+0x1f8/0x220 [parport]
 [<d993f2f7>] pp_ioctl+0x11e/0x76e [ppdev]
 [<d993f947>] pp_irq+0x0/0x89 [ppdev]
 [<c0167e85>] vfs_ioctl+0x49/0x5f
 [<c01680d3>] do_vfs_ioctl+0x238/0x24a
 [<c0168111>] sys_ioctl+0x2c/0x43
 [<c0102c36>] syscall_call+0x7/0xb
 =======================
ppdev0: registered pardevice
...
ppdev0: unregistered pardevice
ppdev0: released pardevice because user-space forgot
ppdev0: unregistered pardevice
ppdev0: registered pardevice
sysctl table check failed: /dev/parport/parport0/devices/ppdev0/timeslice  Sysctl already exists
Pid: 6643, comm: hpijs Not tainted 2.6.26.3 #1
 [<c0129dd8>] set_fail+0x30/0x39
 [<c012a1f2>] sysctl_check_table+0x411/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c012a209>] sysctl_check_table+0x428/0x44f
 [<c011c802>] __register_sysctl_paths+0xa0/0x102
 [<c011c87e>] register_sysctl_paths+0x1a/0x1c
 [<d9955458>] parport_device_proc_register+0xa2/0xbc [parport]
 [<d99537e1>] parport_register_device+0x1f8/0x220 [parport]
 [<d993f2f7>] pp_ioctl+0x11e/0x76e [ppdev]
 [<d993f947>] pp_irq+0x0/0x89 [ppdev]
 [<c0167e85>] vfs_ioctl+0x49/0x5f
 [<c01680d3>] do_vfs_ioctl+0x238/0x24a
 [<c0168111>] sys_ioctl+0x2c/0x43
 [<c0102c36>] syscall_call+0x7/0xb
 =======================
ppdev0: registered pardevice
ppdev0: unregistered pardevice
ppdev0: unregistered pardevice

The printer is still printing, so I'm guessing that these warnings aren't too serious - yet. But they worry me.

Cheers,
Chris



      
