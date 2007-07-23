Return-Path: <linux-kernel-owner+w=401wt.eu-S1765387AbXGWRSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765387AbXGWRSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbXGWRS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:18:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:56736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994AbXGWRS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:18:28 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Mel Gorman <mel@skynet.ie>
Subject: Re: Linus 2.6.23-rc1: ACPI-related oops on x86_64
Date: Mon, 23 Jul 2007 13:15:28 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, davej@redhat.com,
       jhoblitt@ifa.hawaii.edu, auke-jan.h.kok@intel.com,
       linux-acpi@vger.kernel.org
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723095024.GA19437@skynet.ie>
In-Reply-To: <20070723095024.GA19437@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707231315.28838.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 05:50, Mel Gorman wrote:

> This was seen on a machine on test.kernel.org;
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000000
> RIP: 
>  [<ffffffff8037379b>] acpi_processor_throttling_seq_show+0xa7/0xd6
> PGD 3bd9e067 PUD 3bc6a067 PMD 0 
> Oops: 0000 [1] SMP 
> CPU 3 
> Modules linked in: video output button battery floppy ac lp parport_pc
> parport nvram amd_rng rng_core i2c_amd756 i2c_core
> Pid: 1522, comm: head Not tainted 2.6.23-rc1-autokern1 #1
> RIP: 0010:[<ffffffff8037379b>]  [<ffffffff8037379b>]
> acpi_processor_throttling_seq_show+0xa7/0xd6
> RSP: 0018:ffff81003c4a5e48  EFLAGS: 00010246
> RAX: 0000000000000020 RBX: ffff810037ea1800 RCX: 0000000000000000
> RDX: 000000000000002a RSI: ffffffff80599c02 RDI: ffff810037c6a9c0
> RBP: ffff810037c6a9c0 R08: ffff81003c3e3051 R09: ffff810037c6a9c0
> R10: ffffffffffffffff R11: ffffffff80373e66 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 00007fffd59dcd40
> FS:  00002b7ad50e36f0(0000) GS:ffff81003ee56b40(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000003bd9b000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process head (pid: 1522, threadinfo ffff81003c4a4000, task ffff81003ee81040)
> Stack:  ffff81003eed7180 ffff810037c6a9c0 0000000000000001 0000000000000001
>  0000000000002000 ffffffff802a77b3 ffff81003c4a5f50 ffff81003e2f8ec0
>  ffff810037c6a9f0 ffff81003de65000 0000000000000000 fffffffffffffffb
> Call Trace:
>  [<ffffffff802a77b3>] seq_read+0x105/0x28e
>  [<ffffffff802a76ae>] seq_read+0x0/0x28e
>  [<ffffffff802c8501>] proc_reg_read+0x80/0x9a
>  [<ffffffff8028eb3d>] vfs_read+0xcb/0x153
>  [<ffffffff8028eed9>] sys_read+0x45/0x6e
>  [<ffffffff8020bc6e>] system_call+0x7e/0x83
> FATAL: Error inserting acpi_cpufreq
> (/lib/modules/2.6.23-rc1-autokern1/kernel/arch/x86_64/kernel/cpufreq/acpi-cpufreq.ko):
> No such device
> 
> Full oops is at http://test.kernel.org/abat/100837/debug/console.log
> Config file at http://test.kernel.org/abat/100837/build/dotconfig

try this,
thanks,
-Len

Subject: fix oops due to typo in new throttling code
From: Luming Yu <luming.yu@gmail.com>


Signed-off-by: Luming Yu <luming.yu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>

---

 drivers/acpi/processor_throttling.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

Index: linus/drivers/acpi/processor_throttling.c
===================================================================
--- linus.orig/drivers/acpi/processor_throttling.c
+++ linus/drivers/acpi/processor_throttling.c
@@ -658,18 +658,20 @@ static int acpi_processor_throttling_seq
 		   pr->throttling.state_count - 1);
 
 	seq_puts(seq, "states:\n");
-	if (acpi_processor_get_throttling == acpi_processor_get_throttling_fadt)
+	if (pr->throttling.acpi_processor_get_throttling ==
+			acpi_processor_get_throttling_fadt) {
 		for (i = 0; i < pr->throttling.state_count; i++)
 			seq_printf(seq, "   %cT%d:                  %02d%%\n",
 				   (i == pr->throttling.state ? '*' : ' '), i,
 				   (pr->throttling.states[i].performance ? pr->
 				    throttling.states[i].performance / 10 : 0));
-	else
+	} else {
 		for (i = 0; i < pr->throttling.state_count; i++)
 			seq_printf(seq, "   %cT%d:                  %02d%%\n",
 				   (i == pr->throttling.state ? '*' : ' '), i,
 				   (int)pr->throttling.states_tss[i].
 				   freqpercentage);
+	}
 
       end:
 	return 0;
