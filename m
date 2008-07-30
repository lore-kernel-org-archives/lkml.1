Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbYG3KJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbYG3KJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYG3KJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:09:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbYG3KJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:09:49 -0400
Date: Wed, 30 Jul 2008 12:09:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC [PATCH] x86: introduce nr_irqs for 64bit
Message-ID: <20080730100926.GA10431@elte.hu>
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807292138.41720.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807292138.41720.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> add DEFINE_DYN_ARRAY for dynamical array support
> 
> todo:
> 1. convert x86 32bit and other arch
> 2. nr_irqs auto probe via acpi_oem_check?
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

wonderful!

I have one main structural suggestion: could we please keep the NR_IRQS 
name, and just change it to dynamic on x86? NR_IRQS is used in 540 
places in the kernel, there's no point in touching all that code.

Also add an CONFIG_ARCH_HAS_DYNAMIC_NR_IRQS switch, define it in 
arch/x86/Kconfig and use it in include/linux/irq.h.

This will create far less migration pain than the widespread rename. 
That will also solve the "what about the other architectures" question.

	Ingo
