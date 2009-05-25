Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZEYMdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZEYMdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZEYMdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:33:16 -0400
Received: from www.tglx.de ([62.245.132.106]:43730 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZEYMdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:33:15 -0400
Date: Mon, 25 May 2009 14:32:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH resend4 2/3] itimers: fix periodic tics precision
In-Reply-To: <20090525132814.442877e5@dhcp-lab-109.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.0905251423490.3582@localhost.localdomain>
References: <20090522154339.06d30f0a@dhcp-lab-109.englab.brq.redhat.com> <alpine.LFD.2.00.0905221611380.3570@localhost.localdomain> <20090525132814.442877e5@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009, Stanislaw Gruszka wrote:
> @@ -904,6 +905,7 @@ void __init time_init(void)
>  	tb_ticks_per_usec = ppc_tb_freq / 1000000;
>  	tb_to_us = mulhwu_scale_factor(ppc_tb_freq, 1000000);
>  	calc_cputime_factors();
> +	cputime_one = jiffies_to_cputime(1);

  1) The variable name is misleading.

  2) The patch breaks all powerpc platforms which have
  CONFIG_VIRT_CPU_ACCOUNTING=n and ia64 with
  CONFIG_VIRT_CPU_ACCOUNTING=y

Thanks,

	tglx
