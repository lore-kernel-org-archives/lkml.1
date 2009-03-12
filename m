Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZCLKzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZCLKzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZCLKyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:54:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303AbZCLKyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:54:46 -0400
Date: Thu, 12 Mar 2009 11:54:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, jeremy.fitzhardinge@citrix.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: fix HYPERVISOR_update_descriptor()
Message-ID: <20090312105426.GC30204@elte.hu>
References: <49B8F3D4.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8F3D4.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> ---
>  arch/x86/include/asm/xen/hypercall.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-2.6.29-rc7/arch/x86/include/asm/xen/hypercall.h	2009-03-11 17:52:10.000000000 +0100
> +++ 2.6.29-rc7-x86_64-xen-update-descr/arch/x86/include/asm/xen/hypercall.h	2009-02-13 11:41:39.000000000 +0100
> @@ -296,6 +296,8 @@ HYPERVISOR_get_debugreg(int reg)
>  static inline int
>  HYPERVISOR_update_descriptor(u64 ma, u64 desc)
>  {
> +	if (sizeof(u64) == sizeof(long))
> +		return _hypercall2(int, update_descriptor, ma, desc);
>  	return _hypercall4(int, update_descriptor, ma, ma>>32, desc, desc>>32);

missing changelog and Impact line.

	Ingo
