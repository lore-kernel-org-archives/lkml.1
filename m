Return-Path: <linux-kernel-owner+w=401wt.eu-S1762849AbXIUWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762849AbXIUWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbXIUWZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:25:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:5563 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471AbXIUWZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tlw0KbdSeS3Fj+ydfxFWbeoGdh7ULqo55mOxBv8/20Xasdetj0ioBfUPm52rZwG1nW3UNai52KPOO8B2DEg25eJuaJQcR3vGzIj/cwyn/jbU9JlcZNIFiK9IPU6DcYayba+rSjpJTSqxizh0jscGTnUvGA2ShppkIVip/l+GKVA=
Message-ID: <86802c440709211525x70d4ff66n3e7df59c44166102@mail.gmail.com>
Date: Fri, 21 Sep 2007 15:25:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + x86-convert-cpuinfo_x86-array-to-a-per_cpu-array-v2.patch added to -mm tree
Cc: mm-commits@vger.kernel.org, travis@sgi.com, ak@suse.de, clameter@sgi.com
In-Reply-To: <200709211012.l8LACrC3030383@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709211012.l8LACrC3030383@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>
> The patch titled
>      x86: Convert cpuinfo_x86 array to a per_cpu array
> has been added to the -mm tree.  Its filename is
>      x86-convert-cpuinfo_x86-array-to-a-per_cpu-array-v2.patch
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
>
> ------------------------------------------------------
> Subject: x86: Convert cpuinfo_x86 array to a per_cpu array
> From: travis@sgi.com
>
> cpu_data is currently an array defined using NR_CPUS.  This means that we
> overallocate since we will rarely really use maximum configured cpus.  When
> NR_CPU count is raised to 4096 the size of cpu_data becomes 3,145,728
> bytes.
>
> These changes were adopted from the sparc64 (and ia64) code.  An additional
> field was added to cpuinfo_x86 to be a non-ambiguous cpu index.  This
> corresponds to the index into a cpumask_t as well as the per_cpu index.
> It's used in various places like show_cpuinfo().
>
> cpu_data is defined to be the boot_cpu_data structure for the
> NON-SMP case.
>
> This patch is based on 2.6.23-rc6 with the prior per_cpu patches
> applied.  I can also provide a version based on 2.6.23-rc4-mm1
> which has some different changes.
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Acked-by: Christoph Lameter <clameter@sgi.com>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/i386/kernel/acpi/cstate.c                    |    4 -
>  arch/i386/kernel/acpi/processor.c                 |    2
>  arch/i386/kernel/alternative.c                    |    6 -
>  arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c       |    4 -
>  arch/i386/kernel/cpu/cpufreq/e_powersaver.c       |    2
>  arch/i386/kernel/cpu/cpufreq/elanfreq.c           |    4 -
>  arch/i386/kernel/cpu/cpufreq/longhaul.c           |    4 -
>  arch/i386/kernel/cpu/cpufreq/longrun.c            |    4 -
>  arch/i386/kernel/cpu/cpufreq/p4-clockmod.c        |    4 -
>  arch/i386/kernel/cpu/cpufreq/powernow-k6.c        |    2
>  arch/i386/kernel/cpu/cpufreq/powernow-k7.c        |    2
>  arch/i386/kernel/cpu/cpufreq/sc520_freq.c         |    4 -
>  arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c |    6 -
>  arch/i386/kernel/cpu/cpufreq/speedstep-lib.c      |    2
>  arch/i386/kernel/cpu/intel_cacheinfo.c            |    8 +-
>  arch/i386/kernel/cpu/proc.c                       |    9 +-
>  arch/i386/kernel/cpuid.c                          |    2
>  arch/i386/kernel/microcode.c                      |    6 -
>  arch/i386/kernel/msr.c                            |    2
>  arch/i386/kernel/sched-clock.c                    |    2
>  arch/i386/kernel/smp.c                            |    2
>  arch/i386/kernel/smpboot.c                        |   45 ++++++------
>  arch/i386/kernel/tsc.c                            |    8 +-
>  arch/i386/lib/delay.c                             |    2
>  arch/i386/mach-voyager/voyager_smp.c              |   12 +--
>  arch/x86_64/kernel/mce.c                          |    2
>  arch/x86_64/kernel/mce_amd.c                      |    4 -
>  arch/x86_64/kernel/setup.c                        |   18 ++--
>  arch/x86_64/kernel/smpboot.c                      |   44 +++++------
>  arch/x86_64/kernel/tsc.c                          |    4 -
>  arch/x86_64/kernel/vsyscall.c                     |    2
>  arch/x86_64/lib/delay.c                           |    2
>  drivers/hwmon/coretemp.c                          |    6 -
>  drivers/hwmon/hwmon-vid.c                         |    2
>  drivers/input/gameport/gameport.c                 |    2
>  drivers/video/geode/video_gx.c                    |    2
>  include/asm-i386/processor.h                      |   10 +-
>  include/asm-i386/topology.h                       |    4 -
>  include/asm-x86_64/processor.h                    |   10 +-
>  include/asm-x86_64/topology.h                     |    4 -
>  40 files changed, 138 insertions(+), 126 deletions(-)
>
> +++ a/arch/i386/kernel/cpu/cpufreq/elanfreq.c
> @@ -199,7 +199,7 @@ static int elanfreq_target (struct cpufr
>
>  static int elanfreq_cpu_init(struct cpufreq_policy *policy)
>  {
> -       struct cpuinfo_x86 *c = cpu_data;
> +       struct cpuinfo_x86 *c = &cpu_data(cpu);
>         unsigned int i;
>         int result;
>
> @@ -280,7 +280,7 @@ static struct cpufreq_driver elanfreq_dr
>
>  static int __init elanfreq_init(void)
>  {
> -       struct cpuinfo_x86 *c = cpu_data;
> +       struct cpuinfo_x86 *c = &cpu_data(cpu);

this is confusing, can you check simmiliar &cpu_data(cpu) to
&cpu_data(0) instead...

YH
