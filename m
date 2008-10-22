Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbYJVWpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbYJVWpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYJVWpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:45:43 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:36088 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYJVWpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:45:43 -0400
Date: Wed, 22 Oct 2008 23:45:40 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Aristeu Rozanski <aris@ruivo.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] nmi watchdog: handle NMI_IO_APIC on nmi_watchdog
In-Reply-To: <20081022215008.GE28317@cathedrallabs.org>
Message-ID: <alpine.LFD.1.10.0810222329410.24509@ftp.linux-mips.org>
References: <20080313180538.GC4620@cathedrallabs.org> <20080321114752.GA25225@elte.hu> <20080326152417.GE25854@cathedrallabs.org> <20080326182333.GA11187@elte.hu> <20081022215008.GE28317@cathedrallabs.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Aristeu Rozanski wrote:

> > > static void __acpi_nmi_disable(void *__unused)
> > > {       
> > >         apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
> > > }
> > > 
> > > do you think this isn't enough?
> > 
> > but this stops all NMIs, not just the IO-APIC generated ones, doesnt it? 
> external NMIs would come by LINT1, no?

 Correct.

> after reading a lot and talking with Vivek, what I understood was that 8259 is
> also connected to LINT0, so timer interrupts would be reported both in
> IOAPIC and on LINT0. LVT0 is being configured on setup_nmi() to generate
> an NMI. Also, the same timer interrupt would generate an regular interrupt
> coming from IOAPIC. Clearing the APIC_DM_NMI on LVT0 would disable the
> NMI delivery, but not the regular interrupt.
> or am I missing something here?

 You are correct.  The routing of the 8254 timer interrupt may vary, but 
the NMI watchdog it drives, if supported, always uses the LINT0 input of 
all the local APICs.

 You seem to be writing in reply to a very old thread -- please make sure 
your concerns are still valid with current code.  For example we have an 
implementation of __acpi_nmi_disable() now, which is exactly your proposed 
one.

  Maciej
