Return-Path: <linux-kernel-owner+w=401wt.eu-S1161095AbXBBMjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161095AbXBBMjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 07:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161111AbXBBMjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 07:39:53 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:53378 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161095AbXBBMjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 07:39:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nfLE+tqrTWEwGolYynKEk8sWOF7q8C1M0XaxrNMZSIQwdSNwTkV7zvxNH+ZPb/LdyipGjA/tAy9qj+5PV2YmFg6B8PcMp8QsprDcGOgpgU4TiQ3YV1pVv5AUuBflFrj58QtlHYvwJGERLCUcDlyh+MsHQn2ujMAP0Ov+VRON7f4=
Message-ID: <e9f486400702020439l5377918by72069e735448e5f@mail.gmail.com>
Date: Fri, 2 Feb 2007 13:39:50 +0100
From: "Henri Hunnekens" <henrihunnekens@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel BUG: loading acpi_cpufreq causes segmentation fault with 2.6.20-RC7-RT3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Loading the acpi_cpufreq module causes a segmentation fault with
kernel version 2.6.20-rt7-rt3.

Does anyone know how to fix this?

Henri

kernel BUG at drivers/acpi/osl.c:373!
invalid opcode: 0000 [#1]
PREEMPT SMP
Modules linked in: acpi_cpufreq freq_table cap_over commoncap i2c_dev uhci_hcd i
2c_i801 i2c_core ehci_hcd
CPU:    0
EIP:    0060:[<c027dbd9>]    Not tainted VLI
EFLAGS: 00010297   (2.6.20-rc7-rt3 #1)
EIP is at acpi_os_write_port+0x2d/0x36
eax: 00000001   ebx: 00000832   ecx: 00000001   edx: 00000001
esi: de561920   edi: 00000000   ebp: dd3d1c90   esp: dd3d1c8c
ds: 007b   es: 007b   ss: 0068   preempt: 00000001
Process modprobe (pid: 2543, ti=dd3d0000 task=de656660 task.ti=dd3d0000)
Stack: 00000000 dd3d1cf0 e0074455 00000001 dd3d1ce0 c039bff2 dcf84940 00000000
       df40d000 00000001 00000001 dd3d1cd0 c016612f 00000002 00000001 dc010832
       00000001 00000000 002cc108 002cc108 c03f1302 00000000 df2d0d80 e00742d0
Call Trace:
 [<c010566a>] show_trace_log_lvl+0x1a/0x30
 [<c0105738>] show_stack_log_lvl+0xb8/0xf0
 [<c0105950>] show_registers+0x1e0/0x300
 [<c0105b95>] die+0x125/0x260
 [<c0105d52>] do_trap+0x82/0xd0
 [<c0106727>] do_invalid_op+0x97/0xb0
 [<c03f1c7c>] error_code+0x7c/0x84
 [<e0074455>] acpi_cpufreq_target+0x185/0x290 [acpi_cpufreq]
 [<c037881f>] __cpufreq_driver_target+0x3f/0x50
 [<c037a0de>] cpufreq_governor_performance+0x1e/0x30
 [<c0378984>] __cpufreq_governor+0x24/0xd0
 [<c0378e9b>] __cpufreq_set_policy+0xeb/0x140
 [<c03790fe>] cpufreq_set_policy+0x4e/0x80
 [<c0379d4a>] cpufreq_add_dev+0x31a/0x3e0
 [<c02bdfc9>] sysdev_driver_register+0x59/0xa0
 [<c037a027>] cpufreq_register_driver+0x67/0x100
 [<e007809d>] acpi_cpufreq_init+0x9d/0xa4 [acpi_cpufreq]
 [<c01423f7>] sys_init_module+0x137/0x1b90
 [<c0104620>] syscall_call+0x7/0xb
 =======================
Code: f9 10 89 e5 53 89 c3 89 d0 74 12 83 f9 20 74 16 83 f9 08 75 16 0f b6 c2 89
 da ee eb 12 0f b7 c2 89 da 66 ef eb 09 89 da ef eb 04 <0f> 0b eb fe 5b 31 c0 5d
 c3 55 89 e5 5d c3 55 85 c0 89 e5 89 c1
EIP: [<c027dbd9>] acpi_os_write_port+0x2d/0x36 SS:ESP 0068:dd3d1c8c
 Segmentation fault
