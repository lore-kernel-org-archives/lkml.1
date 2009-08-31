Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbZHaKCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbZHaKCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZHaKCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:02:13 -0400
Received: from www.tglx.de ([62.245.132.106]:48806 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbZHaKCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:02:12 -0400
Date: Mon, 31 Aug 2009 12:01:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniele Calore <orkaan@orkaan.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Anvin <hpa@zytor.com>, Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: Re: [patch 2/3] x86/boot: adding hw subarch ID for Moorestown
In-Reply-To: <20090831131359.0cc90d4d@buddha>
Message-ID: <alpine.LFD.2.00.0908311121340.19335@localhost.localdomain>
References: <20090830134446.843410397@linutronix.de> <20090830134517.705603639@linutronix.de> <20090831131359.0cc90d4d@buddha>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Daniele Calore wrote:
> I think there is a typo (copy/paste error), see below:
>
> >  #endif /* _ASM_X86_BOOTPARAM_H */
> > Index: linux-2.6-tip/arch/x86/kernel/head_32.S
> > ===================================================================
> > --- linux-2.6-tip.orig/arch/x86/kernel/head_32.S
> > +++ linux-2.6-tip/arch/x86/kernel/head_32.S
> > @@ -157,6 +157,7 @@ subarch_entries:
> >  	.long default_entry		/* normal x86/PC */
> >  	.long lguest_entry		/* lguest hypervisor */
> >  	.long xen_entry			/* Xen hypervisor */
> > +	.long default_entry		/* Moorestown MID */
> 
> Typo: s/default_entry/mrst_entry

That's not a typo. :)

MRST will not go via an separate entry it uses the default one and we
evaluate the hardware_subarch id later in i386_start_kernel. That
change is just necessecary that a paravirt enabled kernel does not end
up in bad_subarch for the MRST id.

Thanks,

	tglx
