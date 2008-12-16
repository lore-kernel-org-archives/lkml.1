Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbYLPCmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbYLPCmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYLPCmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:42:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63912 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbYLPCmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:42:24 -0500
Message-ID: <49471540.8090304@cn.fujitsu.com>
Date: Tue, 16 Dec 2008 10:41:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, balbir@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Subject: Re: [BUG][PANIC] cgroup panics with mmotm for 2.6.28-rc7
References: <20081215113253.GL18403@balbir.in.ibm.com> <6599ad830812151757t5362ae16y81b469b06022135c@mail.gmail.com>
In-Reply-To: <6599ad830812151757t5362ae16y81b469b06022135c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> That implies that we ran out of css_set objects when moving the task
> into the new cgroup.
> 
> Did you have all of the configured controllers mounted, or just a subset?
> 
> What date was this mmotm? Was it after Li's patch fixes went in on 8th Dec?
> 

It is probably my fault. :( I'm looking into this problem.

There are 2 related cleanup patches in -mm:

cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch (and -fix.patch)
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch (and -fix.patch)

If the bug is reproducable, could you revert the above patches and seee if the
bug is still there.

> Paul
> 
> On Mon, Dec 15, 2008 at 3:32 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Hi, Paul,
>>
>> I see the following stack trace when I run my tests. I've not yet
>> investigated the problem.
>>
>> ------------[ cut here ]------------
>> kernel BUG at kernel/cgroup.c:392!
>> invalid opcode: 0000 [#1] SMP
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.5/0000:03:00.0/irq
>> CPU 1
>> Modules linked in: coretemp hwmon kvm_intel kvm rtc_cmos rtc_core
>> rtc_lib mptsas mptscsih mptbase scsi_transport_sas uhci_hcd ohci_hcd
>> ehci_hcd
>> Pid: 3866, comm: libcgrouptest01 Tainted: G        W  2.6.28-rc7-mm1
>> #3
>> RIP: 0010:[<ffffffff80272c5b>]  [<ffffffff80272c5b>]
>> link_css_set+0xf/0x5a
>> RSP: 0018:ffff8800388ebda8  EFLAGS: 00010246
>> RAX: ffffffff807a2790 RBX: ffff88003e9667e0 RCX: ffff88012f6ecff8
>> RDX: ffff88012f6ecff8 RSI: ffff88003e9667e0 RDI: ffff8800388ebdf8
>> RBP: ffff8800388ebda8 R08: ffff8800388ebdf8 R09: 0000000000000000
>> R10: ffff88003a55d000 R11: ffffe2000196d170 R12: ffff88003e9667e0
>> R13: 0000000000000001 R14: ffff880038838000 R15: ffffffff811d3c00
>> FS:  00007f482219e700(0000) GS:ffff88007ff064b0(0000)
>> knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 00007f48221cc000 CR3: 0000000038896000 CR4: 00000000000026e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process libcgrouptest01 (pid: 3866, threadinfo ffff8800388ea000, task
>> ffff880038838000)
>> Stack:
>>  ffff8800388ebe48 ffffffff802740dd ffffffff80272955 ffff88012f6ecff8
>>  ffff8800389b4028 ffff8800389b4000 ffffffff807aa720 ffff88012f6ecb68
>>  ffff88012fd852a8 0000000000000246 ffff8800388ebdf8 ffff8800388ebdf8
>> Call Trace:
>>  [<ffffffff802740dd>] cgroup_attach_task+0x234/0x3d0
>>  [<ffffffff80272955>] ? cgroup_lock_live_group+0x1a/0x36
>>  [<ffffffff80274380>] cgroup_tasks_write+0x107/0x12e
>>  [<ffffffff802742b8>] ? cgroup_tasks_write+0x3f/0x12e
>>  [<ffffffff802748d4>] cgroup_file_write+0xfb/0x22d
>>  [<ffffffff8039e30d>] ? __up_read+0x9b/0xa3
>>  [<ffffffff802ba77d>] vfs_write+0xae/0x157
>>  [<ffffffff802bac98>] sys_write+0x47/0x6f
>>  [<ffffffff8020bfdb>] system_call_fastpath+0x16/0x1b
>> Code: 8b 5b 30 48 39 c3 74 06 48 3b 5b 60 75 f1 48 39 c3 0f 94 c0 0f
>> b6 c0 5b 5a 5b c9 c3 4c 8b 07 55 48 89 d1 48 89 e5 49 39 f8 75 04 <0f>
>> 0b eb fe 49 8b 40 08 49 8b 10 49 89 70 20 48 89 10 48 89 42
>> RIP  [<ffffffff80272c5b>] link_css_set+0xf/0x5a
>>  RSP <ffff8800388ebda8>
>> ---[ end trace b73399e271602d45 ]---
>>
>> I've setup my system using libcgroup to create default cgroups and to
>> automatically classify all tasks to the "default group". I've made
>> some changes to cgconfig and cgred scripts (they can be found under
>> the source code of libcgroup (branches/balbir-tests).
>>
>> Steps to reproduce
>>
>> 1. Start with the new scripts and move all tasks to a default cgroup
>> 2. Ensure that cgred and cgconfig are running
>> 3. Stop cgred and cgconfig and run libcgrouptest01 (patches posted by
>> sudhir on the libcgroup mailing list).
>>
>> The test log is
>>
>> WARN: /dev/cgroup_controllers-1 already exist..overwriting
>> C:DBG: fs_mounted as recieved from script=1
>> C:DBG: mountpoint1 as recieved from script=/dev/cgroup_controllers-1
>> sanity check pass. cgroup
>> TEST 1:PASS : cgroup_attach_task()               Ret Value = 50014
>> Par: nullcgroup
>> TEST 2:PASS : cgroup_init()                      Ret Value = 0
>> TEST 3:PASS : cgroup_attach_task()               Ret Value = 0   Task
>> found in group/s
>> TEST 4:PASS : cgroup_attach_task_pid()           Ret Value = 50016
>> TEST 1:PASS : cgroup_new_cgroup()                Ret Value = 0
>> TEST 2:PASS : cgroup_create_cgroup()             Ret Value = 0   grp
>> found in fs
>>
>>
