Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZCKK3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZCKK3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZCKK3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:29:19 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:47353 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZCKK3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wp0/bg6ab/qNDe70n1MQSGHvv1gSURCChT1TGr2hQzzOA7O41EgOngiln+ESLKYH6Z
         kxjZtxdHUjVrVO2WlTGVYZOmjbVsMN/sUBHgUHNi7Rd+v8Gh2snpeM9OatnUZANAzHPY
         qAqh/jhOre4dhZtFdB9pDbLxGQVo7Vd3gmIlA=
Date: Wed, 11 Mar 2009 11:29:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kallsyms, tracing: output more proper symbol name
Message-ID: <20090311102911.GB5243@nowhere>
References: <49B7863F.6020804@cn.fujitsu.com> <20090311094621.GA13543@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311094621.GA13543@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:46:21AM +0100, Ingo Molnar wrote:
> 
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > +#define VMLINUX_SYMBOL(_sym_) #_sym_
> > +
> > +static const char *hide_symbols[] = {
> > +	/* misc symbols */
> > +	"_text",
> > +	"_stext",
> > +	"_etext",
> > +	"_sinittext",
> > +	"_einittext",
> > +
> > +	/* symbols from include/asm-generic/vmlinux.lds.h */
> > +	VMLINUX_SYMBOL(__start_mcount_loc),
> > +	VMLINUX_SYMBOL(__stop_mcount_loc),
> > +	VMLINUX_SYMBOL(__start_annotated_branch_profile),
> > +	VMLINUX_SYMBOL(__stop_annotated_branch_profile),
> > +	VMLINUX_SYMBOL(__start_branch_profile),
> > +	VMLINUX_SYMBOL(__stop_branch_profile),
> > +	VMLINUX_SYMBOL(__start___markers),
> > +	VMLINUX_SYMBOL(__stop___markers),
> > +	VMLINUX_SYMBOL(__start___tracepoints),
> > +	VMLINUX_SYMBOL(__stop___tracepoints),
> > +	VMLINUX_SYMBOL(__start_rodata),
> > +	VMLINUX_SYMBOL(__start_pci_fixups_early),
> > +	VMLINUX_SYMBOL(__end_pci_fixups_early),
> > +	VMLINUX_SYMBOL(__start_pci_fixups_header),
> > +	VMLINUX_SYMBOL(__end_pci_fixups_header),
> > +	VMLINUX_SYMBOL(__start_pci_fixups_final),
> > +	VMLINUX_SYMBOL(__end_pci_fixups_final),
> > +	VMLINUX_SYMBOL(__start_pci_fixups_enable),
> > +	VMLINUX_SYMBOL(__end_pci_fixups_enable),
> > +	VMLINUX_SYMBOL(__start_pci_fixups_resume),
> > +	VMLINUX_SYMBOL(__end_pci_fixups_resume),
> > +	VMLINUX_SYMBOL(__start_pci_fixups_resume_early),
> > +	VMLINUX_SYMBOL(__end_pci_fixups_resume_early),
> > +	VMLINUX_SYMBOL(__start_pci_fixups_suspend),
> > +	VMLINUX_SYMBOL(__end_pci_fixups_suspend),
> > +	VMLINUX_SYMBOL(__start_builtin_fw),
> > +	VMLINUX_SYMBOL(__end_builtin_fw),
> > +	VMLINUX_SYMBOL(__start_rio_route_ops),
> > +	VMLINUX_SYMBOL(__end_rio_route_ops),
> > +	VMLINUX_SYMBOL(__start___ksymtab),
> > +	VMLINUX_SYMBOL(__stop___ksymtab),
> > +	VMLINUX_SYMBOL(__start___ksymtab_gpl),
> > +	VMLINUX_SYMBOL(__stop___ksymtab_gpl),
> > +	VMLINUX_SYMBOL(__start___ksymtab_unused),
> > +	VMLINUX_SYMBOL(__stop___ksymtab_unused),
> > +	VMLINUX_SYMBOL(__start___ksymtab_unused_gpl),
> > +	VMLINUX_SYMBOL(__stop___ksymtab_unused_gpl),
> > +	VMLINUX_SYMBOL(__start___ksymtab_gpl_future),
> > +	VMLINUX_SYMBOL(__stop___ksymtab_gpl_future),
> > +	VMLINUX_SYMBOL(__start___kcrctab),
> > +	VMLINUX_SYMBOL(__stop___kcrctab),
> > +	VMLINUX_SYMBOL(__start___kcrctab_gpl),
> > +	VMLINUX_SYMBOL(__stop___kcrctab_gpl),
> > +	VMLINUX_SYMBOL(__start___kcrctab_unused),
> > +	VMLINUX_SYMBOL(__stop___kcrctab_unused),
> > +	VMLINUX_SYMBOL(__start___kcrctab_unused_gpl),
> > +	VMLINUX_SYMBOL(__stop___kcrctab_unused_gpl),
> > +	VMLINUX_SYMBOL(__start___kcrctab_gpl_future),
> > +	VMLINUX_SYMBOL(__stop___kcrctab_gpl_future),
> > +	VMLINUX_SYMBOL(__start___param),
> > +	VMLINUX_SYMBOL(__stop___param),
> > +	VMLINUX_SYMBOL(__end_rodata),
> > +	VMLINUX_SYMBOL(__security_initcall_start),
> > +	VMLINUX_SYMBOL(__security_initcall_end),
> > +	VMLINUX_SYMBOL(__sched_text_start),
> > +	VMLINUX_SYMBOL(__sched_text_end),
> > +	VMLINUX_SYMBOL(__lock_text_start),
> > +	VMLINUX_SYMBOL(__lock_text_end),
> > +	VMLINUX_SYMBOL(__kprobes_text_start),
> > +	VMLINUX_SYMBOL(__kprobes_text_end),
> > +	VMLINUX_SYMBOL(__irqentry_text_start),
> > +	VMLINUX_SYMBOL(__irqentry_text_end),
> > +	VMLINUX_SYMBOL(__start___verbose_strings),
> > +	VMLINUX_SYMBOL(__stop___verbose_strings),
> > +	VMLINUX_SYMBOL(__start___verbose),
> > +	VMLINUX_SYMBOL(__stop___verbose),
> > +	VMLINUX_SYMBOL(__start___bug_table),
> > +	VMLINUX_SYMBOL(__stop___bug_table),
> > +	VMLINUX_SYMBOL(__tracedata_start),
> > +	VMLINUX_SYMBOL(__tracedata_end),
> > +	VMLINUX_SYMBOL(__start_notes),
> > +	VMLINUX_SYMBOL(__stop_notes),
> > +	VMLINUX_SYMBOL(__early_initcall_end),
> > +	VMLINUX_SYMBOL(__per_cpu_start),
> > +	VMLINUX_SYMBOL(__per_cpu_end)
> > +};
> 
> I like how you try to solve this at symbol table generation 
> time.
> 
> Instead of this hardcoded table, couldnt we use some more 
> flexible and more future-proof method? Such as ordering 
> same-address symbols by underscores:
> 
>   [same address]
> 
>   non-underscore symbols first        XYZ
>   single-undescroe symbols second     _XYZ
>   double-underscore symbols third     __XYZ
> 
> that way the scheme would be more or less self-maintaining as an 
> underscore already carries a "this is a special, internal 
> symbol" notion.
> 
> 	Ingo

Thanks Lai!
I didn't know how to solve properly this problem.
But indeed, the underscore priority sorted symbols seems to me a good
and scalable idea.

