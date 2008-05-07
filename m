Return-Path: <linux-kernel-owner+w=401wt.eu-S1762325AbYEGG40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325AbYEGG40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbYEGG4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:56:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754687AbYEGG4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:56:13 -0400
Date: Tue, 6 May 2008 23:55:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: thomas@m3y3r.de
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: BUG: unable to handle kernel paging request
Message-Id: <20080506235548.5bca4f9d.akpm@linux-foundation.org>
In-Reply-To: <1210026783.481f8b2003c1c@213.133.104.17>
References: <1210026783.481f8b2003c1c@213.133.104.17>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 00:33:04 +0200 thomas@m3y3r.de wrote:

> See also attached config and dmesg:
> 
> 
> [  706.684483] BUG: unable to handle kernel paging request at fa4213d8
> [  706.684488] IP: [<f8b9e4f3>] :oprofile:alloc_cpu_buffers+0x39/0xce
> [  706.684496] *pde = 00000000 
> [  706.684500] Oops: 0002 [#1] SMP 
> [  706.684502] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/irq
> [  706.684505] Modules linked in: oprofile cpufreq_stats rfcomm l2cap bluetooth
> autofs4 fuse sunrpc nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state
> nf_conntrack ipt_REJECT iptable_filter ip_tables xt_tcpudp ip6t_REJECT
> ip6table_filter ip6_tables x_tables cpufreq_ondemand dm_crypt ext2 dm_mirror
> dm_log dm_multipath scsi_dh dm_mod ipv6 snd_hda_intel snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss forcedeth
> snd_pcm snd_timer snd_page_alloc snd_hwdep pcspkr k8temp snd soundcore button
> i2c_nforce2 i2c_core mtd chipreg map_funcs serio_raw hwmon sg pata_amd
> pata_acpi ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd
> ehci_hcd [last unloaded: scsi_wait_scan]
> [  706.684537] 
> [  706.684539] Pid: 7857, comm: oprofiled Not tainted (2.6.26-rc1-next-20080505
> #21)
> [  706.684542] EIP: 0060:[<f8b9e4f3>] EFLAGS: 00210286 CPU: 0
> [  706.684547] EIP is at alloc_cpu_buffers+0x39/0xce [oprofile]
> [  706.684550] EAX: f8ba6000 EBX: fa4213c0 ECX: f8b9e4f1 EDX: 00000000
> [  706.684552] ESI: 00000000 EDI: 00002000 EBP: 00010000 ESP: f45cfe98
> [  706.684554]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  706.684556] Process oprofiled (pid: 7857, ti=f45cf000 task=f6314f00
> task.ti=f45cf000)
> [  706.684558] Stack: ffffffea f6228180 00000000 f8b9ec99 f8b9e119 ffffffea
> f6228180 f8b9ecd2 
> [  706.684563]        f6228180 f3363988 c047f42d f453cd80 f29cf3b8 f45cff14
> f6228180 f45cff14 
> [  706.684568]        00000001 c047f543 f6228180 00000000 00000000 f45cff14
> c0489f07 00000000 
> [  706.684572] Call Trace:
> [  706.684575]  [<f8b9ec99>] event_buffer_open+0x0/0x55 [oprofile]
> [  706.684582]  [<f8b9e119>] oprofile_setup+0x11/0x84 [oprofile]
> [  706.684588]  [<f8b9ecd2>] event_buffer_open+0x39/0x55 [oprofile]
> [  706.684595]  [<c047f42d>] __dentry_open+0x118/0x212
> [  706.684602]  [<c047f543>] nameidata_to_filp+0x1c/0x2c
> [  706.684607]  [<c0489f07>] do_filp_open+0x35a/0x6c3
> [  706.684612]  [<c041bcf8>] kunmap_atomic+0x67/0x87
> [  706.684617]  [<c046e520>] handle_mm_fault+0x6e7/0x6f8
> [  706.684621]  [<c0470e14>] mmap_region+0x2de/0x394
> [  706.684633]  [<c047f23f>] do_sys_open+0x40/0xb0
> [  706.684638]  [<c047f2f3>] sys_open+0x1e/0x23
> [  706.684643]  [<c0404a92>] syscall_call+0x7/0xb
> [  706.684653]  =======================
> [  706.684654] Code: 8d 2c fd 00 00 00 00 53 e8 f8 28 95 c7 89 c6 e9 8d 00 00
> 00
> bb c0 43 ba f8 31 d2 89 e8 03 1c b5 c0 5e 74 c0 e8 d2 56 8d c7 85 c0 <89> 43 18
> 74 7e 8d 43 34 c7 43 04 00 00 00 00 89 73 2c c7 43 0c 
> [  706.684677] EIP: [<f8b9e4f3>] alloc_cpu_buffers+0x39/0xce [oprofile] SS:ESP
> 0068:f45cfe98
> [  706.684684] ---[ end trace 4f359ae625277917 ]---

hrm.  This:

commit 608dfddd845da5ab6accef70154c8910529699f7
Author: Mike Travis <travis@sgi.com>
Date:   Mon Apr 28 02:14:15 2008 -0700

    oprofile: change cpu_buffer from array to per_cpu variable
    
    Change cpu_buffer from array to per_cpu variable in oprofile functions.
    

has to be a prime suspect.  But why?

oprofile works OK here.

Does this revert patch fix it for you?

 drivers/oprofile/buffer_sync.c    |    2 +-
 drivers/oprofile/cpu_buffer.c     |   16 ++++++++--------
 drivers/oprofile/cpu_buffer.h     |    3 +--
 drivers/oprofile/oprofile_stats.c |    4 ++--
 4 files changed, 12 insertions(+), 13 deletions(-)

diff -puN drivers/oprofile/buffer_sync.c~revert-1 drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~revert-1
+++ a/drivers/oprofile/buffer_sync.c
@@ -491,7 +491,7 @@ typedef enum {
  */
 void sync_buffer(int cpu)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[cpu];
 	struct mm_struct *mm = NULL;
 	struct task_struct * new;
 	unsigned long cookie = 0;
diff -puN drivers/oprofile/cpu_buffer.c~revert-1 drivers/oprofile/cpu_buffer.c
--- a/drivers/oprofile/cpu_buffer.c~revert-1
+++ a/drivers/oprofile/cpu_buffer.c
@@ -27,7 +27,7 @@
 #include "buffer_sync.h"
 #include "oprof.h"
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct oprofile_cpu_buffer, cpu_buffer);
+struct oprofile_cpu_buffer cpu_buffer[NR_CPUS] __cacheline_aligned;
 
 static void wq_sync_buffer(struct work_struct *work);
 
@@ -39,7 +39,7 @@ void free_cpu_buffers(void)
 	int i;
  
 	for_each_online_cpu(i)
-		vfree(per_cpu(cpu_buffer, i).buffer);
+		vfree(cpu_buffer[i].buffer);
 }
 
 int alloc_cpu_buffers(void)
