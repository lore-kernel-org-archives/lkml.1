Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbXLLOVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbXLLOVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXLLOVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:21:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:54351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbXLLOVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:21:38 -0500
Date: Wed, 12 Dec 2007 15:21:32 +0100
From: Andi Kleen <ak@suse.de>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ben Woodard <woodard@redhat.com>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071212142132.GC4889@bingen.suse.de>
References: <m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com> <20071211034349.GA3635@localhost.localdomain> <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com> <20071211143910.GA10999@hmsreliant.think-freely.org> <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com> <20071211182254.GB10999@hmsreliant.think-freely.org> <m1ejdtysqd.fsf@ebiederm.dsl.xmission.com> <20071211192434.GD10999@hmsreliant.think-freely.org> <86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com> <20071211205955.GF10999@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211205955.GF10999@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	htcfg = read_pci_config(num, slot, func, 0x68);
> +	if (htcfg & (1 << 18)) {	
> +		printk(KERN_INFO "Detected use of extended apic ids on hypertransport bus\n");
> +		if ((htcfg & (1 << 17)) == 0) {
> +			printk(KERN_INFO "Enabling hypertransport extended apic interrupt broadcast\n");
> +			printk(KERN_INFO "Note this is a bios bug, please contact your hw vendor\n");

I'm not convinced the message is correct. e.g. on a system with only a dual core not enabling
that is fine, but the extended IDs might be still set.

>  #endif /* CONFIG_ACPI */
>  
> -static void __init nvidia_bugs(void)
> +static void __init nvidia_bugs(int num, int slot, int func)
>  {
> +	static int fix_applied = 0;
> +
> +	if (fix_applied++)
> +		return;

This looks like the wrong place to do this. Better add a flag or something
in the structure. Dito others.

Also while not a problem here in general it's bad style to add potential
wrapping bugs like this. Never use ++ for flags.

-Andi
