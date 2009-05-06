Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbZEFPti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbZEFPti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbZEFPt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:49:27 -0400
Received: from outbound-mail-152.bluehost.com ([67.222.39.32]:45449 "HELO
	outbound-mail-152.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753949AbZEFPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:49:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=p0/7cypRuEnAO4H0y6hxtuWH8jamOxe1Jc/s0c5VHSUXbOmnnaDscdKQlajkkQgZLllYrp/B7+rrwq9USrQcqaySnPJaprMo9klK5w8AhNTV4M7lU8bVjANG1aEHdee4;
Date: Wed, 6 May 2009 08:48:45 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/4] x86/pci: update pirq_enable_irq to setup io apic
 routing -v2
Message-ID: <20090506084845.48e0818c@hobbes>
In-Reply-To: <20090506124558.GC19541@elte.hu>
References: <49F8B2D9.3080903@kernel.org>
	<49F9600A.7000705@kernel.org>
	<49FC8696.4020603@kernel.org>
	<20090506124558.GC19541@elte.hu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 14:45:58 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > so we could set io apic routing only when enable device irq.
> > 
> > also could make setup_IO_APIC_irqs and setup_ioapic_dest only handle
> > first ioapic...
> > 
> > v2: remove one one not needed style change.
> >     merge the patch only setup io_apic for acpi on in
> > setup_IO_APIC_irqs
> > 
> > [ Impact: make mptable irq enable more like acpi is used, and
> > numa_irq_desc could get correct node when acpi=off ]
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > ---
> >  arch/x86/kernel/apic/io_apic.c |  148
> > ++++++++++++++++++++---------------------
> > arch/x86/pci/irq.c             |   84 ++++++++--------------- 2
> > files changed, 103 insertions(+), 129 deletions(-)
> 
> Ok, i guess this makes sense with acpi-less bootup modes.
> 
> There's hefty impact on io_apic.c and pci/irq.c as well. The io-apic 
> code already has a fair amount of changes queued up. Jesse: do you 
> have pci/irq.c changes queued up? If you agree with the patch, how 
> should we handle this?

No I don't have anything recent...  and since this stuff is intertwined
with the io_apic changes I'm fine with it going through you guys.

-- 
Jesse Barnes, Intel Open Source Technology Center
