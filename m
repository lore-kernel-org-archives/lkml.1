Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYINPlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYINPlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbYINPlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:41:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60304 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbYINPlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:41:09 -0400
Date: Sun, 14 Sep 2008 17:40:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dean Nelson <dcn@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       jeremy@goop.org, rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 4/4] switch non-standard SYSCALL_VECTOR allocation to use
	vector_irq[]
Message-ID: <20080914154046.GL29290@elte.hu>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <20080911152940.GE13655@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911152940.GE13655@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dean Nelson <dcn@sgi.com> wrote:

> Replace the current use of used_vectors[] for the allocation of a 
> non-standard SYSCALL_VECTOR by also using the per_cpu variable 
> vector_irq[].

this:

> Index: linux/arch/x86/kernel/traps_32.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/traps_32.c	2008-09-10 14:25:23.000000000 -0500
> +++ linux/arch/x86/kernel/traps_32.c	2008-09-10 14:25:28.000000000 -0500

> +	ret = __grab_irq_vector(NON_IRQ_DESC, SYSCALL_VECTOR,
> +				&cpu_possible_map);

break the build if IO_APIC is disabled. (see previous mail)

	Ingo
