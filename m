Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbZDBWQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbZDBWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZDBWQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:16:49 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:53941 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZDBWQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:16:48 -0400
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 18:16:48 EDT
Subject: Re: [Lguest] [PATCH 4/5] lguest: use KVM hypercalls
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org, virtualization@lists.osdl.org,
       Matias Zabaljauregui <zabaljaureguiatgmail.com@ozlabs.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200903271022.38244.rusty@rustcorp.com.au>
References: <200903271022.38244.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Apr 2009 23:55:24 +0200
Message-Id: <1238709324.5823.8.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fre, 27 03 2009 kl. 10:22 +1030, skrev Rusty Russell:
> From: Matias Zabaljauregui <zabaljauregui@gmail.com>
> 
> Impact: cleanup
> 
> This patch allow us to use KVM hypercalls

Something has broken in relation to this change. I'm not sure it is this
change itself or one following, but I get the following error when using
lguest:

lguest: unhandled trap 6 at 0x418726 (0x0)

> +static bool is_hypercall(struct lg_cpu *cpu)
> +{
> +	u8 insn[3];
> +
> +	/* This must be the Guest kernel trying to do something.
> +	 * The bottom two bits of the CS segment register are the privilege
> +	 * level. */
> +	if ((cpu->regs->cs & 3) != GUEST_PL)
> +		return false;
> +
> +	/* Is it a vmcall? */
> +	__lgread(cpu, insn, guest_pa(cpu, cpu->regs->eip), sizeof(insn));

I've put a printk for insn here that shows up twice. The first time insn
holds the values below, and the second time it holds the values that are
patched in by rewrite_hypercall.

> +	return insn[0] == 0x0f && insn[1] == 0x01 && insn[2] == 0xc1;
> +}

I'll investigate further tomorrow, unless someone is already on top of
this. My kernel is 2.6.29-07100-g833bb30 btw.


Simon Holm Thøgersen

