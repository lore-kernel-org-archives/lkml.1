Return-Path: <linux-kernel-owner+w=401wt.eu-S1765961AbXHHKCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765961AbXHHKCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759473AbXHHKCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:02:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:48281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857AbXHHKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:02:03 -0400
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 3/25] [PATCH] irq_flags / halt routines
Date: Wed, 8 Aug 2007 11:14:19 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com>
In-Reply-To: <11865467662182-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081114.21260.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +#ifdef CONFIG_PARAVIRT
> +#include <asm/paravirt.h>
> +#  ifdef CONFIG_X86_VSMP
> +static inline int raw_irqs_disabled_flags(unsigned long flags)
> +{
> +	return !(flags & X86_EFLAGS_IF) || (flags & X86_EFLAGS_AC);
> +}
> +#  else
> +static inline int raw_irqs_disabled_flags(unsigned long flags)
> +{
> +	return !(flags & X86_EFLAGS_IF);
> +}
> +#  endif

You should really turn the vsmp special case into a paravirt client first 
instead of complicating all this even more. 

> +#ifndef CONFIG_PARAVIRT
> +#define raw_safe_halt	native_raw_safe_halt
> +#define halt		native_halt
> +#endif /* ! CONFIG_PARAVIRT */

This seems inconsistent

-Andi

