Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZCKJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZCKJrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 05:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZCKJrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 05:47:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36737 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbZCKJrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:47:09 -0400
Date: Wed, 11 Mar 2009 10:46:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kallsyms, tracing: output more proper symbol name
Message-ID: <20090311094621.GA13543@elte.hu>
References: <49B7863F.6020804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B7863F.6020804@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> +#define VMLINUX_SYMBOL(_sym_) #_sym_
> +
> +static const char *hide_symbols[] = {
> +	/* misc symbols */
> +	"_text",
> +	"_stext",
> +	"_etext",
> +	"_sinittext",
> +	"_einittext",
> +
> +	/* symbols from include/asm-generic/vmlinux.lds.h */
> +	VMLINUX_SYMBOL(__start_mcount_loc),
> +	VMLINUX_SYMBOL(__stop_mcount_loc),
> +	VMLINUX_SYMBOL(__start_annotated_branch_profile),
> +	VMLINUX_SYMBOL(__stop_annotated_branch_profile),
> +	VMLINUX_SYMBOL(__start_branch_profile),
> +	VMLINUX_SYMBOL(__stop_branch_profile),
> +	VMLINUX_SYMBOL(__start___markers),
> +	VMLINUX_SYMBOL(__stop___markers),
> +	VMLINUX_SYMBOL(__start___tracepoints),
> +	VMLINUX_SYMBOL(__stop___tracepoints),
> +	VMLINUX_SYMBOL(__start_rodata),
> +	VMLINUX_SYMBOL(__start_pci_fixups_early),
> +	VMLINUX_SYMBOL(__end_pci_fixups_early),
> +	VMLINUX_SYMBOL(__start_pci_fixups_header),
> +	VMLINUX_SYMBOL(__end_pci_fixups_header),
> +	VMLINUX_SYMBOL(__start_pci_fixups_final),
> +	VMLINUX_SYMBOL(__end_pci_fixups_final),
> +	VMLINUX_SYMBOL(__start_pci_fixups_enable),
> +	VMLINUX_SYMBOL(__end_pci_fixups_enable),
> +	VMLINUX_SYMBOL(__start_pci_fixups_resume),
> +	VMLINUX_SYMBOL(__end_pci_fixups_resume),
> +	VMLINUX_SYMBOL(__start_pci_fixups_resume_early),
> +	VMLINUX_SYMBOL(__end_pci_fixups_resume_early),
> +	VMLINUX_SYMBOL(__start_pci_fixups_suspend),
> +	VMLINUX_SYMBOL(__end_pci_fixups_suspend),
> +	VMLINUX_SYMBOL(__start_builtin_fw),
> +	VMLINUX_SYMBOL(__end_builtin_fw),
> +	VMLINUX_SYMBOL(__start_rio_route_ops),
> +	VMLINUX_SYMBOL(__end_rio_route_ops),
> +	VMLINUX_SYMBOL(__start___ksymtab),
> +	VMLINUX_SYMBOL(__stop___ksymtab),
> +	VMLINUX_SYMBOL(__start___ksymtab_gpl),
> +	VMLINUX_SYMBOL(__stop___ksymtab_gpl),
> +	VMLINUX_SYMBOL(__start___ksymtab_unused),
> +	VMLINUX_SYMBOL(__stop___ksymtab_unused),
> +	VMLINUX_SYMBOL(__start___ksymtab_unused_gpl),
> +	VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl),
> +	VMLINUX_SYMBOL(__start___ksymtab_gpl_future),
> +	VMLINUX_SYMBOL(__stop___ksymtab_gpl_future),
> +	VMLINUX_SYMBOL(__start___kcrctab),
> +	VMLINUX_SYMBOL(__stop___kcrctab),
> +	VMLINUX_SYMBOL(__start___kcrctab_gpl),
> +	VMLINUX_SYMBOL(__stop___kcrctab_gpl),
> +	VMLINUX_SYMBOL(__start___kcrctab_unused),
> +	VMLINUX_SYMBOL(__stop___kcrctab_unused),
> +	VMLINUX_SYMBOL(__start___kcrctab_unused_gpl),
> +	VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl),
> +	VMLINUX_SYMBOL(__start___kcrctab_gpl_future),
> +	VMLINUX_SYMBOL(__stop___kcrctab_gpl_future),
> +	VMLINUX_SYMBOL(__start___param),
> +	VMLINUX_SYMBOL(__stop___param),
> +	VMLINUX_SYMBOL(__end_rodata),
> +	VMLINUX_SYMBOL(__security_initcall_start),
> +	VMLINUX_SYMBOL(__security_initcall_end),
> +	VMLINUX_SYMBOL(__sched_text_start),
> +	VMLINUX_SYMBOL(__sched_text_end),
> +	VMLINUX_SYMBOL(__lock_text_start),
> +	VMLINUX_SYMBOL(__lock_text_end),
> +	VMLINUX_SYMBOL(__kprobes_text_start),
> +	VMLINUX_SYMBOL(__kprobes_text_end),
> +	VMLINUX_SYMBOL(__irqentry_text_start),
> +	VMLINUX_SYMBOL(__irqentry_text_end),
> +	VMLINUX_SYMBOL(__start___verbose_strings),
> +	VMLINUX_SYMBOL(__stop___verbose_strings),
> +	VMLINUX_SYMBOL(__start___verbose),
> +	VMLINUX_SYMBOL(__stop___verbose),
> +	VMLINUX_SYMBOL(__start___bug_table),
> +	VMLINUX_SYMBOL(__stop___bug_table),
> +	VMLINUX_SYMBOL(__tracedata_start),
> +	VMLINUX_SYMBOL(__tracedata_end),
> +	VMLINUX_SYMBOL(__start_notes),
> +	VMLINUX_SYMBOL(__stop_notes),
> +	VMLINUX_SYMBOL(__early_initcall_end),
> +	VMLINUX_SYMBOL(__per_cpu_start),
> +	VMLINUX_SYMBOL(__per_cpu_end)
> +};

I like how you try to solve this at symbol table generation 
time.

Instead of this hardcoded table, couldnt we use some more 
flexible and more future-proof method? Such as ordering 
same-address symbols by underscores:

  [same address]

  non-underscore symbols first        XYZ
  single-undescroe symbols second     _XYZ
  double-underscore symbols third     __XYZ

that way the scheme would be more or less self-maintaining as an 
underscore already carries a "this is a special, internal 
symbol" notion.

	Ingo
