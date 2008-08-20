Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbYHTN7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbYHTN7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYHTN7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:59:44 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:58361 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYHTN7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:59:42 -0400
X-BigFish: VPS-5(z1039oz1432R1805M936fQ3b5bk4cd6kzz10d3izz5a6ciz32i6bh45k64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K5WK70-01-9IG-01
Message-ID: <48AC2340.5010204@amd.com>
Date: Wed, 20 Aug 2008 15:59:28 +0200
From: Peter Oruba <peter.oruba@amd.com>
Organization: AMD (OSRC)
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Max Krasnyansky <maxk@qualcomm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: BUG: [2/2 -tip] x86-microcode: generic interface refactoring
References: <1219184546.10426.41.camel@earth>
In-Reply-To: <1219184546.10426.41.camel@earth>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2008 13:59:28.0641 (UTC) FILETIME=[F6596F10:01C902CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With latest tip-microcode I get the following:

Aug 23 13:38:26 gai_nfs ------------[ cut here ]------------
Aug 23 13:38:26 gai_nfs kernel BUG at arch/x86/kernel/microcode.c:351!
Aug 23 13:38:26 gai_nfs invalid opcode: 0000 [1] SMP
Aug 23 13:38:26 gai_nfs CPU 0
Aug 23 13:38:26 gai_nfs Modules linked in: microcode_amd microcode
Aug 23 13:38:26 gai_nfs Pid: 4258, comm: bash Not tainted 2.6.27-rc1 #10
Aug 23 13:38:26 gai_nfs RIP: 0010:[<ffffffffa000048e>]  [<ffffffffa000048e>] 
microcode_update_cpu+0x1b/0xf1 [microcode]
Aug 23 13:38:26 gai_nfs RSP: 0018:ffff88003ed41db8  EFLAGS: 00010297
Aug 23 13:38:26 gai_nfs RAX: 0000000000000000 RBX: 0000000000000001 RCX: 
00000000c0000100
Aug 23 13:38:26 gai_nfs RDX: 0000000000000000 RSI: ffff88003f87cbf0 RDI: 
0000000000000001
Aug 23 13:38:26 gai_nfs RBP: 0000000000000001 R08: 0000000000000000 R09: 
ffff880001011ae0
Aug 23 13:38:26 gai_nfs R10: 000000009f3b7578 R11: ffff88003f887de0 R12: 
0000000000000000
Aug 23 13:38:26 gai_nfs R13: 0000000000000001 R14: 0000000000000002 R15: 
ffffffff80739d00
Aug 23 13:38:26 gai_nfs FS:  00007f0e312d26d0(0000) GS:ffffffff807b2a80(0000) 
knlGS:0000000000000000
Aug 23 13:38:26 gai_nfs CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 23 13:38:26 gai_nfs CR2: 00007f0f13293f20 CR3: 000000003e412000 CR4: 
00000000000006a0
Aug 23 13:38:26 gai_nfs DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
Aug 23 13:38:26 gai_nfs DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
Aug 23 13:38:26 gai_nfs Process bash (pid: 4258, threadinfo ffff88003ed40000, 
task ffff88003f3e5950)
Aug 23 13:38:26 gai_nfs Stack:  ffff88000101c980 0000000000000296 
0000000000000003 0000000000000001
Aug 23 13:38:26 gai_nfs 0000000000000001 0000000000000001 0000000000000001 
ffffffffa00005ac
Aug 23 13:38:26 gai_nfs 0000000000000003 0000000000000001 0000000000000282 
0000000000000002
Aug 23 13:38:26 gai_nfs Call Trace:
Aug 23 13:38:26 gai_nfs [<ffffffffa00005ac>] ? microcode_init_cpu+0x48/0x61 
[microcode]
Aug 23 13:38:26 gai_nfs [<ffffffffa00006a7>] ? mc_cpu_callback+0x2b/0x76 [microcode]
Aug 23 13:38:26 gai_nfs [<ffffffff80242ffd>] ? notifier_call_chain+0x29/0x4c
Aug 23 13:38:26 gai_nfs [<ffffffff805ca600>] ? cpu_up+0x105/0x16a
Aug 23 13:38:26 gai_nfs [<ffffffff805a99d7>] ? store_online+0x46/0x6d
Aug 23 13:38:26 gai_nfs [<ffffffff802c431a>] ? sysfs_write_file+0xd0/0x107
Aug 23 13:38:26 gai_nfs [<ffffffff80282b8c>] ? vfs_write+0xad/0x136
Aug 23 13:38:26 gai_nfs [<ffffffff80282cd1>] ? sys_write+0x45/0x6e
Aug 23 13:38:26 gai_nfs [<ffffffff8020be8b>] ? system_call_fastpath+0x16/0x1b
Aug 23 13:38:26 gai_nfs
Aug 23 13:38:26 gai_nfs
Aug 23 13:38:26 gai_nfs Code: ff ff 48 89 05 ac 2f 00 00 76 83 e9 6a ff ff ff 41 
55 41 89 fd 41 54 55 53 48 83 ec 18 65 44
8b 24 25 24 00 00 00 41 39 fc 74 04 <0f> 0b eb fe 49 63 c4 48 c7 c7 d0 1d 00 a0 
48 6b d8 18 e8 72 c4
Aug 23 13:38:26 gai_nfs RIP  [<ffffffffa000048e>] microcode_update_cpu+0x1b/0xf1 
[microcode]
Aug 23 13:38:26 gai_nfs RSP <ffff88003ed41db8>
Aug 23 13:38:26 gai_nfs ---[ end trace bb8928b4378d8212 ]---

Dmitry Adamushko schrieb:
> 
> [ Note, I've only done some basic testing. Anyone with ucode firmware files is very welcome to give this code a try
> and blame me for any relevant crashes. ]
> 
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> Subject: x86-microcode: generic interface refactoring
> 
> 
> This is the 1st patch is series. Here the aim was to avoid any significant changes,
> logically-wise.
> 
> So it's mainly about generic interface refactoring: e.g. make
> microcode_{intel,amd}.c
> more about arch-specific details and less about policies like
> make-sure-we-run-on-a-target-cpu
> (no more set_cpus_allowed_ptr() here) and generic synchronization (no
> more microcode_mutex here).
> 
> All in all, more line have been deleted than added.
> 
> 4 files changed, 145 insertions(+), 198 deletions(-)
> 
> ---
> 
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> 
> diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
> index ad136ad..b2f84ce 100644
> --- a/arch/x86/kernel/microcode.c
> +++ b/arch/x86/kernel/microcode.c
> @@ -71,7 +71,7 @@
>   *		Thanks to Stuart Swales for pointing out this bug.
>   */
>  
> -/*#define DEBUG pr_debug */
> +/* #define DEBUG pr_debug */
>  #include <linux/capability.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> @@ -104,8 +104,7 @@ MODULE_LICENSE("GPL");
>  struct microcode_ops *microcode_ops;
>  
>  /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
> -DEFINE_MUTEX(microcode_mutex);
> -EXPORT_SYMBOL_GPL(microcode_mutex);
> +static DEFINE_MUTEX(microcode_mutex);
>  
>  struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
>  EXPORT_SYMBOL_GPL(ucode_cpu_info);
> @@ -234,22 +233,6 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
>  struct platform_device *microcode_pdev;
>  EXPORT_SYMBOL_GPL(microcode_pdev);
>  
> -static void microcode_init_cpu(int cpu, int resume)
> -{
> -	cpumask_t old;
> -	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> -
> -	old = current->cpus_allowed;
> -
> -	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
> -	mutex_lock(&microcode_mutex);
> -	microcode_ops->collect_cpu_info(cpu);
> -	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
> -		microcode_ops->cpu_request_microcode(cpu);
> -	mutex_unlock(&microcode_mutex);
> -	set_cpus_allowed_ptr(current, &old);
> -}
> -
>  static ssize_t reload_store(struct sys_device *dev,
>  			    struct sysdev_attribute *attr,
>  			    const char *buf, size_t sz)
> @@ -266,14 +249,15 @@ static ssize_t reload_store(struct sys_device
> *dev,
>  		cpumask_t old = current->cpus_allowed;
>  
>  		get_online_cpus();
> -		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
> -
> -		mutex_lock(&microcode_mutex);
> -		if (uci->valid)
> -			err = microcode_ops->cpu_request_microcode(cpu);
> -		mutex_unlock(&microcode_mutex);
> +		if (cpu_online(cpu)) {
> +			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
> +			mutex_lock(&microcode_mutex);
> +			if (uci->valid)
> +				err = microcode_ops->cpu_request_microcode(cpu);
> +			mutex_unlock(&microcode_mutex);
> +			set_cpus_allowed_ptr(current, &old);
> +		}
>  		put_online_cpus();
> -		set_cpus_allowed_ptr(current, &old);
>  	}
>  	if (err)
>  		return err;
> @@ -285,7 +269,7 @@ static ssize_t version_show(struct sys_device *dev,
>  {
>  	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
>  
> -	return sprintf(buf, "0x%x\n", uci->rev);
> +	return sprintf(buf, "0x%x\n", uci->cpu_sig.rev);
>  }
>  
>  static ssize_t pf_show(struct sys_device *dev,
> @@ -293,7 +277,7 @@ static ssize_t pf_show(struct sys_device *dev,
>  {
>  	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
>  
> -	return sprintf(buf, "0x%x\n", uci->pf);
> +	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
>  }
>  
>  static SYSDEV_ATTR(reload, 0200, NULL, reload_store);
> @@ -312,7 +296,85 @@ static struct attribute_group mc_attr_group = {
>  	.name = "microcode",
>  };
>  
> -static int __mc_sysdev_add(struct sys_device *sys_dev, int resume)
> +static void microcode_fini_cpu(int cpu)
> +{
> +	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> +
> +	mutex_lock(&microcode_mutex);
> +	microcode_ops->microcode_fini_cpu(cpu);
> +	uci->valid = 0;
> +	mutex_unlock(&microcode_mutex);
> +}
> +
> +static void collect_cpu_info(int cpu)
> +{
> +	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> +
> +	memset(uci, 0, sizeof(*uci));
> +	if (!microcode_ops->collect_cpu_info(cpu, &uci->cpu_sig))
> +		uci->valid = 1;
> +}
> +
> +static void microcode_resume_cpu(int cpu)
> +{
> +	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> +	struct cpu_signature nsig;
> +
> +	pr_debug("microcode: CPU%d resumed\n", cpu);
> +
> +	if (!uci->mc.valid_mc)
> +		return;
> +
> +	/*
> +	 * Let's verify that the 'cached' ucode does belong
> +	 * to this cpu (a bit of paranoia):
> +	 */
> +	if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
> +		microcode_fini_cpu(cpu);
> +		return;
> +	}
> +
> +	if (memcmp(&nsig, &uci->cpu_sig, sizeof(nsig))) {
> +		microcode_fini_cpu(cpu);
> +		/* Should we look for a new ucode here? */
> +		return;
> +	}
> +
> +	microcode_ops->apply_microcode(cpu);
> +}
> +
> +void microcode_update_cpu(int cpu)
> +{
> +	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> +
> +	/* We should bind the task to the CPU */
> +	BUG_ON(raw_smp_processor_id() != cpu);
> +
> +	mutex_lock(&microcode_mutex);
> +	/*
> +	 * Check if the system resume is in progress (uci->valid != NULL),
> +	 * otherwise just request a firmware:
> +	 */
> +	if (uci->valid) {
> +		microcode_resume_cpu(cpu);
> +	} else {	
> +		collect_cpu_info(cpu);
> +		if (uci->valid && system_state == SYSTEM_RUNNING)
> +			microcode_ops->cpu_request_microcode(cpu);
> +	}
> +	mutex_unlock(&microcode_mutex);
> +}
> +
> +static void microcode_init_cpu(int cpu)
> +{
> +	cpumask_t old = current->cpus_allowed;
> +
> +	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
> +	microcode_update_cpu(cpu);
> +	set_cpus_allowed_ptr(current, &old);
> +}
> +
> +static int mc_sysdev_add(struct sys_device *sys_dev)
>  {
>  	int err, cpu = sys_dev->id;
>  	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> @@ -327,16 +389,10 @@ static int __mc_sysdev_add(struct sys_device
> *sys_dev, int resume)
>  	if (err)
>  		return err;
>  
> -	microcode_init_cpu(cpu, resume);
> -
> +	microcode_init_cpu(cpu);
>  	return 0;
>  }
>  
> -static int mc_sysdev_add(struct sys_device *sys_dev)
> -{
> -	return __mc_sysdev_add(sys_dev, 0);
> -}
> -
>  static int mc_sysdev_remove(struct sys_device *sys_dev)
>  {
>  	int cpu = sys_dev->id;
> @@ -345,7 +401,7 @@ static int mc_sysdev_remove(struct sys_device
> *sys_dev)
>  		return 0;
>  
>  	pr_debug("microcode: CPU%d removed\n", cpu);
> -	microcode_ops->microcode_fini_cpu(cpu);
> +	microcode_fini_cpu(cpu);
>  	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
>  	return 0;
>  }
> @@ -376,33 +432,26 @@ mc_cpu_callback(struct notifier_block *nb,
> unsigned long action, void *hcpu)
>  
>  	sys_dev = get_cpu_sysdev(cpu);
>  	switch (action) {
> -	case CPU_UP_CANCELED_FROZEN:
> -		/* The CPU refused to come up during a system resume */
> -		microcode_ops->microcode_fini_cpu(cpu);
> -		break;
>  	case CPU_ONLINE:
> -	case CPU_DOWN_FAILED:
> -		mc_sysdev_add(sys_dev);
> -		break;
>  	case CPU_ONLINE_FROZEN:
> -		/* System-wide resume is in progress, try to apply microcode */
> -		if (microcode_ops->apply_microcode_check_cpu(cpu)) {
> -			/* The application of microcode failed */
> -			microcode_ops->microcode_fini_cpu(cpu);
> -			__mc_sysdev_add(sys_dev, 1);
> -			break;
> -		}
> +		microcode_init_cpu(cpu);
> +	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
> +		pr_debug("microcode: CPU%d added\n", cpu);
>  		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
>  			printk(KERN_ERR "microcode: Failed to create the sysfs "
>  				"group for CPU%d\n", cpu);
>  		break;
>  	case CPU_DOWN_PREPARE:
> -		mc_sysdev_remove(sys_dev);
> -		break;
>  	case CPU_DOWN_PREPARE_FROZEN:
>  		/* Suspend is in progress, only remove the interface */
>  		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
> +		pr_debug("microcode: CPU%d removed\n", cpu);
> +		break;
> +	case CPU_DEAD:
> +	case CPU_UP_CANCELED_FROZEN:
> +		/* The CPU refused to come up during a system resume */
> +		microcode_fini_cpu(cpu);
>  		break;
>  	}
>  	return NOTIFY_OK;
> diff --git a/arch/x86/kernel/microcode_amd.c
> b/arch/x86/kernel/microcode_amd.c
> index a6e76cc..4006e5e 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -59,38 +59,28 @@ MODULE_LICENSE("GPL v2");
>  /* serialize access to the physical write */
>  static DEFINE_SPINLOCK(microcode_update_lock);
>  
> -/* no concurrent ->write()s are allowed on /dev/cpu/microcode */
> -extern struct mutex (microcode_mutex);
> -
>  struct equiv_cpu_entry *equiv_cpu_table;
>  
> -extern struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
> -
> -static void collect_cpu_info_amd(int cpu)
> +static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> -	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>  
> -	/* We should bind the task to the CPU */
> -	BUG_ON(raw_smp_processor_id() != cpu);
> -	uci->rev = 0;
> -	uci->pf = 0;
> -	uci->mc.mc_amd = NULL;
> -	uci->valid = 1;
> +	memset(csig, 0, sizeof(*csig));
>  
>  	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
>  		printk(KERN_ERR "microcode: CPU%d not a capable AMD processor\n",
>  		       cpu);
> -		uci->valid = 0;
> -		return;
> +		return -1;
>  	}
>  
>  	asm volatile("movl %1, %%ecx; rdmsr"
> -		     : "=a" (uci->rev)
> +		     : "=a" (csig->rev)
>  		     : "i" (0x0000008B) : "ecx");
>  
>  	printk(KERN_INFO "microcode: collect_cpu_info_amd : patch_id=0x%x\n",
> -	       uci->rev);
> +		csig->rev);
> +
> +	return 0;
>  }
>  
>  static int get_matching_microcode_amd(void *mc, int cpu)
> @@ -119,7 +109,7 @@ static int get_matching_microcode_amd(void *mc, int
> cpu)
>  	if (equiv_cpu_table == NULL) {
>  		printk(KERN_INFO "microcode: CPU%d microcode update with "
>  		       "version 0x%x (current=0x%x)\n",
> -		       cpu, mc_header->patch_id, uci->rev);
> +		       cpu, mc_header->patch_id, uci->cpu_sig.rev);
>  		goto out;
>  	}
>  
> @@ -185,12 +175,12 @@ static int get_matching_microcode_amd(void *mc,
> int cpu)
>  		pci_dev_put(sb_pci_dev);
>  	}
>  
> -	if (mc_header->patch_id <= uci->rev)
> +	if (mc_header->patch_id <= uci->cpu_sig.rev)
>  		return 0;
>  
>  	printk(KERN_INFO "microcode: CPU%d found a matching microcode "
>  	       "update with version 0x%x (current=0x%x)\n",
> -	       cpu, mc_header->patch_id, uci->rev);
> +	       cpu, mc_header->patch_id, uci->cpu_sig.rev);
>  
>  out:
>  	new_mc = vmalloc(UCODE_MAX_SIZE);
> @@ -250,9 +240,9 @@ static void apply_microcode_amd(int cpu)
>  
>  	printk(KERN_INFO "microcode: CPU%d updated from revision "
>  	       "0x%x to 0x%x \n",
> -	       cpu_num, uci->rev, uci->mc.mc_amd->hdr.patch_id);
> +	       cpu_num, uci->cpu_sig.rev, uci->mc.mc_amd->hdr.patch_id);
>  
> -	uci->rev = rev;
> +	uci->cpu_sig.rev = rev;
>  }
>  
>  #ifdef CONFIG_MICROCODE_OLD_INTERFACE
> @@ -437,61 +427,18 @@ static int cpu_request_microcode_amd(int cpu)
>  	return error;
>  }
>  
> -static int apply_microcode_check_cpu_amd(int cpu)
> -{
> -	struct cpuinfo_x86 *c = &cpu_data(cpu);
> -	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> -	unsigned int rev;
> -	cpumask_t old;
> -	int err = 0;
> -
> -	/* Check if the microcode is available */
> -	if (!uci->mc.mc_amd)
> -		return 0;
> -
> -	old = current->cpus_allowed;
> -	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
> -
> -	/* Check if the microcode we have in memory matches the CPU */
> -	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 16)
> -		err = -EINVAL;
> -
> -	if (!err) {
> -		asm volatile("movl %1, %%ecx; rdmsr"
> -		     : "=a" (rev)
> -		     : "i" (0x0000008B) : "ecx");
> -
> -		if (uci->rev != rev)
> -			err = -EINVAL;
> -	}
> -
> -	if (!err)
> -		apply_microcode_amd(cpu);
> -	else
> -		printk(KERN_ERR "microcode: Could not apply microcode to CPU%d:"
> -		       " rev=0x%x\n",
> -		       cpu,  uci->rev);
> -
> -	set_cpus_allowed(current, old);
> -	return err;
> -}
> -
>  static void microcode_fini_cpu_amd(int cpu)
>  {
>  	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>  
> -	mutex_lock(&microcode_mutex);
> -	uci->valid = 0;
>  	vfree(uci->mc.mc_amd);
>  	uci->mc.mc_amd = NULL;
> -	mutex_unlock(&microcode_mutex);
>  }
>  
>  static struct microcode_ops microcode_amd_ops = {
>  	.get_next_ucode                   = get_next_ucode_amd,
>  	.get_matching_microcode           = get_matching_microcode_amd,
>  	.microcode_sanity_check           = NULL,
> -	.apply_microcode_check_cpu        = apply_microcode_check_cpu_amd,
>  	.cpu_request_microcode            = cpu_request_microcode_amd,
>  	.collect_cpu_info                 = collect_cpu_info_amd,
>  	.apply_microcode                  = apply_microcode_amd,
> diff --git a/arch/x86/kernel/microcode_intel.c
> b/arch/x86/kernel/microcode_intel.c
> index 6dd8907..c9b5320 100644
> --- a/arch/x86/kernel/microcode_intel.c
> +++ b/arch/x86/kernel/microcode_intel.c
> @@ -122,46 +122,37 @@ MODULE_LICENSE("GPL");
>  /* serialize access to the physical write to MSR 0x79 */
>  static DEFINE_SPINLOCK(microcode_update_lock);
>  
> -/* no concurrent ->write()s are allowed on /dev/cpu/microcode */
> -extern struct mutex microcode_mutex;
> -
> -extern struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
> -
> -static void collect_cpu_info(int cpu_num)
> +static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
>  {
>  	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
> -	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
>  	unsigned int val[2];
>  
> -	/* We should bind the task to the CPU */
> -	BUG_ON(raw_smp_processor_id() != cpu_num);
> -	uci->pf = uci->rev = 0;
> -	uci->mc.mc_intel = NULL;
> -	uci->valid = 1;
> +	memset(csig, 0, sizeof(*csig));
>  
>  	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
>  	    cpu_has(c, X86_FEATURE_IA64)) {
>  		printk(KERN_ERR "microcode: CPU%d not a capable Intel "
>  			"processor\n", cpu_num);
> -		uci->valid = 0;
> -		return;
> +		return -1;
>  	}
>  
> -	uci->sig = cpuid_eax(0x00000001);
> +	csig->sig = cpuid_eax(0x00000001);
>  
>  	if ((c->x86_model >= 5) || (c->x86 > 6)) {
>  		/* get processor flags from MSR 0x17 */
>  		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
> -		uci->pf = 1 << ((val[1] >> 18) & 7);
> +		csig->pf = 1 << ((val[1] >> 18) & 7);
>  	}
>  
>  	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
>  	/* see notes above for revision 1.07.  Apparent chip bug */
>  	sync_core();
>  	/* get the current revision from MSR 0x8B */
> -	rdmsr(MSR_IA32_UCODE_REV, val[0], uci->rev);
> +	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
>  	pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x
> \n",
> -			uci->sig, uci->pf, uci->rev);
> +			csig->sig, csig->pf, csig->rev);
> +
> +	return 0;
>  }
>  
>  static inline int microcode_update_match(int cpu_num,
> @@ -169,8 +160,8 @@ static inline int microcode_update_match(int
> cpu_num,
>  {
>  	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
>  
> -	if (!sigmatch(sig, uci->sig, pf, uci->pf)
> -		|| mc_header->rev <= uci->rev)
> +	if (!sigmatch(sig, uci->cpu_sig.sig, pf, uci->cpu_sig.pf)
> +		|| mc_header->rev <= uci->cpu_sig.rev)
>  		return 0;
>  	return 1;
>  }
> @@ -289,7 +280,7 @@ static int get_matching_microcode(void *mc, int cpu)
>  find:
>  	pr_debug("microcode: CPU%d found a matching microcode update with"
>  		 " version 0x%x (current=0x%x)\n",
> -		 cpu, mc_header->rev, uci->rev);
> +		 cpu, mc_header->rev, uci->cpu_sig.rev);
>  	new_mc = vmalloc(total_size);
>  	if (!new_mc) {
>  		printk(KERN_ERR "microcode: error! Can not allocate memory\n");
> @@ -335,16 +326,16 @@ static void apply_microcode(int cpu)
>  	spin_unlock_irqrestore(&microcode_update_lock, flags);
>  	if (val[1] != uci->mc.mc_intel->hdr.rev) {
>  		printk(KERN_ERR "microcode: CPU%d update from revision "
> -			"0x%x to 0x%x failed\n", cpu_num, uci->rev, val[1]);
> +			"0x%x to 0x%x failed\n", cpu_num, uci->cpu_sig.rev, val[1]);
>  		return;
>  	}
>  	printk(KERN_INFO "microcode: CPU%d updated from revision "
>  	       "0x%x to 0x%x, date = %04x-%02x-%02x \n",
> -		cpu_num, uci->rev, val[1],
> +		cpu_num, uci->cpu_sig.rev, val[1],
>  		uci->mc.mc_intel->hdr.date & 0xffff,
>  		uci->mc.mc_intel->hdr.date >> 24,
>  		(uci->mc.mc_intel->hdr.date >> 16) & 0xff);
> -	uci->rev = val[1];
> +	uci->cpu_sig.rev = val[1];
>  }
>  
>  #ifdef CONFIG_MICROCODE_OLD_INTERFACE
> @@ -459,70 +450,18 @@ static int cpu_request_microcode(int cpu)
>  	return error;
>  }
>  
> -static int apply_microcode_check_cpu(int cpu)
> -{
> -	struct cpuinfo_x86 *c = &cpu_data(cpu);
> -	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> -	cpumask_t old;
> -	unsigned int val[2];
> -	int err = 0;
> -
> -	/* Check if the microcode is available */
> -	if (!uci->mc.mc_intel)
> -		return 0;
> -
> -	old = current->cpus_allowed;
> -	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
> -
> -	/* Check if the microcode we have in memory matches the CPU */
> -	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
> -	    cpu_has(c, X86_FEATURE_IA64) || uci->sig != cpuid_eax(0x00000001))
> -		err = -EINVAL;
> -
> -	if (!err && ((c->x86_model >= 5) || (c->x86 > 6))) {
> -		/* get processor flags from MSR 0x17 */
> -		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
> -		if (uci->pf != (1 << ((val[1] >> 18) & 7)))
> -			err = -EINVAL;
> -	}
> -
> -	if (!err) {
> -		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
> -		/* see notes above for revision 1.07.  Apparent chip bug */
> -		sync_core();
> -		/* get the current revision from MSR 0x8B */
> -		rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
> -		if (uci->rev != val[1])
> -			err = -EINVAL;
> -	}
> -
> -	if (!err)
> -		apply_microcode(cpu);
> -	else
> -		printk(KERN_ERR "microcode: Could not apply microcode to CPU%d:"
> -			" sig=0x%x, pf=0x%x, rev=0x%x\n",
> -			cpu, uci->sig, uci->pf, uci->rev);
> -
> -	set_cpus_allowed_ptr(current, &old);
> -	return err;
> -}
> -
>  static void microcode_fini_cpu(int cpu)
>  {
>  	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>  
> -	mutex_lock(&microcode_mutex);
> -	uci->valid = 0;
>  	vfree(uci->mc.mc_intel);
>  	uci->mc.mc_intel = NULL;
> -	mutex_unlock(&microcode_mutex);
>  }
>  
>  static struct microcode_ops microcode_intel_ops = {
>  	.get_next_ucode                   = get_next_ucode,
>  	.get_matching_microcode           = get_matching_microcode,
>  	.microcode_sanity_check           = microcode_sanity_check,
> -	.apply_microcode_check_cpu        = apply_microcode_check_cpu,
>  	.cpu_request_microcode            = cpu_request_microcode,
>  	.collect_cpu_info                 = collect_cpu_info,
>  	.apply_microcode                  = apply_microcode,
> diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
> index 18b2aee..7ceff48 100644
> --- a/include/asm-x86/microcode.h
> +++ b/include/asm-x86/microcode.h
> @@ -1,14 +1,18 @@
> +#ifndef ASM_X86__MICROCODE_H
> +#define ASM_X86__MICROCODE_H
> +
>  extern int microcode_init(void *opaque, struct module *module);
>  extern void microcode_exit(void);
>  
> +struct cpu_signature;
> +
>  struct microcode_ops {
>  	long (*get_next_ucode)(void **mc, long offset);
>  	long (*microcode_get_next_ucode)(void **mc, long offset);
>  	int (*get_matching_microcode)(void *mc, int cpu);
> -	int (*apply_microcode_check_cpu)(int cpu);
>  	int (*microcode_sanity_check)(void *mc);
>  	int (*cpu_request_microcode)(int cpu);
> -	void (*collect_cpu_info)(int cpu_num);
> +	int (*collect_cpu_info)(int cpu_num, struct cpu_signature *csig);
>  	void (*apply_microcode)(int cpu);
>  	void (*microcode_fini_cpu)(int cpu);
>  	void (*clear_patch)(void *data);
> @@ -75,13 +79,21 @@ struct microcode_amd {
>  	unsigned int mpb[0];
>  };
>  
> -struct ucode_cpu_info {
> -	int valid;
> +struct cpu_signature {
>  	unsigned int sig;
>  	unsigned int pf;
>  	unsigned int rev;
> +};
> +
> +struct ucode_cpu_info {
> +	struct cpu_signature cpu_sig;
> +	int valid;
>  	union {
>  		struct microcode_intel *mc_intel;
>  		struct microcode_amd *mc_amd;
> +		void *valid_mc;
>  	} mc;
>  };
> +extern struct ucode_cpu_info ucode_cpu_info[];
> +
> +#endif /* ASM_X86__MICROCODE_H */
> 
> 
> 
> 

-- 
            |           AMD Saxony Limited Liability Company & Co. KG
  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
  System    |                  Register Court Dresden: HRA 4896
  Research  |              General Partner authorized to represent:
  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