@@ -49,7 +49,7 @@ int alloc_cpu_buffers(void)
 	unsigned long buffer_size = fs_cpu_buffer_size;
  
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer * b = &cpu_buffer[i];
  
 		b->buffer = vmalloc_node(sizeof(struct op_sample) * buffer_size,
 			cpu_to_node(i));
@@ -83,7 +83,7 @@ void start_cpu_work(void)
 	work_enabled = 1;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer * b = &cpu_buffer[i];
 
 		/*
 		 * Spread the work by 1 jiffy per cpu so they dont all
@@ -100,7 +100,7 @@ void end_cpu_work(void)
 	work_enabled = 0;
 
 	for_each_online_cpu(i) {
-		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
+		struct oprofile_cpu_buffer * b = &cpu_buffer[i];
 
 		cancel_delayed_work(&b->work);
 	}
@@ -227,7 +227,7 @@ static void oprofile_end_trace(struct op
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 				unsigned long event, int is_kernel)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
 
 	if (!backtrace_depth) {
 		log_sample(cpu_buf, pc, is_kernel, event);
@@ -254,13 +254,13 @@ void oprofile_add_sample(struct pt_regs 
 
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
 	log_sample(cpu_buf, pc, is_kernel, event);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
+	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[smp_processor_id()];
 
 	if (!cpu_buf->tracing)
 		return;
diff -puN drivers/oprofile/cpu_buffer.h~revert-1 drivers/oprofile/cpu_buffer.h
--- a/drivers/oprofile/cpu_buffer.h~revert-1
+++ a/drivers/oprofile/cpu_buffer.h
@@ -14,7 +14,6 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/cache.h>
-#include <linux/sched.h>
  
 struct task_struct;
  
@@ -48,7 +47,7 @@ struct oprofile_cpu_buffer {
 	struct delayed_work work;
 } ____cacheline_aligned;
 
-DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
+extern struct oprofile_cpu_buffer cpu_buffer[];
 
 void cpu_buffer_reset(struct oprofile_cpu_buffer * cpu_buf);
 
diff -puN drivers/oprofile/oprofile_stats.c~revert-1 drivers/oprofile/oprofile_stats.c
--- a/drivers/oprofile/oprofile_stats.c~revert-1
+++ a/drivers/oprofile/oprofile_stats.c
@@ -23,7 +23,7 @@ void oprofile_reset_stats(void)
 	int i;
  
 	for_each_possible_cpu(i) {
-		cpu_buf = &per_cpu(cpu_buffer, i);
+		cpu_buf = &cpu_buffer[i]; 
 		cpu_buf->sample_received = 0;
 		cpu_buf->sample_lost_overflow = 0;
 		cpu_buf->backtrace_aborted = 0;
@@ -49,7 +49,7 @@ void oprofile_create_stats_files(struct 
 		return;
 
 	for_each_possible_cpu(i) {
-		cpu_buf = &per_cpu(cpu_buffer, i);
+		cpu_buf = &cpu_buffer[i]; 
 		snprintf(buf, 10, "cpu%d", i);
 		cpudir = oprofilefs_mkdir(sb, dir, buf);
  
_


