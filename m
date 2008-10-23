Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYJWDgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYJWDgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 23:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYJWDfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 23:35:54 -0400
Received: from lobo.ruivo.org ([66.92.68.119]:41193 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbYJWDfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 23:35:54 -0400
Date: Wed, 22 Oct 2008 23:35:40 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] nmi watchdog: handle NMI_IO_APIC on nmi_watchdog
Message-ID: <20081023033540.GF28317@cathedrallabs.org>
References: <20080313180538.GC4620@cathedrallabs.org> <20080321114752.GA25225@elte.hu> <20080326152417.GE25854@cathedrallabs.org> <20080326182333.GA11187@elte.hu> <20081022215008.GE28317@cathedrallabs.org> <alpine.LFD.1.10.0810222329410.24509@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810222329410.24509@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > but this stops all NMIs, not just the IO-APIC generated ones, doesnt it? 
> > external NMIs would come by LINT1, no?
> 
>  Correct.
> 
> > after reading a lot and talking with Vivek, what I understood was that 8259 is
> > also connected to LINT0, so timer interrupts would be reported both in
> > IOAPIC and on LINT0. LVT0 is being configured on setup_nmi() to generate
> > an NMI. Also, the same timer interrupt would generate an regular interrupt
> > coming from IOAPIC. Clearing the APIC_DM_NMI on LVT0 would disable the
> > NMI delivery, but not the regular interrupt.
> > or am I missing something here?
> 
>  You are correct.  The routing of the 8254 timer interrupt may vary, but 
> the NMI watchdog it drives, if supported, always uses the LINT0 input of 
> all the local APICs.
thanks

>  You seem to be writing in reply to a very old thread -- please make sure 
> your concerns are still valid with current code.  For example we have an 
> implementation of __acpi_nmi_disable() now, which is exactly your proposed 
> one.
didn't noticed that, sorry.

-- 
Aristeu

