Return-Path: <linux-kernel-owner+w=401wt.eu-S934857AbZDJJdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934857AbZDJJdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbZDJJdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:33:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52519 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755010AbZDJJdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:33:20 -0400
Message-ID: <49DF1256.7080403@cn.fujitsu.com>
Date: Fri, 10 Apr 2009 17:33:10 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [RFC] IO Controller
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Hi All,
> 
> Here is another posting for IO controller patches. Last time I had posted
> RFC patches for an IO controller which did bio control per cgroup.

  Hi Vivek,

  I got the following OOPS when testing, can't reproduce again :(

kernel BUG at block/elevator-fq.c:1396!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/block/hdb/queue/scheduler
Modules linked in: ipv6 cpufreq_ondemand acpi_cpufreq dm_mirror dm_multipath sbd
Pid: 5032, comm: rmdir Not tainted (2.6.29-rc7-vivek #17) Veriton M460
EIP: 0060:[<c04ec7de>] EFLAGS: 00010082 CPU: 0
EIP is at iocg_destroy+0xdc/0x14e
EAX: 00000000 EBX: f62278b4 ECX: f6207800 EDX: f6227904
ESI: f6227800 EDI: f62278a0 EBP: 00000003 ESP: c8790f00
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rmdir (pid: 5032, ti=c8790000 task=f6636960 task.ti=c8790000)
Stack:
 f53cc5c0 f62b7258 f10991c8 00000282 f6227800 c0733fa0 ec1c5140 edfc6d34
 c8790000 c04463ce f6a4c84c edfc6d34 0804c840 c048883c f6a4c84c f6a4c84c
 c04888d6 f6a4c84c 00000000 c04897de f6a4c84c c048504c f115f4c0 ebc37954
Call Trace:
 [<c04463ce>] cgroup_diput+0x41/0x8c
 [<c048883c>] dentry_iput+0x45/0x5e
 [<c04888d6>] d_kill+0x19/0x32
 [<c04897de>] dput+0xd8/0xdf
 [<c048504c>] do_rmdir+0x8f/0xb6
 [<c06330fc>] do_page_fault+0x2a2/0x579
 [<c0402fc1>] sysenter_do_call+0x12/0x21
 [<c0630000>] schedule+0x641/0x830
Code: 08 00 74 04 0f 0b eb fe 83 7f 04 00 74 04 0f 0b eb fe 45 83 c3 1c 83 fd 0
EIP: [<c04ec7de>] iocg_destroy+0xdc/0x14e SS:ESP 0068:c8790f00

-- 
Regards
Gui Jianfeng

