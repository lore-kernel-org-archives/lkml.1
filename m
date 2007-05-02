Return-Path: <linux-kernel-owner+w=401wt.eu-S2992716AbXEBEjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992716AbXEBEjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992724AbXEBEjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:39:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992716AbXEBEjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:39:31 -0400
Date: Wed, 2 May 2007 01:44:24 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: Mark Lord <lkml@rtr.ca>
Cc: ak@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unnecessary irq disabling
Message-ID: <20070502044424.GA7049@redhat.com>
References: <20070501213050.GD6119@redhat.com> <4637D459.2040502@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637D459.2040502@rtr.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 07:59:21PM -0400, Mark Lord wrote:
> Glauber de Oliveira Costa wrote:
> >RR asks us if it is really necessary to disable interrupts in
> >setup_secondary_APIC_clock(). The answer is no, since setup_APIC_timer()
> >starts by saving irq flags, which also disables them.
> >
> >Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> >
> >--- a/arch/x86_64/kernel/apic.c
> >+++ b/arch/x86_64/kernel/apic.c
> >@@ -875,9 +875,7 @@ void __init setup_boot_APIC_clock (void)
> > 
> > void __cpuinit setup_secondary_APIC_clock(void)
> > {
> >-	local_irq_disable(); /* FIXME: Do we need this? --RR */
> > 	setup_APIC_timer(calibration_result);
> >-	local_irq_enable();
> > }
> > 
> > void disable_APIC_timer(void)
> 
> Okay, I'll bite:  before the patch, this code would exit
> with interrupts *enabled*, always.   Now it does not.
> 
yeah, you have a point. The disable is unnecessary, but maybe
the enable is not. However,

> What does that break, or was it already broken and this fixes it?
I think neither. This function is only called at early bootup,
(start_secondary() ), and most of its callees have interrupts off anyway.
But maybe we do lose something. Andi, do you have a word on this?

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"
