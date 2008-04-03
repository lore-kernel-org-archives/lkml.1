Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYDCX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYDCX0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYDCX0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:26:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:32578 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYDCX0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ZwqEuh5ZFUNGHRBrI9i0+5ZcPjFxSFoUz9QU2TeKcjHM6qpc9BoJMkKiJNGNj0+sDJBVnvQhQXI/fInTz6OsZ0bWZyzW1MNpPWjSafX4JyLmSgrFIddmmqUa5G7d80NOnT9jubuh7tVaQJl695RYYa1JxLNAOh/3ALD+RmTd8ac=
Message-ID: <47F567A6.9090400@gmail.com>
Date: Fri, 04 Apr 2008 03:26:30 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 (mips build failure)
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <47F31C46.9000503@gmail.com> <20080401230322.331c50f4.akpm@linux-foundation.org> <Pine.LNX.4.64.0804021031480.26938@schroedinger.engr.sgi.com> <20080402112907.76e1c554.akpm@linux-foundation.org> <Pine.LNX.4.64.0804021130040.28113@schroedinger.engr.sgi.com> <20080402190623.GA23651@uranus.ravnborg.org> <20080403160230.GA17771@linux-mips.org> <Pine.LNX.4.64.0804031515280.8986@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0804031515280.8986@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter пишет:
> On Thu, 3 Apr 2008, Ralf Baechle wrote:
> 
>> The reason for MIPS doing things a little different is that the resulting
>> <asm/asm-offsets.h> doesn't look like machine generated jibberish.  So
>> how about below patch which combines the two sed expressions.
> 
> Well but it is machine generated and it may be best if mips would do more 
> of the same that is done in other arches? We do not want special arch 
> cases in Kbuild.
> 
> How about this patch?
> 

I confirm that with this patch applied, the kernel build succeeds. Did
not try to boot it, though.

Thanks,
Dmitri

