Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYKFUoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYKFUoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYKFUn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:43:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYKFUn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:43:59 -0500
Date: Thu, 6 Nov 2008 21:43:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ivan Vecera <ivecera@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, nhorman@redhat.com, jmarchan@redhat.com
Subject: Re: [PATCH] x86: call machine_shutdown and stop all CPUs in
	native_machine_halt
Message-ID: <20081106204351.GG3578@elte.hu>
References: <1224504787-11403-1-git-send-email-ivecera@redhat.com> <20081020160058.GB22779@elte.hu> <48FDCCCB.2080103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FDCCCB.2080103@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ivan Vecera <ivecera@redhat.com> wrote:

> Ingo Molnar wrote:
> > the code in arch/x86/kernel/smp.c::stop_this_cpu() is very similar to 
> > this and could be shared. You could move the stop_this_cpu() function to 
> > arch/x86/kernel/process.c (out of smp.c), so that it can be used by 
> > reboot.c.
> > 
> Yes, this make sense. Here is the patch.

looks good. One small detail:

> +#ifdef CONFIG_X86_LOCAL_APIC
> +	disable_local_APIC();
> +#endif

could you please avoid this #ifdef by putting an inline void function 
for disable_local_APIC() into arch/x86/include/asm/apic.h for the 
!CONFIG_X86_LOCAL_APIC case?

	Ingo
