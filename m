Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112Ab0AVEGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0AVEGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640Ab0AVEGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:06:21 -0500
Received: from mga10.intel.com ([192.55.52.92]:14071 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752560Ab0AVEGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:06:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,321,1262592000"; 
   d="scan'208";a="766350077"
Message-ID: <4B592437.9060508@linux.intel.com>
Date: Fri, 22 Jan 2010 12:06:15 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/mm/srat_64.c: make node_possible_map include hotpluggable
 node
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com> <4B57C2DD.3050402@linux.intel.com> <alpine.DEB.2.00.1001202252320.22343@chino.kir.corp.google.com> <4B5802EF.6040603@linux.intel.com> <alpine.DEB.2.00.1001202344580.29982@chino.kir.corp.google.com> <4B581160.2090209@linux.intel.com> <alpine.DEB.2.00.1001211500290.31073@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001211500290.31073@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
 > You've already tested my patch that this thread was restarted with and it
 > works, so let's fix the bug.  Then, later, you can rename cpu_nodes_parsed
 > to no_mems_nodes, which I'd agree with.  You may even try to seperate the
 > hotpluggable nodes out into their own nodemask, but I trust that the x86
 > maintainers will be looking for some rationale behind that other than "it
 > may one day be useful."

David, you are misleading people to fix the BUG with a logically problematic patch. I don't want 
such fixing to possibly bother other people someday, please let's avoid it in review stage.

 > getting _very_ late in the 2.6.33 release cycle.  Do you expect Ingo to
 > push your fix to Linus with the rationale that "maybe someday we'll use
 > this new nodemask even though it may be rc5 and nobody knows what we'd
 > ever use it for"?  Is that appropriate for -stable candidates as well?

Don't speak for any other people. Let maintainers themselves decide if my patch is ugly or 
acceptable. I don't want to argue with you anymore if you cannot find any true problem from my 
recent patch.

Below is my updated patch (in fact, it's v2 for the patch I sent out for review in 
http://lkml.org/lkml/2010/1/15/9).

***

This is to fix the outstanding BUG I ever reported in email thread: 
http://patchwork.kernel.org/patch/69499/.
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

Existing code doesn't record hotpluggable nodes parsed from SRAT because such nodes have neither CPU 
online (in cpu_nodes_parsed) nor MEM online (in nodes_parsed) at booting time. As a result, 
node_possible_map won't include hotpluggable nodes and then nr_node_ids won't be equal to maximum of 
the possible nodes on the system.

To fix it, naturally we add nodemask_t hp_nodes_parsed to record nodes with hotpluggable memory 
region, corresponding region data is kept in existing struct bootnode nodes_add[]; finally we union 
hp_nodes_parsed together with cpu_nodes_parsed and nodes_parsed to get correct node_possible_map, 
which then includes all possible nodes:
  - nodes with memory on
  - nodes with cpu on
  - nodes with hotpluggable memory region

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
  arch/x86/mm/srat_64.c |    9 +++++++--
  1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index dbb5381..595b14d 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -29,6 +29,7 @@ static struct acpi_table_slit *acpi_slit;

  static nodemask_t nodes_parsed __initdata;
  static nodemask_t cpu_nodes_parsed __initdata;
+static nodemask_t hp_nodes_parsed __initdata;
  static struct bootnode nodes[MAX_NUMNODES] __initdata;
  static struct bootnode nodes_add[MAX_NUMNODES];

@@ -229,9 +230,11 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
  			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
  	}

-	if (changed)
+	if (changed) {
+		node_set(node, hp_nodes_parsed);
  		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
  				 nd->start, nd->end);
+	}
  }

  /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
@@ -364,8 +367,10 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
  		return -1;
  	}

-	/* Account for nodes with cpus and no memory */
+	/* Account for nodes with either memory or cpus online */
  	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
+	/* Account for nodes with hotpluggable memory region */
+	nodes_or(node_possible_map, node_possible_map, hp_nodes_parsed);

  	/* Finally register nodes */
  	for_each_node_mask(i, node_possible_map)
-- 
1.5.3.8

