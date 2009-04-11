Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZDKGi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZDKGi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 02:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZDKGiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 02:38:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:42422 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbZDKGip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 02:38:45 -0400
Subject: Re: [patch for 2.6.30 2/2]
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid cross-CPU interrupts
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: akpm@linux-foundation.org
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       davej@redhat.com, efault@gmx.de, len.brown@intel.com, mingo@elte.hu,
       rusty@rustcorp.com.au, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com, yakui.zhao@intel.com,
       yanmin_zhang@linux.intel.com
In-Reply-To: <200904110617.n3B6HJ7W026502@imap1.linux-foundation.org>
References: <200904110617.n3B6HJ7W026502@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 12:07:11 +0530
Message-Id: <1239431831.4418.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 23:17 -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> In drv_read(), check to see whether we can run the rdmsr() on the current
> CPU.  If so, do that.  So smp_call_function_single() can avoid the IPI.
> 
> Arguably, cpumask_any() should do this.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Zhao Yakui <yakui.zhao@intel.com>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Mike Galbraith <efault@gmx.de>
> Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts
> +++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -197,9 +197,22 @@ static void do_drv_write(void *_cmd)
>  
>  static void drv_read(struct drv_cmd *cmd)
>  {
> -	cmd->val = 0;
> +	int target_cpu;		/* The CPU on which to perform thr rdmsr() */

+ 	int target_cpu; 	/* The CPU on which to perform the rdmsr() */

--
JSR

