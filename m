Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZBDFNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZBDFNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZBDFNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:13:36 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:57472 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZBDFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:13:34 -0500
Date: Wed, 04 Feb 2009 00:13:31 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 7/7] ACPI: cpufreq: Remove deprecated
 /proc/acpi/processor/../performance proc entries
In-reply-to: <1233679606-1971-8-git-send-email-trenn@suse.de>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Renninger <trenn@suse.de>
Cc: davej@codemonkey.org.uk, mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       Linux ACPI list <linux-acpi@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0902040012551.5607@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1233679606-1971-1-git-send-email-trenn@suse.de>
 <1233679606-1971-8-git-send-email-trenn@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied

thanks,
--
Len Brown, Intel Open Source Technology Center

On Tue, 3 Feb 2009, Thomas Renninger wrote:

> They were long enough set deprecated...
> 
> Update Documentation/cpu-freq/users-guide.txt:
> The deprecated files listed there seen not to exist for some time anymore
> already.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: Len Brown <lenb@kernel.org>
> CC: Linux ACPI list <linux-acpi@vger.kernel.org>
> ---
>  Documentation/cpu-freq/user-guide.txt |   16 -----
>  arch/x86/kernel/cpu/cpufreq/Kconfig   |   11 ----
>  drivers/acpi/processor_perflib.c      |  105 ---------------------------------
>  3 files changed, 0 insertions(+), 132 deletions(-)
> 
> diff --git a/Documentation/cpu-freq/user-guide.txt b/Documentation/cpu-freq/user-guide.txt
> index 57f23cb..75f4119 100644
> --- a/Documentation/cpu-freq/user-guide.txt
> +++ b/Documentation/cpu-freq/user-guide.txt
> @@ -207,19 +207,3 @@ scaling_setspeed.		By "echoing" a new frequency into this
>  				you can change the speed of the CPU,
>  				but only within the limits of
>  				scaling_min_freq and scaling_max_freq.
> -				
> -
> -3.2 Deprecated Interfaces
> --------------------------
> -
> -Depending on your kernel configuration, you might find the following 
> -cpufreq-related files:
> -/proc/cpufreq
> -/proc/sys/cpu/*/speed
> -/proc/sys/cpu/*/speed-min
> -/proc/sys/cpu/*/speed-max
> -
> -These are files for deprecated interfaces to cpufreq, which offer far
> -less functionality. Because of this, these interfaces aren't described
> -here.
> -
> diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
> index b63b0db..52c8398 100644
> --- a/arch/x86/kernel/cpu/cpufreq/Kconfig
> +++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
> @@ -230,17 +230,6 @@ config X86_E_POWERSAVER
>  
>  comment "shared options"
>  
> -config X86_ACPI_CPUFREQ_PROC_INTF
> -	bool "/proc/acpi/processor/../performance interface (deprecated)"
> -	depends on PROC_FS
> -	depends on X86_ACPI_CPUFREQ || X86_POWERNOW_K7_ACPI || X86_POWERNOW_K8_ACPI
> -	help
> -	  This enables the deprecated /proc/acpi/processor/../performance
> -	  interface. While it is helpful for debugging, the generic,
> -	  cross-architecture cpufreq interfaces should be used.
> -
> -	  If in doubt, say N.
> -
>  config X86_SPEEDSTEP_LIB
>  	tristate
>  	default (X86_SPEEDSTEP_ICH || X86_SPEEDSTEP_SMI || X86_P4_CLOCKMOD)
> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> index 846e227..9cc769b 100644
> --- a/drivers/acpi/processor_perflib.c
> +++ b/drivers/acpi/processor_perflib.c
> @@ -31,14 +31,6 @@
>  #include <linux/init.h>
>  #include <linux/cpufreq.h>
>  
> -#ifdef CONFIG_X86_ACPI_CPUFREQ_PROC_INTF
> -#include <linux/proc_fs.h>
> -#include <linux/seq_file.h>
> -#include <linux/mutex.h>
> -
> -#include <asm/uaccess.h>
> -#endif
> -
>  #ifdef CONFIG_X86
>  #include <asm/cpufeature.h>
>  #endif
> @@ -434,96 +426,6 @@ int acpi_processor_notify_smm(struct module *calling_module)
>  
>  EXPORT_SYMBOL(acpi_processor_notify_smm);
>  
> -#ifdef CONFIG_X86_ACPI_CPUFREQ_PROC_INTF
> -/* /proc/acpi/processor/../performance interface (DEPRECATED) */
> -
> -static int acpi_processor_perf_open_fs(struct inode *inode, struct file *file);
> -static struct file_operations acpi_processor_perf_fops = {
> -	.owner = THIS_MODULE,
> -	.open = acpi_processor_perf_open_fs,
> -	.read = seq_read,
> -	.llseek = seq_lseek,
> -	.release = single_release,
> -};
> -
> -static int acpi_processor_perf_seq_show(struct seq_file *seq, void *offset)
> -{
> -	struct acpi_processor *pr = seq->private;
> -	int i;
> -
> -
> -	if (!pr)
> -		goto end;
> -
> -	if (!pr->performance) {
> -		seq_puts(seq, "<not supported>\n");
> -		goto end;
> -	}
> -
> -	seq_printf(seq, "state count:             %d\n"
> -		   "active state:            P%d\n",
> -		   pr->performance->state_count, pr->performance->state);
> -
> -	seq_puts(seq, "states:\n");
> -	for (i = 0; i < pr->performance->state_count; i++)
> -		seq_printf(seq,
> -			   "   %cP%d:                  %d MHz, %d mW, %d uS\n",
> -			   (i == pr->performance->state ? '*' : ' '), i,
> -			   (u32) pr->performance->states[i].core_frequency,
> -			   (u32) pr->performance->states[i].power,
> -			   (u32) pr->performance->states[i].transition_latency);
> -
> -      end:
> -	return 0;
> -}
> -
> -static int acpi_processor_perf_open_fs(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, acpi_processor_perf_seq_show,
> -			   PDE(inode)->data);
> -}
> -
> -static void acpi_cpufreq_add_file(struct acpi_processor *pr)
> -{
> -	struct acpi_device *device = NULL;
> -
> -
> -	if (acpi_bus_get_device(pr->handle, &device))
> -		return;
> -
> -	/* add file 'performance' [R/W] */
> -	proc_create_data(ACPI_PROCESSOR_FILE_PERFORMANCE, S_IFREG | S_IRUGO,
> -			 acpi_device_dir(device),
> -			 &acpi_processor_perf_fops, acpi_driver_data(device));
> -	return;
> -}
> -
> -static void acpi_cpufreq_remove_file(struct acpi_processor *pr)
> -{
> -	struct acpi_device *device = NULL;
> -
> -
> -	if (acpi_bus_get_device(pr->handle, &device))
> -		return;
> -
> -	/* remove file 'performance' */
> -	remove_proc_entry(ACPI_PROCESSOR_FILE_PERFORMANCE,
> -			  acpi_device_dir(device));
> -
> -	return;
> -}
> -
> -#else
> -static void acpi_cpufreq_add_file(struct acpi_processor *pr)
> -{
> -	return;
> -}
> -static void acpi_cpufreq_remove_file(struct acpi_processor *pr)
> -{
> -	return;
> -}
> -#endif				/* CONFIG_X86_ACPI_CPUFREQ_PROC_INTF */
> -
>  static int acpi_processor_get_psd(struct acpi_processor	*pr)
>  {
>  	int result = 0;
> @@ -747,14 +649,12 @@ err_ret:
>  }
>  EXPORT_SYMBOL(acpi_processor_preregister_performance);
>  
> -
>  int
>  acpi_processor_register_performance(struct acpi_processor_performance
>  				    *performance, unsigned int cpu)
>  {
>  	struct acpi_processor *pr;
>  
> -
>  	if (!(acpi_processor_ppc_status & PPC_REGISTERED))
>  		return -EINVAL;
>  
> @@ -781,8 +681,6 @@ acpi_processor_register_performance(struct acpi_processor_performance
>  		return -EIO;
>  	}
>  
> -	acpi_cpufreq_add_file(pr);
> -
>  	mutex_unlock(&performance_mutex);
>  	return 0;
>  }
> @@ -795,7 +693,6 @@ acpi_processor_unregister_performance(struct acpi_processor_performance
>  {
>  	struct acpi_processor *pr;
>  
> -
>  	mutex_lock(&performance_mutex);
>  
>  	pr = per_cpu(processors, cpu);
> @@ -808,8 +705,6 @@ acpi_processor_unregister_performance(struct acpi_processor_performance
>  		kfree(pr->performance->states);
>  	pr->performance = NULL;
>  
> -	acpi_cpufreq_remove_file(pr);
> -
>  	mutex_unlock(&performance_mutex);
>  
>  	return;
> -- 
> 1.6.0.2
> 
