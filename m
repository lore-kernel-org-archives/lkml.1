Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314Ab0AQCWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0AQCWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 21:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270Ab0AQCWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 21:22:32 -0500
Received: from mga05.intel.com ([192.55.52.89]:56396 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753256Ab0AQCWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 21:22:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,288,1262592000"; 
   d="scan'208";a="764845722"
Message-ID: <4B527465.2070107@linux.intel.com>
Date: Sun, 17 Jan 2010 10:22:29 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm/srat_64.c: nodes_parsed should include all nodes
 detected by ACPI.
References: <4B501C4D.4080907@linux.intel.com>
In-Reply-To: <4B501C4D.4080907@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Would there be any potential issue with this patch? Without this fix, hotadding a CPU with MEM 
attached will cause kernel BUG like below. So this could even be a fix for stable, any comments?

the BUG is:
[  141.667487] BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
[  141.667782] IP: [<ffffffff810b8a64>] cache_reap+0x71/0x236
[  141.667969] PGD 0
[  141.668129] Oops: 0000 [#1] SMP
[  141.668357] last sysfs file: /sys/class/scsi_host/host4/proc_name
[  141.668469] CPU
[  141.668630] Modules linked in: ipv6 autofs4 rfcomm l2cap crc16 bluetooth rfkill binfmt_misc 
dm_mirror dm_region_hash dm_log dm_multipath dm_mod video output sbs sbshc fan battery ac parport_pc 
lp parport joydev usbhid sr_mod cdrom thermal processor thermal_sys container button rtc_cmos 
rtc_core rtc_lib i2c_i801 i2c_core pcspkr uhci_hcd ohci_hcd ehci_hcd usbcore
[  141.671659] Pid: 126, comm: events/27 Not tainted 2.6.32 #9  Server
[  141.671771] RIP: 0010:[<ffffffff810b8a64>]  [<ffffffff810b8a64>] cache_reap+0x71/0x236
[  141.671981] RSP: 0018:ffff88027e81bdf0  EFLAGS: 00010206
[  141.672089] RAX: 0000000000000002 RBX: 0000000000000078 RCX: ffff88047d86e580
[  141.672204] RDX: ffff88047dfcbc00 RSI: ffff88047f13f6c0 RDI: ffff88047d9136c0
[  141.672319] RBP: ffff88027e81be30 R08: 0000000000000001 R09: 0000000000000001
[  141.672433] R10: 0000000000000000 R11: 0000000000000086 R12: ffff88047d87c200
[  141.672548] R13: ffff88047d87d680 R14: ffffffff810b89f3 R15: 0000000000000002
[  141.672663] FS:  0000000000000000(0000) GS:ffff88028b5a0000(0000) knlGS:0000000000000000
[  141.672807] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  141.672917] CR2: 0000000000000078 CR3: 0000000001001000 CR4: 00000000000006e0
[  141.673032] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  141.673147] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  141.673262] Process events/27 (pid: 126, threadinfo ffff88027e81a000, task ffff88027f3ea040)
[  141.673406] Stack:
[  141.673503]  ffff88027e81be30 ffff88028b5b05a0 0000000100000000 ffff88027e81be80
[  141.673808] <0> ffff88028b5b5b40 ffff88028b5b05a0 ffffffff810b89f3 fffffffff00000c6
[  141.674265] <0> ffff88027e81bec0 ffffffff81057394 ffffffff8105733e ffffffff81369f3a
[  141.674813] Call Trace:
[  141.674915]  [<ffffffff810b89f3>] ? cache_reap+0x0/0x236
[  141.675028]  [<ffffffff81057394>] worker_thread+0x17a/0x27b
[  141.675138]  [<ffffffff8105733e>] ? worker_thread+0x124/0x27b
[  141.675256]  [<ffffffff81369f3a>] ? thread_return+0x3e/0xee
[  141.675369]  [<ffffffff8105a244>] ? autoremove_wake_function+0x0/0x38
[  141.675482]  [<ffffffff8105721a>] ? worker_thread+0x0/0x27b
[  141.675593]  [<ffffffff8105a146>] kthread+0x7d/0x87
[  141.675707]  [<ffffffff81012daa>] child_rip+0xa/0x20
[  141.675817]  [<ffffffff81012710>] ? restore_args+0x0/0x30
[  141.675927]  [<ffffffff8105a0c9>] ? kthread+0x0/0x87
[  141.676035]  [<ffffffff81012da0>] ? child_rip+0x0/0x20
[  141.676142] Code: a4 c5 68 08 00 00 65 48 8b 04 25 00 e4 00 00 48 8b 04 18 49 8b 4c 24 78 48 85 
c9 74 5b 41 89 c7 48 98 48 8b 1c c1 48 85 db 74 4d <83> 3b 00 74 48 48 83 3d ff d4 65 00 00 75 04 0f 
0b eb fe fa 66
[  141.680610] RIP  [<ffffffff810b8a64>] cache_reap+0x71/0x236
[  141.680785]  RSP <ffff88027e81bdf0>
[  141.680886] CR2: 0000000000000078
[  141.681016] ---[ end trace b1e17069ef81fe83 ]--

Thanks.

-haicheng

Haicheng Li wrote:
> This is to fix the bug discussed in email thread: 
> http://patchwork.kernel.org/patch/69499/.
> 
> Currently node_possible_map won't include the offlined node that has 
> neither CPU onlined nor MEM onlined at booting time. As a result, 
> nr_node_ids won't be equal to possible nodes.
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> ---
>  arch/x86/mm/srat_64.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> index a271241..a5bc297 100644
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -238,7 +238,7 @@ update_nodes_add(int node, unsigned long start, 
> unsigned long end)
>  void __init
>  acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>  {
> -    struct bootnode *nd, oldnode;
> +    struct bootnode *nd;
>      unsigned long start, end;
>      int node, pxm;
>      int i;
> @@ -277,7 +277,6 @@ acpi_numa_memory_affinity_init(struct 
> acpi_srat_mem_affinity *ma)
>          return;
>      }
>      nd = &nodes[node];
> -    oldnode = *nd;
>      if (!node_test_and_set(node, nodes_parsed)) {
>          nd->start = start;
>          nd->end = end;
> @@ -291,13 +290,8 @@ acpi_numa_memory_affinity_init(struct 
> acpi_srat_mem_affinity *ma)
>      printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
>             start, end);
> 
> -    if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
> +    if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)
>          update_nodes_add(node, start, end);
> -        /* restore nodes[node] */
> -        *nd = oldnode;
> -        if ((nd->start | nd->end) == 0)
> -            node_clear(node, nodes_parsed);
> -    }
> 
>      node_memblk_range[num_node_memblks].start = start;
>      node_memblk_range[num_node_memblks].end = end;
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
