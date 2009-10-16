Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbZJPMjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbZJPMjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbZJPMjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:39:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53850 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759062AbZJPMjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:39:48 -0400
Date: Fri, 16 Oct 2009 14:38:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: x86, amd: Get multi-node CPU info from NodeId MSR instead of
	PCI config space
Message-ID: <20091016123853.GA15393@elte.hu>
References: <20091016122229.GB8387@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016122229.GB8387@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <herrmann.der.user@googlemail.com> wrote:

> Use newly introduced NodeId MSR to get NodeId and number of nodes per 
> processor.

What will happen on CPUs that dont have this MSR and got this info from 
the PCI config space:

>  static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
>  {
> -#ifdef CONFIG_PCI
> -	u32 t, cpn;
> -	u8 n, n_id;
>  	int cpu = smp_processor_id();
>  
>  	/* fixup topology information only once for a core */
>  	if (cpu_has(c, X86_FEATURE_AMD_DCM))
>  		return;
>  
> -	/* check for multi-node processor on boot cpu */
> -	t = read_pci_config(0, 24, 3, 0xe8);
> -	if (!(t & (1 << 29)))
>  		return;
>  
>  	set_cpu_cap(c, X86_FEATURE_AMD_DCM);

are there any such CPUs? I.e. we want to know the effect of this patch 
on various models of AMD CPUs - is the change really .32 safe? Does it 
solve any problem that makes it .32 material versus being for .33?

	Ingo
