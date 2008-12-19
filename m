Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbYLSUgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbYLSUgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYLSUgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:36:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:31438 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYLSUf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ZU23MXVc2aaiG/q4d/7JDG8gXl1FGmlwWBKYSx9zlF/SMg+VvtUpCP1suryGLiAAgg
         RvsZHhoAhGObxLuUtNG8yGhQmm3U8HOaGIQMv/rKWGXgEFfCAHpZn0oYvKo+ECWF/rfl
         vE5BcZaOqDuU5pStnY1S/X80r9vd6BUnWw/LM=
Message-ID: <84144f020812191235u4106766bhee28134632c302e2@mail.gmail.com>
Date: Fri, 19 Dec 2008 22:35:57 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: v2.6.28-rc7: error in panic code? (NULL pointer dereference at 0000004c)
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081219173946.GA18240@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0812181406n48712c81j41a560aaf6ba6cd8@mail.gmail.com>
	 <19f34abd0812190919g348b581ex9ebb2e83701899c7@mail.gmail.com>
	 <20081219173946.GA18240@suse.de>
X-Google-Sender-Auth: ffd6b7bcd45ff198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Dec 19, 2008 at 06:19:43PM +0100, Vegard Nossum wrote:
> Fixes what?  It might be quite difficult to revert that patch now, as
> the infrastructure is no longer in place to use a private pci device
> list, that code is long gone.

Vegard forced one oops but got two! The first one is expected and but
the second one shouldn't probably be there:

>> > And now the unexpected part:
>> >
>> > [    0.039999] Rebooting in 10 seconds..<1>BUG: unable to handle
>> > kernel NULL pointer dereference at 0000004c
>> > [    0.040993] IP: [<c13b41dc>] klist_next+0x10/0x8d
>> > [    0.040993] *pde = 00000000
>> > [    0.040993] Oops: 0000 [#2] SMP
>> > [    0.040993] last sysfs file:
>> > [    0.040993] Modules linked in:
>> > [    0.040993]
>> > [    0.040993] Pid: 0, comm: swapper Tainted: G      D    (2.6.28-rc7
>> > #181) 945P-A
>> > [    0.040993] EIP: 0060:[<c13b41dc>] EFLAGS: 00010286 CPU: 0
>> > [    0.040993] EIP is at klist_next+0x10/0x8d
>> > [    0.040993] EAX: 0000003c EBX: c165dd60 ECX: 00000000 EDX: c165dd60
>> > [    0.040993] ESI: c165dd60 EDI: 00000000 EBP: c165dd58 ESP: c165dd48
>> > [    0.040993]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>> > [    0.040993] Process swapper (pid: 0, ti=c165c000 task=c156e334
>> > task.ti=c165c000)
>> > [    0.040993] Stack:
>> > [    0.040993]  c1026a97 c165dd60 c165dd60 00000000 c165dd74 c11be196
>> > 0000003c 00000000
>> > [    0.040993]  c13dbde0 00001078 00000100 c165dd84 c114ed26 c114e458
>> > c13dbde0 c165dd9c
>> > [    0.040993]  c1152546 ffffffff c13dbde0 00002710 0000000b c165ddac
>> > c115259a ffffffff
>> > [    0.040993] Call Trace:
>> > [    0.040993]  [<c1026a97>] ? release_console_sem+0x16c/0x199
>> > [    0.040993]  [<c11be196>] ? bus_find_device+0x4e/0x6e
>> > [    0.040993]  [<c114ed26>] ? no_pci_devices+0x17/0x2d
>> > [    0.040993]  [<c114e458>] ? find_anything+0x0/0xa
>> > [    0.040993]  [<c1152546>] ? pci_get_subsys+0x15/0x5b
>> > [    0.040993]  [<c115259a>] ? pci_get_device+0xe/0x10
>> > [    0.040993]  [<c1013342>] ? mach_reboot_fixups+0x27/0x3c
>> > [    0.040993]  [<c100fdfb>] ? native_machine_emergency_restart+0x3e/0xd7
>> > [    0.040993]  [<c100fc60>] ? machine_emergency_restart+0x9/0xb
>> > [    0.040993]  [<c1032b4b>] ? emergency_restart+0x8/0xa
>> > [    0.040993]  [<c13cf607>] ? panic+0xb9/0xd6
>> > [    0.040993]  [<c1028ee0>] ? do_exit+0x5b/0x740
>> > [    0.040993]  [<c13cf633>] ? printk+0xf/0x11
>> > [    0.040993]  [<c10263df>] ? print_oops_end_marker+0x1e/0x23
>> > [    0.040993]  [<c13d1c1e>] ? oops_end+0x7f/0x87
>> > [    0.040993]  [<c1005a08>] ? die+0x5b/0x63
>> > [    0.040993]  [<c13d3061>] ? do_page_fault+0x581/0x66f
>> > [    0.040993]  [<c103a537>] ? sched_clock_cpu+0x136/0x142
>> > [    0.040993]  [<c103a537>] ? sched_clock_cpu+0x136/0x142
>> > [    0.040993]  [<c1039165>] ? ktime_get+0x13/0x2f
>> > [    0.040993]  [<c103a562>] ? sched_clock_idle_sleep_event+0xe/0x10
>> > [    0.040993]  [<c102a86f>] ? __do_softirq+0x119/0x121
>> > [    0.040993]  [<c116e282>] ? acpi_hw_low_level_read+0x3b/0x68
>> > [    0.040993]  [<c116e34f>] ? acpi_hw_register_read+0xa0/0x112
>> > [    0.040993]  [<c116e4f0>] ? acpi_get_register_unlocked+0x2c/0x48
>> > [    0.040993]  [<c1161aa7>] ? acpi_os_release_lock+0x8/0xa
>> > [    0.040993]  [<c116e67b>] ? acpi_get_register+0x2d/0x34
>> > [    0.040993]  [<c13d2ae0>] ? do_page_fault+0x0/0x66f
>> > [    0.040993]  [<c13d13da>] ? error_code+0x72/0x78
>> > [    0.040993]  [<c16631e3>] ? kernel_init+0x0/0x148
>> > [    0.040993]  [<c13b448b>] ? rest_init+0xf/0x57
>> > [    0.040993]  [<c16637af>] ? start_kernel+0x2a2/0x2a7
>> > [    0.040993]  [<c1663080>] ? __init_begin+0x80/0x88
>> > [    0.040993] Code: 89 4a 04 74 08 8d 41 0c e8 fa 04 d9 ff 5d c3 55
>> > 31 c9 89 e5 e8 e0 ff ff ff 5d c3 55 89 e5 57 56 89 c6 5
>> > 3 83 ec 04 8b 00 8b 7e 04 <8b> 50 10 89 55 f0 e8 7b cf 01 00 85 ff 74
>> > 23 8b 47 04 ba ec 42
>> > [    0.040993] EIP: [<c13b41dc>] klist_next+0x10/0x8d SS:ESP 0068:c165dd48

Looks like the patch Vegard identified breaks something in the oops path?
