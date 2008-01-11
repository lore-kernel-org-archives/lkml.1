Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYAKCYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYAKCYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 21:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbYAKCYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 21:24:35 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60085 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756307AbYAKCYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 21:24:35 -0500
Message-ID: <4786D35F.6030604@garzik.org>
Date: Thu, 10 Jan 2008 21:24:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Serverworks Oops with the very latest git kernel...
References: <1200017238.20100.16.camel@heimdal.trondhjem.org>
In-Reply-To: <1200017238.20100.16.camel@heimdal.trondhjem.org>
Content-Type: multipart/mixed;
 boundary="------------050104030503010603080507"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050104030503010603080507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Trond Myklebust wrote:
> Hi,
> 
> I'm getting the following Oops on boot with kernel 2.6.24-rc7-g88fb61e4.
> 
> Starting udev: BUG: unable to handle kernel paging request at virtual address 2d6d3a65
> printing eip: c04e1af1 *pde = 00000000 
> Oops: 0000 [#1] PREEMPT SMP 
> Modules linked in: evdev evbug rtc_cmos pcspkr floppy rtc_core rtc_lib shpchp pci_hotplug serverworks tg3 generic i2c_piix4 i2c_core
> 
> Pid: 1820, comm: modprobe Not tainted (2.6.24-rc7-g88fb61e4 #2)
> EIP: 0060:[<c04e1af1>] EFLAGS: 00210286 CPU: 0
> EIP is at strstr+0x11/0x34
> EAX: 00000000 EBX: 2d6d3a65 ECX: ffffffff EDX: 2d6d3a65
> ESI: c0513f75 EDI: 2d6d3a65 EBP: f65bccec ESP: f65bcce0
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 1820, ti=f65bc000 task=f795a2f0 task.ti=f65bc000)
> Stack: f8921a44 00000001 00000000 f65bcd00 c054a0b9 f892e394 f892e080 f892e5f8 
>        f65bcd20 f892133b c04d7c9d f892da80 f891d339 f892e394 f892e080 f892e5f8 
>        f65bcd64 f891d11f f891d339 f891bc38 f892e080 00000000 00000001 00000000 
> Call Trace:
>  [<c0405170>] show_trace_log_lvl+0x1a/0x2f
>  [<c0405222>] show_stack_log_lvl+0x9d/0xa5
>  [<c04052cd>] show_registers+0xa3/0x1df
>  [<c040552a>] die+0x121/0x204
>  [<c05b40dd>] do_page_fault+0x557/0x63e
>  [<c05b278a>] error_code+0x72/0x78
>  [<c054a0b9>] dmi_check_system+0x2f/0x58
>  [<f892133b>] ide_acpi_init+0x28/0x195 [ide_core]
>  [<f891d11f>] hwif_init+0x324/0x37c [ide_core]
>  [<f891d29a>] ide_device_add+0x3b/0xa6 [ide_core]
>  [<f891ee9a>] ide_setup_pci_device+0x36/0x40 [ide_core]
>  [<f885f11c>] svwks_init_one+0x5b/0x62 [serverworks]
>  [<c04eada1>] pci_device_probe+0x39/0x5b
>  [<c05369a8>] driver_probe_device+0xe9/0x16a
>  [<c0536b43>] __driver_attach+0x6c/0xa5
>  [<c0535e92>] bus_for_each_dev+0x36/0x5b
>  [<c05367f3>] driver_attach+0x19/0x1b
>  [<c05361b1>] bus_add_driver+0x73/0x1aa
>  [<c0536d29>] driver_register+0x67/0x6c
>  [<c04eaef9>] __pci_register_driver+0x56/0x83
>  [<f890f017>] svwks_ide_init+0x17/0x19 [serverworks]
>  [<c0447f1e>] sys_init_module+0x15da/0x1715
>  [<c04040b2>] sysenter_past_esp+0x5f/0xa5
>  =======================
> Code: e5 89 c1 89 c8 eb 06 80 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 90 90 90 55 89 e5 57 56 53 89 c6 89 d3 31 c0 83 c9 ff 89 
> EIP: [<c04e1af1>] strstr+0x11/0x34 SS:ESP 0068:f65bcce0
> ---[ end trace f0316f13333e9ff3 ]---
> udevd-event[1819]: run_program: '/sbin/modprobe' abnormal exit
> 
> 
> Any ideas? As far as I can see, 2.6.24-rc7 itself is good, so I suspect
> the recent merge by Bart.
> 
> I've set up a bugzilla entry for the regression on
>         http://bugzilla.kernel.org/show_bug.cgi?id=9728

Does this patch fix it?

Looks like an unterminated DMI table...

	Jeff



--------------050104030503010603080507
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index fe6768a..8b23ea5 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -85,6 +85,8 @@ static const struct dmi_system_id ide_acpi_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "KAM1.60")
 		},
 	},
+
+	{ }
 };
 
 static int ide_acpi_blacklist(void)

--------------050104030503010603080507--
