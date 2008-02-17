Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYBQFDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYBQFDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYBQFC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:02:59 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:38937 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750703AbYBQFC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:02:58 -0500
Message-ID: <47B7BFF8.4090102@linux.vnet.ibm.com>
Date: Sun, 17 Feb 2008 10:32:48 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, oleg@tv-sign.ru, roland@redhat.com,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.25-rc2-mm1 - Kernel panic while bootup caused by signal_group_exit()
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7B3B9.2090706@linux.vnet.ibm.com> <20080216205048.656d4a48.akpm@linux-foundation.org>
In-Reply-To: <20080216205048.656d4a48.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 17 Feb 2008 09:40:33 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> Hi Andrew,
>>
>> The signals-do_signal_stop-use-signal_group_exit.patch is causing the
>> kernel panic, while booting in to the 2.6.25-rc2-mm1 kernel on x86.
>>
>> There has been discussion on the patch for this panic on http://lkml.org/lkml/2008/2/16/99 
>>
>> [   25.512919] BUG: unable to handle kernel paging request at 9d74e37b
>> [   25.514926] IP: [<c04a8fac>] proc_flush_task+0x5b/0x223
>> [   25.516934] Oops: 0000 [#1] SMP 
>> [   25.517918] last sysfs file: /sys/block/hdc/removable
>> [   25.517918] Modules linked in: dm_mirror dm_mod video output sbs sbshc battery ac parport_pc lp parport floppy sg serio_raw ide_cd_mod cdrom scb2_flash mtd chipreg button i2c_piix4 i2c_core pcspkr tg3 mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
>> [   25.517918] 
>> [   25.517918] Pid: 1, comm: init Not tainted (2.6.25-rc2-mm1-autotest #1)
>> [   25.517918] EIP: 0060:[<c04a8fac>] EFLAGS: 00010282 CPU: 2
>> [   25.517918] EIP is at proc_flush_task+0x5b/0x223
>> [   25.517918] EAX: 9d74e35b EBX: f7881ef0 ECX: f7a5ed84 EDX: a56b6b6b
>> [   25.517918] ESI: f74f76f8 EDI: a56b6b6b EBP: f7881f08 ESP: f7881ec0
>> [   25.517918]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> [   25.517918] Process init (pid: 1, ti=f7881000 task=f788adf0 task.ti=f7881000)
>> [   25.517918] Stack: f7a5ed84 00000001 f7a5ed58 f7a5ed58 00000000 a56b6b6b f7852750 f7a5ed68 
>> [   25.517918]        35881ef4 00003130 f788b4a4 f788adf0 0012d6c5 00000003 f7881ee3 00000003 
>> [   25.517918]        f7a72df0 f7a72df0 f7881f1c c042676d 00000003 000001f5 f7a72df0 f7881f78 
>> [   25.517918] Call Trace:
>> [   25.517918]  [<c042676d>] release_task+0x19/0x2d5
>> [   25.517918]  [<c042701b>] do_wait+0x5f2/0x8fc
>> [   25.517918]  [<c041d9e7>] default_wake_function+0x0/0xd
>> [   25.517918]  [<c042739d>] sys_wait4+0x78/0x8e
>> [   25.517918]  [<c04273c6>] sys_waitpid+0x13/0x15
>> [   25.517918]  [<c04039ba>] sysenter_past_esp+0x5f/0x99
>> [   25.517918]  =======================
>> [   25.517918] Code: 1c 89 4d d4 89 4d c4 89 55 b8 e9 b5 01 00 00 31 ff 83 7d c4 00 74 06 8b 45 d4 8b 78 1c 8b 55 b8 8b 4d b8 8b 12 89 55 cc 8b 41 04 <8b> 40 20 52 68 33 cd 6f c0 6a 0d 89 45 d0 8d 45 db 50 89 45 f0 
>> [   25.517918] EIP: [<c04a8fac>] proc_flush_task+0x5b/0x223 SS:ESP 0068:f7881ec0
>> [   25.517939] ---[ end trace d0df919a64605019 ]---
>> [   25.518925] Kernel panic - not syncing: Attempted to kill init!
>>
> 
> hm, are you sure that signals-do_signal_stop-use-signal_group_exit.patch
> causes this oops?  

sorry signals-do_signal_stop-use-signal_group_exit.patch is not causing the problem, not sure of what is causing this panic :-(