> 
> Subject: Standardize mips asm-offsets.c somewhat
> 
> mips uses a different pattern to signal a constant in the asm code generated
> by asm-offsets.c which in turn requires special handling in Kbuild and 
> causes trouble for the new mechanism to count the number of page flags.
> 
> Remove the special handling and make mips use the same string as all the
> other arches (->).
> 
> It seems that MIPS tried to have nice looking asm output. Sadly this 
> patch disturbsthat nice formatting somewhat and makes it look like asm 
> output for any otherarch.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  Kbuild                         |    2 
>  arch/mips/kernel/asm-offsets.c |  392 ++++++++++++++++++++---------------------
>  2 files changed, 196 insertions(+), 198 deletions(-)
> 
> Index: linux-2.6.25-rc8-mm1/Kbuild
> ===================================================================
> --- linux-2.6.25-rc8-mm1.orig/Kbuild	2008-04-03 14:53:38.581697916 -0700
> +++ linux-2.6.25-rc8-mm1/Kbuild	2008-04-03 14:53:41.411694858 -0700
> @@ -54,8 +54,6 @@ targets += arch/$(SRCARCH)/kernel/asm-of
>  define sed-y
>  	"/^->/{s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; s:->::; p;}"
>  endef
> -# Override default regexp for specific architectures
> -sed-$(CONFIG_MIPS) := "/^@@@/{s/^@@@//; s/ \#.*\$$//; p;}"
>  
>  quiet_cmd_offsets = GEN     $@
>  define cmd_offsets
> Index: linux-2.6.25-rc8-mm1/arch/mips/kernel/asm-offsets.c
> ===================================================================
> --- linux-2.6.25-rc8-mm1.orig/arch/mips/kernel/asm-offsets.c	2008-04-03 14:53:38.601695308 -0700
> +++ linux-2.6.25-rc8-mm1/arch/mips/kernel/asm-offsets.c	2008-04-03 14:59:46.939017142 -0700
> @@ -20,193 +20,193 @@
>  #define text(t) __asm__("\n@@@" t)
>  #define _offset(type, member) (&(((type *)NULL)->member))
>  #define offset(string, ptr, member) \
> -	__asm__("\n@@@" string "%0" : : "i" (_offset(ptr, member)))
> +	__asm__("\n->" string " %0" : : "i" (_offset(ptr, member)))
>  #define constant(string, member) \
> -	__asm__("\n@@@" string "%X0" : : "ri" (member))
> +	__asm__("\n->" string " %0" : : "ri" (member))
>  #define size(string, size) \
> -	__asm__("\n@@@" string "%0" : : "i" (sizeof(size)))
> +	__asm__("\n->" string " %0" : : "i" (sizeof(size)))
>  #define linefeed text("")
>  
>  void output_ptreg_defines(void)
>  {
>  	text("/* MIPS pt_regs offsets. */");
> -	offset("#define PT_R0     ", struct pt_regs, regs[0]);
> -	offset("#define PT_R1     ", struct pt_regs, regs[1]);
> -	offset("#define PT_R2     ", struct pt_regs, regs[2]);
> -	offset("#define PT_R3     ", struct pt_regs, regs[3]);
> -	offset("#define PT_R4     ", struct pt_regs, regs[4]);
> -	offset("#define PT_R5     ", struct pt_regs, regs[5]);
> -	offset("#define PT_R6     ", struct pt_regs, regs[6]);
> -	offset("#define PT_R7     ", struct pt_regs, regs[7]);
> -	offset("#define PT_R8     ", struct pt_regs, regs[8]);
> -	offset("#define PT_R9     ", struct pt_regs, regs[9]);
> -	offset("#define PT_R10    ", struct pt_regs, regs[10]);
> -	offset("#define PT_R11    ", struct pt_regs, regs[11]);
> -	offset("#define PT_R12    ", struct pt_regs, regs[12]);
> -	offset("#define PT_R13    ", struct pt_regs, regs[13]);
> -	offset("#define PT_R14    ", struct pt_regs, regs[14]);
> -	offset("#define PT_R15    ", struct pt_regs, regs[15]);
> -	offset("#define PT_R16    ", struct pt_regs, regs[16]);
> -	offset("#define PT_R17    ", struct pt_regs, regs[17]);
> -	offset("#define PT_R18    ", struct pt_regs, regs[18]);
> -	offset("#define PT_R19    ", struct pt_regs, regs[19]);
> -	offset("#define PT_R20    ", struct pt_regs, regs[20]);
> -	offset("#define PT_R21    ", struct pt_regs, regs[21]);
> -	offset("#define PT_R22    ", struct pt_regs, regs[22]);
> -	offset("#define PT_R23    ", struct pt_regs, regs[23]);
> -	offset("#define PT_R24    ", struct pt_regs, regs[24]);
> -	offset("#define PT_R25    ", struct pt_regs, regs[25]);
> -	offset("#define PT_R26    ", struct pt_regs, regs[26]);
> -	offset("#define PT_R27    ", struct pt_regs, regs[27]);
> -	offset("#define PT_R28    ", struct pt_regs, regs[28]);
> -	offset("#define PT_R29    ", struct pt_regs, regs[29]);
> -	offset("#define PT_R30    ", struct pt_regs, regs[30]);
> -	offset("#define PT_R31    ", struct pt_regs, regs[31]);
> -	offset("#define PT_LO     ", struct pt_regs, lo);
> -	offset("#define PT_HI     ", struct pt_regs, hi);
> +	offset("PT_R0", struct pt_regs, regs[0]);
> +	offset("PT_R1", struct pt_regs, regs[1]);
> +	offset("PT_R2", struct pt_regs, regs[2]);
> +	offset("PT_R3", struct pt_regs, regs[3]);
> +	offset("PT_R4", struct pt_regs, regs[4]);
> +	offset("PT_R5", struct pt_regs, regs[5]);
> +	offset("PT_R6", struct pt_regs, regs[6]);
> +	offset("PT_R7", struct pt_regs, regs[7]);
> +	offset("PT_R8", struct pt_regs, regs[8]);
> +	offset("PT_R9", struct pt_regs, regs[9]);
> +	offset("PT_R10", struct pt_regs, regs[10]);
> +	offset("PT_R11", struct pt_regs, regs[11]);
> +	offset("PT_R12", struct pt_regs, regs[12]);
> +	offset("PT_R13", struct pt_regs, regs[13]);
> +	offset("PT_R14", struct pt_regs, regs[14]);
> +	offset("PT_R15", struct pt_regs, regs[15]);
> +	offset("PT_R16", struct pt_regs, regs[16]);
> +	offset("PT_R17", struct pt_regs, regs[17]);
> +	offset("PT_R18", struct pt_regs, regs[18]);
> +	offset("PT_R19", struct pt_regs, regs[19]);
> +	offset("PT_R20", struct pt_regs, regs[20]);
> +	offset("PT_R21", struct pt_regs, regs[21]);
> +	offset("PT_R22", struct pt_regs, regs[22]);
> +	offset("PT_R23", struct pt_regs, regs[23]);
> +	offset("PT_R24", struct pt_regs, regs[24]);
> +	offset("PT_R25", struct pt_regs, regs[25]);
> +	offset("PT_R26", struct pt_regs, regs[26]);
> +	offset("PT_R27", struct pt_regs, regs[27]);
> +	offset("PT_R28", struct pt_regs, regs[28]);
> +	offset("PT_R29", struct pt_regs, regs[29]);
> +	offset("PT_R30", struct pt_regs, regs[30]);
> +	offset("PT_R31", struct pt_regs, regs[31]);
> +	offset("PT_LO", struct pt_regs, lo);
> +	offset("PT_HI", struct pt_regs, hi);
>  #ifdef CONFIG_CPU_HAS_SMARTMIPS
> -	offset("#define PT_ACX    ", struct pt_regs, acx);
> +	offset("PT_ACX", struct pt_regs, acx);
>  #endif
> -	offset("#define PT_EPC    ", struct pt_regs, cp0_epc);
> -	offset("#define PT_BVADDR ", struct pt_regs, cp0_badvaddr);
> -	offset("#define PT_STATUS ", struct pt_regs, cp0_status);
> -	offset("#define PT_CAUSE  ", struct pt_regs, cp0_cause);
> +	offset("PT_EPC", struct pt_regs, cp0_epc);
> +	offset("PT_BVADDR", struct pt_regs, cp0_badvaddr);
> +	offset("PT_STATUS", struct pt_regs, cp0_status);
> +	offset("PT_CAUSE", struct pt_regs, cp0_cause);
>  #ifdef CONFIG_MIPS_MT_SMTC
> -	offset("#define PT_TCSTATUS  ", struct pt_regs, cp0_tcstatus);
> +	offset("PT_TCSTATUS", struct pt_regs, cp0_tcstatus);
>  #endif /* CONFIG_MIPS_MT_SMTC */
> -	size("#define PT_SIZE   ", struct pt_regs);
> +	size("PT_SIZE", struct pt_regs);
>  	linefeed;
>  }
>  
>  void output_task_defines(void)
>  {
>  	text("/* MIPS task_struct offsets. */");
> -	offset("#define TASK_STATE         ", struct task_struct, state);
> -	offset("#define TASK_THREAD_INFO   ", struct task_struct, stack);
> -	offset("#define TASK_FLAGS         ", struct task_struct, flags);
> -	offset("#define TASK_MM            ", struct task_struct, mm);
> -	offset("#define TASK_PID           ", struct task_struct, pid);
> -	size(  "#define TASK_STRUCT_SIZE   ", struct task_struct);
> +	offset("TASK_STATE", struct task_struct, state);
> +	offset("TASK_THREAD_INFO", struct task_struct, stack);
> +	offset("TASK_FLAGS", struct task_struct, flags);
> +	offset("TASK_MM", struct task_struct, mm);
> +	offset("TASK_PID", struct task_struct, pid);
> +	size(  "TASK_STRUCT_SIZE", struct task_struct);
>  	linefeed;
>  }
>  
>  void output_thread_info_defines(void)
>  {
>  	text("/* MIPS thread_info offsets. */");
> -	offset("#define TI_TASK            ", struct thread_info, task);
> -	offset("#define TI_EXEC_DOMAIN     ", struct thread_info, exec_domain);
> -	offset("#define TI_FLAGS           ", struct thread_info, flags);
> -	offset("#define TI_TP_VALUE	   ", struct thread_info, tp_value);
> -	offset("#define TI_CPU             ", struct thread_info, cpu);
> -	offset("#define TI_PRE_COUNT       ", struct thread_info, preempt_count);
> -	offset("#define TI_ADDR_LIMIT      ", struct thread_info, addr_limit);
> -	offset("#define TI_RESTART_BLOCK   ", struct thread_info, restart_block);
> -	offset("#define TI_REGS            ", struct thread_info, regs);
> -	constant("#define _THREAD_SIZE       ", THREAD_SIZE);
> -	constant("#define _THREAD_MASK       ", THREAD_MASK);
> +	offset("TI_TASK", struct thread_info, task);
> +	offset("TI_EXEC_DOMAIN", struct thread_info, exec_domain);
> +	offset("TI_FLAGS", struct thread_info, flags);
> +	offset("TI_TP_VALUE", struct thread_info, tp_value);
> +	offset("TI_CPU", struct thread_info, cpu);
> +	offset("TI_PRE_COUNT", struct thread_info, preempt_count);
> +	offset("TI_ADDR_LIMIT", struct thread_info, addr_limit);
> +	offset("TI_RESTART_BLOCK", struct thread_info, restart_block);
> +	offset("TI_REGS", struct thread_info, regs);
> +	constant("_THREAD_SIZE", THREAD_SIZE);
> +	constant("_THREAD_MASK", THREAD_MASK);
>  	linefeed;
>  }
>  
>  void output_thread_defines(void)
>  {
>  	text("/* MIPS specific thread_struct offsets. */");
> -	offset("#define THREAD_REG16   ", struct task_struct, thread.reg16);
> -	offset("#define THREAD_REG17   ", struct task_struct, thread.reg17);
> -	offset("#define THREAD_REG18   ", struct task_struct, thread.reg18);
> -	offset("#define THREAD_REG19   ", struct task_struct, thread.reg19);
> -	offset("#define THREAD_REG20   ", struct task_struct, thread.reg20);
> -	offset("#define THREAD_REG21   ", struct task_struct, thread.reg21);
> -	offset("#define THREAD_REG22   ", struct task_struct, thread.reg22);
> -	offset("#define THREAD_REG23   ", struct task_struct, thread.reg23);
> -	offset("#define THREAD_REG29   ", struct task_struct, thread.reg29);
> -	offset("#define THREAD_REG30   ", struct task_struct, thread.reg30);
> -	offset("#define THREAD_REG31   ", struct task_struct, thread.reg31);
> -	offset("#define THREAD_STATUS  ", struct task_struct,
> +	offset("THREAD_REG16", struct task_struct, thread.reg16);
> +	offset("THREAD_REG17", struct task_struct, thread.reg17);
> +	offset("THREAD_REG18", struct task_struct, thread.reg18);
> +	offset("THREAD_REG19", struct task_struct, thread.reg19);
> +	offset("THREAD_REG20", struct task_struct, thread.reg20);
> +	offset("THREAD_REG21", struct task_struct, thread.reg21);
> +	offset("THREAD_REG22", struct task_struct, thread.reg22);
> +	offset("THREAD_REG23", struct task_struct, thread.reg23);
> +	offset("THREAD_REG29", struct task_struct, thread.reg29);
> +	offset("THREAD_REG30", struct task_struct, thread.reg30);
> +	offset("THREAD_REG31", struct task_struct, thread.reg31);
> +	offset("THREAD_STATUS", struct task_struct,
>  	       thread.cp0_status);
> -	offset("#define THREAD_FPU     ", struct task_struct, thread.fpu);
> +	offset("THREAD_FPU", struct task_struct, thread.fpu);
>  
> -	offset("#define THREAD_BVADDR  ", struct task_struct, \
> +	offset("THREAD_BVADDR", struct task_struct, \
>  	       thread.cp0_badvaddr);
> -	offset("#define THREAD_BUADDR  ", struct task_struct, \
> +	offset("THREAD_BUADDR", struct task_struct, \
>  	       thread.cp0_baduaddr);
> -	offset("#define THREAD_ECODE   ", struct task_struct, \
> +	offset("THREAD_ECODE", struct task_struct, \
>  	       thread.error_code);
> -	offset("#define THREAD_TRAPNO  ", struct task_struct, thread.trap_no);
> -	offset("#define THREAD_TRAMP   ", struct task_struct, \
> +	offset("THREAD_TRAPNO", struct task_struct, thread.trap_no);
> +	offset("THREAD_TRAMP", struct task_struct, \
>  	       thread.irix_trampoline);
> -	offset("#define THREAD_OLDCTX  ", struct task_struct, \
> +	offset("THREAD_OLDCTX", struct task_struct, \
>  	       thread.irix_oldctx);
>  	linefeed;
>  }
>  
>  void output_thread_fpu_defines(void)
>  {
> -	offset("#define THREAD_FPR0    ",
> +	offset("THREAD_FPR0",
>  	       struct task_struct, thread.fpu.fpr[0]);
> -	offset("#define THREAD_FPR1    ",
> +	offset("THREAD_FPR1",
>  	       struct task_struct, thread.fpu.fpr[1]);
> -	offset("#define THREAD_FPR2    ",
> +	offset("THREAD_FPR2",
>  	       struct task_struct, thread.fpu.fpr[2]);
> -	offset("#define THREAD_FPR3    ",
> +	offset("THREAD_FPR3",
>  	       struct task_struct, thread.fpu.fpr[3]);
> -	offset("#define THREAD_FPR4    ",
> +	offset("THREAD_FPR4",
>  	       struct task_struct, thread.fpu.fpr[4]);
> -	offset("#define THREAD_FPR5    ",
> +	offset("THREAD_FPR5",
>  	       struct task_struct, thread.fpu.fpr[5]);
> -	offset("#define THREAD_FPR6    ",
> +	offset("THREAD_FPR6",
>  	       struct task_struct, thread.fpu.fpr[6]);
> -	offset("#define THREAD_FPR7    ",
> +	offset("THREAD_FPR7",
>  	       struct task_struct, thread.fpu.fpr[7]);
> -	offset("#define THREAD_FPR8    ",
> +	offset("THREAD_FPR8",
>  	       struct task_struct, thread.fpu.fpr[8]);
> -	offset("#define THREAD_FPR9    ",
> +	offset("THREAD_FPR9",
>  	       struct task_struct, thread.fpu.fpr[9]);
> -	offset("#define THREAD_FPR10   ",
> +	offset("THREAD_FPR10",
>  	       struct task_struct, thread.fpu.fpr[10]);
> -	offset("#define THREAD_FPR11   ",
> +	offset("THREAD_FPR11",
>  	       struct task_struct, thread.fpu.fpr[11]);
> -	offset("#define THREAD_FPR12   ",
> +	offset("THREAD_FPR12",
>  	       struct task_struct, thread.fpu.fpr[12]);
> -	offset("#define THREAD_FPR13   ",
> +	offset("THREAD_FPR13",
>  	       struct task_struct, thread.fpu.fpr[13]);
> -	offset("#define THREAD_FPR14   ",
> +	offset("THREAD_FPR14",
>  	       struct task_struct, thread.fpu.fpr[14]);
> -	offset("#define THREAD_FPR15   ",
> +	offset("THREAD_FPR15",
>  	       struct task_struct, thread.fpu.fpr[15]);
> -	offset("#define THREAD_FPR16   ",
> +	offset("THREAD_FPR16",
>  	       struct task_struct, thread.fpu.fpr[16]);
> -	offset("#define THREAD_FPR17   ",
> +	offset("THREAD_FPR17",
>  	       struct task_struct, thread.fpu.fpr[17]);
> -	offset("#define THREAD_FPR18   ",
> +	offset("THREAD_FPR18",
>  	       struct task_struct, thread.fpu.fpr[18]);
> -	offset("#define THREAD_FPR19   ",
> +	offset("THREAD_FPR19",
>  	       struct task_struct, thread.fpu.fpr[19]);
> -	offset("#define THREAD_FPR20   ",
> +	offset("THREAD_FPR20",
>  	       struct task_struct, thread.fpu.fpr[20]);
> -	offset("#define THREAD_FPR21   ",
> +	offset("THREAD_FPR21",
>  	       struct task_struct, thread.fpu.fpr[21]);
> -	offset("#define THREAD_FPR22   ",
> +	offset("THREAD_FPR22",
>  	       struct task_struct, thread.fpu.fpr[22]);
> -	offset("#define THREAD_FPR23   ",
> +	offset("THREAD_FPR23",
>  	       struct task_struct, thread.fpu.fpr[23]);
> -	offset("#define THREAD_FPR24   ",
> +	offset("THREAD_FPR24",
>  	       struct task_struct, thread.fpu.fpr[24]);
> -	offset("#define THREAD_FPR25   ",
> +	offset("THREAD_FPR25",
>  	       struct task_struct, thread.fpu.fpr[25]);
> -	offset("#define THREAD_FPR26   ",
> +	offset("THREAD_FPR26",
>  	       struct task_struct, thread.fpu.fpr[26]);
> -	offset("#define THREAD_FPR27   ",
> +	offset("THREAD_FPR27",
>  	       struct task_struct, thread.fpu.fpr[27]);
> -	offset("#define THREAD_FPR28   ",
> +	offset("THREAD_FPR28",
>  	       struct task_struct, thread.fpu.fpr[28]);
> -	offset("#define THREAD_FPR29   ",
> +	offset("THREAD_FPR29",
>  	       struct task_struct, thread.fpu.fpr[29]);
> -	offset("#define THREAD_FPR30   ",
> +	offset("THREAD_FPR30",
>  	       struct task_struct, thread.fpu.fpr[30]);
> -	offset("#define THREAD_FPR31   ",
> +	offset("THREAD_FPR31",
>  	       struct task_struct, thread.fpu.fpr[31]);
>  
> -	offset("#define THREAD_FCR31   ",
> +	offset("THREAD_FCR31",
>  	       struct task_struct, thread.fpu.fcr31);
>  	linefeed;
>  }
> @@ -214,34 +214,34 @@ void output_thread_fpu_defines(void)
>  void output_mm_defines(void)
>  {
>  	text("/* Size of struct page  */");
> -	size("#define STRUCT_PAGE_SIZE   ", struct page);
> +	size("STRUCT_PAGE_SIZE", struct page);
>  	linefeed;
>  	text("/* Linux mm_struct offsets. */");
> -	offset("#define MM_USERS      ", struct mm_struct, mm_users);
> -	offset("#define MM_PGD        ", struct mm_struct, pgd);
> -	offset("#define MM_CONTEXT    ", struct mm_struct, context);
> -	linefeed;
> -	constant("#define _PAGE_SIZE     ", PAGE_SIZE);
> -	constant("#define _PAGE_SHIFT    ", PAGE_SHIFT);
> -	linefeed;
> -	constant("#define _PGD_T_SIZE    ", sizeof(pgd_t));
> -	constant("#define _PMD_T_SIZE    ", sizeof(pmd_t));
> -	constant("#define _PTE_T_SIZE    ", sizeof(pte_t));
> -	linefeed;
> -	constant("#define _PGD_T_LOG2    ", PGD_T_LOG2);
> -	constant("#define _PMD_T_LOG2    ", PMD_T_LOG2);
> -	constant("#define _PTE_T_LOG2    ", PTE_T_LOG2);
> -	linefeed;
> -	constant("#define _PGD_ORDER     ", PGD_ORDER);
> -	constant("#define _PMD_ORDER     ", PMD_ORDER);
> -	constant("#define _PTE_ORDER     ", PTE_ORDER);
> -	linefeed;
> -	constant("#define _PMD_SHIFT     ", PMD_SHIFT);
> -	constant("#define _PGDIR_SHIFT   ", PGDIR_SHIFT);
> -	linefeed;
> -	constant("#define _PTRS_PER_PGD  ", PTRS_PER_PGD);
> -	constant("#define _PTRS_PER_PMD  ", PTRS_PER_PMD);
> -	constant("#define _PTRS_PER_PTE  ", PTRS_PER_PTE);
> +	offset("MM_USERS", struct mm_struct, mm_users);
> +	offset("MM_PGD", struct mm_struct, pgd);
> +	offset("MM_CONTEXT", struct mm_struct, context);
> +	linefeed;
> +	constant("_PAGE_SIZE", PAGE_SIZE);
> +	constant("_PAGE_SHIFT", PAGE_SHIFT);
> +	linefeed;
> +	constant("_PGD_T_SIZE", sizeof(pgd_t));
> +	constant("_PMD_T_SIZE", sizeof(pmd_t));
> +	constant("_PTE_T_SIZE", sizeof(pte_t));
> +	linefeed;
> +	constant("_PGD_T_LOG2", PGD_T_LOG2);
> +	constant("_PMD_T_LOG2", PMD_T_LOG2);
> +	constant("_PTE_T_LOG2", PTE_T_LOG2);
> +	linefeed;
> +	constant("_PGD_ORDER", PGD_ORDER);
> +	constant("_PMD_ORDER", PMD_ORDER);
> +	constant("_PTE_ORDER", PTE_ORDER);
> +	linefeed;
> +	constant("_PMD_SHIFT", PMD_SHIFT);
> +	constant("_PGDIR_SHIFT", PGDIR_SHIFT);
> +	linefeed;
> +	constant("_PTRS_PER_PGD", PTRS_PER_PGD);
> +	constant("_PTRS_PER_PMD", PTRS_PER_PMD);
> +	constant("_PTRS_PER_PTE", PTRS_PER_PTE);
>  	linefeed;
>  }
>  
> @@ -249,20 +249,20 @@ void output_mm_defines(void)
>  void output_sc_defines(void)
>  {
>  	text("/* Linux sigcontext offsets. */");
> -	offset("#define SC_REGS       ", struct sigcontext, sc_regs);
> -	offset("#define SC_FPREGS     ", struct sigcontext, sc_fpregs);
> -	offset("#define SC_ACX        ", struct sigcontext, sc_acx);
> -	offset("#define SC_MDHI       ", struct sigcontext, sc_mdhi);
> -	offset("#define SC_MDLO       ", struct sigcontext, sc_mdlo);
> -	offset("#define SC_PC         ", struct sigcontext, sc_pc);
> -	offset("#define SC_FPC_CSR    ", struct sigcontext, sc_fpc_csr);
> -	offset("#define SC_FPC_EIR    ", struct sigcontext, sc_fpc_eir);
> -	offset("#define SC_HI1        ", struct sigcontext, sc_hi1);
> -	offset("#define SC_LO1        ", struct sigcontext, sc_lo1);
> -	offset("#define SC_HI2        ", struct sigcontext, sc_hi2);
> -	offset("#define SC_LO2        ", struct sigcontext, sc_lo2);
> -	offset("#define SC_HI3        ", struct sigcontext, sc_hi3);
> -	offset("#define SC_LO3        ", struct sigcontext, sc_lo3);
> +	offset("SC_REGS", struct sigcontext, sc_regs);
> +	offset("SC_FPREGS", struct sigcontext, sc_fpregs);
> +	offset("SC_ACX", struct sigcontext, sc_acx);
> +	offset("SC_MDHI", struct sigcontext, sc_mdhi);
> +	offset("SC_MDLO", struct sigcontext, sc_mdlo);
> +	offset("SC_PC", struct sigcontext, sc_pc);
> +	offset("SC_FPC_CSR", struct sigcontext, sc_fpc_csr);
> +	offset("SC_FPC_EIR", struct sigcontext, sc_fpc_eir);
> +	offset("SC_HI1", struct sigcontext, sc_hi1);
> +	offset("SC_LO1", struct sigcontext, sc_lo1);
> +	offset("SC_HI2", struct sigcontext, sc_hi2);
> +	offset("SC_LO2", struct sigcontext, sc_lo2);
> +	offset("SC_HI3", struct sigcontext, sc_hi3);
> +	offset("SC_LO3", struct sigcontext, sc_lo3);
>  	linefeed;
>  }
>  #endif
> @@ -271,12 +271,12 @@ void output_sc_defines(void)
>  void output_sc_defines(void)
>  {
>  	text("/* Linux sigcontext offsets. */");
> -	offset("#define SC_REGS       ", struct sigcontext, sc_regs);
> -	offset("#define SC_FPREGS     ", struct sigcontext, sc_fpregs);
> -	offset("#define SC_MDHI       ", struct sigcontext, sc_mdhi);
> -	offset("#define SC_MDLO       ", struct sigcontext, sc_mdlo);
> -	offset("#define SC_PC         ", struct sigcontext, sc_pc);
> -	offset("#define SC_FPC_CSR    ", struct sigcontext, sc_fpc_csr);
> +	offset("SC_REGS", struct sigcontext, sc_regs);
> +	offset("SC_FPREGS", struct sigcontext, sc_fpregs);
> +	offset("SC_MDHI", struct sigcontext, sc_mdhi);
> +	offset("SC_MDLO", struct sigcontext, sc_mdlo);
> +	offset("SC_PC", struct sigcontext, sc_pc);
> +	offset("SC_FPC_CSR", struct sigcontext, sc_fpc_csr);
>  	linefeed;
>  }
>  #endif
> @@ -285,9 +285,9 @@ void output_sc_defines(void)
>  void output_sc32_defines(void)
>  {
>  	text("/* Linux 32-bit sigcontext offsets. */");
> -	offset("#define SC32_FPREGS     ", struct sigcontext32, sc_fpregs);
> -	offset("#define SC32_FPC_CSR    ", struct sigcontext32, sc_fpc_csr);
> -	offset("#define SC32_FPC_EIR    ", struct sigcontext32, sc_fpc_eir);
> +	offset("SC32_FPREGS", struct sigcontext32, sc_fpregs);
> +	offset("SC32_FPC_CSR", struct sigcontext32, sc_fpc_csr);
> +	offset("SC32_FPC_EIR", struct sigcontext32, sc_fpc_eir);
>  	linefeed;
>  }
>  #endif
> @@ -295,45 +295,45 @@ void output_sc32_defines(void)
>  void output_signal_defined(void)
>  {
>  	text("/* Linux signal numbers. */");
> -	constant("#define _SIGHUP     ", SIGHUP);
> -	constant("#define _SIGINT     ", SIGINT);
> -	constant("#define _SIGQUIT    ", SIGQUIT);
> -	constant("#define _SIGILL     ", SIGILL);
> -	constant("#define _SIGTRAP    ", SIGTRAP);
> -	constant("#define _SIGIOT     ", SIGIOT);
> -	constant("#define _SIGABRT    ", SIGABRT);
> -	constant("#define _SIGEMT     ", SIGEMT);
> -	constant("#define _SIGFPE     ", SIGFPE);
> -	constant("#define _SIGKILL    ", SIGKILL);
> -	constant("#define _SIGBUS     ", SIGBUS);
> -	constant("#define _SIGSEGV    ", SIGSEGV);
> -	constant("#define _SIGSYS     ", SIGSYS);
> -	constant("#define _SIGPIPE    ", SIGPIPE);
> -	constant("#define _SIGALRM    ", SIGALRM);
> -	constant("#define _SIGTERM    ", SIGTERM);
> -	constant("#define _SIGUSR1    ", SIGUSR1);
> -	constant("#define _SIGUSR2    ", SIGUSR2);
> -	constant("#define _SIGCHLD    ", SIGCHLD);
> -	constant("#define _SIGPWR     ", SIGPWR);
> -	constant("#define _SIGWINCH   ", SIGWINCH);
> -	constant("#define _SIGURG     ", SIGURG);
> -	constant("#define _SIGIO      ", SIGIO);
> -	constant("#define _SIGSTOP    ", SIGSTOP);
> -	constant("#define _SIGTSTP    ", SIGTSTP);
> -	constant("#define _SIGCONT    ", SIGCONT);
> -	constant("#define _SIGTTIN    ", SIGTTIN);
> -	constant("#define _SIGTTOU    ", SIGTTOU);
> -	constant("#define _SIGVTALRM  ", SIGVTALRM);
> -	constant("#define _SIGPROF    ", SIGPROF);
> -	constant("#define _SIGXCPU    ", SIGXCPU);
> -	constant("#define _SIGXFSZ    ", SIGXFSZ);
> +	constant("_SIGHUP", SIGHUP);
> +	constant("_SIGINT", SIGINT);
> +	constant("_SIGQUIT", SIGQUIT);
> +	constant("_SIGILL", SIGILL);
> +	constant("_SIGTRAP", SIGTRAP);
> +	constant("_SIGIOT", SIGIOT);
> +	constant("_SIGABRT", SIGABRT);
> +	constant("_SIGEMT", SIGEMT);
> +	constant("_SIGFPE", SIGFPE);
> +	constant("_SIGKILL", SIGKILL);
> +	constant("_SIGBUS", SIGBUS);
> +	constant("_SIGSEGV", SIGSEGV);
> +	constant("_SIGSYS", SIGSYS);
> +	constant("_SIGPIPE", SIGPIPE);
> +	constant("_SIGALRM", SIGALRM);
> +	constant("_SIGTERM", SIGTERM);
> +	constant("_SIGUSR1", SIGUSR1);
> +	constant("_SIGUSR2", SIGUSR2);
> +	constant("_SIGCHLD", SIGCHLD);
> +	constant("_SIGPWR", SIGPWR);
> +	constant("_SIGWINCH", SIGWINCH);
> +	constant("_SIGURG", SIGURG);
> +	constant("_SIGIO", SIGIO);
> +	constant("_SIGSTOP", SIGSTOP);
> +	constant("_SIGTSTP", SIGTSTP);
> +	constant("_SIGCONT", SIGCONT);
> +	constant("_SIGTTIN", SIGTTIN);
> +	constant("_SIGTTOU", SIGTTOU);
> +	constant("_SIGVTALRM", SIGVTALRM);
> +	constant("_SIGPROF", SIGPROF);
> +	constant("_SIGXCPU", SIGXCPU);
> +	constant("_SIGXFSZ", SIGXFSZ);
>  	linefeed;
>  }
>  
>  void output_irq_cpustat_t_defines(void)
>  {
>  	text("/* Linux irq_cpustat_t offsets. */");
> -	offset("#define IC_SOFTIRQ_PENDING ", irq_cpustat_t, __softirq_pending);
> -	size("#define IC_IRQ_CPUSTAT_T   ", irq_cpustat_t);
> +	offset("IC_SOFTIRQ_PENDING", irq_cpustat_t, __softirq_pending);
> +	size("IC_IRQ_CPUSTAT_T", irq_cpustat_t);
>  	linefeed;
>  }
> 

