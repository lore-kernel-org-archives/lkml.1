Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYC1U2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYC1U2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYC1U21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:28:27 -0400
Received: from gw.goop.org ([64.81.55.164]:49428 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbYC1U20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:28:26 -0400
Message-ID: <47ED54CE.7000007@goop.org>
Date: Fri, 28 Mar 2008 13:27:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com
Subject: Re: [PATCH 07/12] Xen: Make events.c portable for ia64/xen support.
References: <12067044183207-git-send-email-yamahata@valinux.co.jp> <12067044180-git-send-email-yamahata@valinux.co.jp>
In-Reply-To: <12067044180-git-send-email-yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> +/* macro to avoid header inclusion dependncy hell */
> +#define xen_irqs_disabled(regs)	(!((regs)->flags & X86_EFLAGS_IF))
>   

This seems pretty generic.  Is there no suitable existing function?  
Could irqs_disabled_flags() be pressed into service?  I guess it depends 
on how ia64 (and other architectures) can get the saved flags state from 
the interrupt context.

> +
> +/* macro to avoid header inclusion dependncy hell */
> +#define xen_do_IRQ(irq, regs)			\
> +	do {					\
> +		(regs)->orig_ax = ~(irq);	\
> +		do_IRQ(regs);			\
> +	} while (0)
>   

It's not possible to put this somewhere it could be an inline function?  
It might be better to make it an out of line function then.

    J
