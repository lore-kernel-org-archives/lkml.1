Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab0BAFGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 00:06:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56192 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab0BAFGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 00:06:50 -0500
Message-ID: <4B666164.3090504@cn.fujitsu.com>
Date: Mon, 01 Feb 2010 13:06:44 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: zohar@us.ibm.com, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: security ima: Kernel BUG in ima_file_free -- bisected to commit 6c21a7fb492bf7e2c4985937082ce58ddeca84bd
Content-Type: multipart/mixed;
 boundary="------------040907040404090402050003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040907040404090402050003
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi, Mimi

Used the latest LTP to test 2.6.33-rc6, a Kernel BUG occured on my x86_64 (OS: Fedora 12).
The message from dmesg is as following.
The LTP case is testcases/kernel/syscalls/pipe/pipe06.c. For seeing code easily, I
recreated a simple code to reproduce this BUG. please check the code in the attached.

I bisected a commit 6c21a7fb492bf7e2c4985937082ce58ddeca84bd,
    --------
    commit 6c21a7fb492bf7e2c4985937082ce58ddeca84bd
    Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
    Date:   Thu Oct 22 17:30:13 2009 -0400

         LSM: imbed ima calls in the security hooks
    --------
Maybe you should fix it ;-)

--------------------------------------------------------------------------
BUG: unable to handle kernel NULL pointer dereference at 00000000000000ae
IP: [<ffffffff811e3057>] ima_file_free+0x2e/0x1fb
PGD 13a08e067 PUD 139fdf067 PMD 0
Oops: 0000 [#2] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:19:00.0/0000:1a:00.0/irq
CPU 1
Pid: 1868, comm: a.out Tainted: G      D    2.6.33-rc6 #1 D2671/PRIMERGY
RIP: 0010:[<ffffffff811e3057>]  [<ffffffff811e3057>] ima_file_free+0x2e/0x1fb
RSP: 0018:ffff88013a713e48  EFLAGS: 00010202
RAX: ffff8801325a70c0 RBX: ffff88013a1c1f00 RCX: 0000041500000415
RDX: 000004143a713e68 RSI: ffffffff81a3a080 RDI: ffff88013a1c1f00
RBP: ffff88013a713e88 R08: ffff88013b75c8c0 R09: ffff88013a713ec8
R10: ffff88013a713df8 R11: ffff88013a713e08 R12: ffff88013a1c1f00
R13: 0000000000000000 R14: 00000000ffffffe8 R15: ffff88013a713f38
FS:  00007f6e5ea48700(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000ae CR3: 000000013a101000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process a.out (pid: 1868, threadinfo ffff88013a712000, task ffff880137e20000)
Stack:
 000004143a713e68 0000041500000415 ffff88013fc03500 ffff88013a1c1f00
<0> ffff880133d3a000 ffff88013a1c1f00 00000000ffffffe8 ffff88013a713f38
<0> ffff88013a713ea8 ffffffff811c87f9 ffff88013a713ea8 ffff88013a1c1f00
Call Trace:
 [<ffffffff811c87f9>] security_file_free+0x2d/0x31
 [<ffffffff81106767>] put_filp+0x22/0x36
 [<ffffffff8110c53c>] free_write_pipe+0x2f/0x34
 [<ffffffff8110d161>] do_pipe_flags+0xdc/0xf6
 [<ffffffff8110d19c>] sys_pipe2+0x21/0x63
 [<ffffffff8110d1ee>] sys_pipe+0x10/0x12
 [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Code: e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 0f 1f 44 00 00 83 3d a2 50 bb 00 00 48 8b 47 18 49 89 fc 4c 8b 68 10 0f 84 bb 01 00 00 <41> 0f b7 85 ae 00 00 00 25 00 f0 00 00 3d 00 80 00 00 0f 85 a3
RIP  [<ffffffff811e3057>] ima_file_free+0x2e/0x1fb
 RSP <ffff88013a713e48>
CR2: 00000000000000ae
---[ end trace 1d8416bb1c67accb ]---
--------------------------------------------------------------------------

Shi Weihua

--------------040907040404090402050003
Content-Type: text/plain;
 name="pipe.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pipe.c"

#include <fcntl.h>
#include <errno.h>

int pipe_ret, pipes[2];

int main(int ac, char **av)
{
	int i, numb_fds;

        numb_fds = getdtablesize();

	for (i = 0; i < numb_fds; i++) {
		pipe_ret = pipe(pipes);
		if (pipe_ret < 0) {
			if (errno != EMFILE)
				printf ("got unexpected error - %d", errno);
			else
				printf ("got expected error - %d", errno);
			break;
		 }
	 }

	return 0;
}


--------------040907040404090402050003--
