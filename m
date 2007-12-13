Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbXLMPiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbXLMPiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbXLMPiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:38:01 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3834 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758526AbXLMPiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:38:00 -0500
Date: Thu, 13 Dec 2007 10:32:22 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       tglx@linutronix.de, mingo@redhat.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071213153222.GB4674@hmsreliant.think-freely.org>
References: <86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com> <20071211205955.GF10999@hmsreliant.think-freely.org> <20071212142132.GC4889@bingen.suse.de> <20071212155515.GA29735@hmsendeavour.rdu.redhat.com> <20071212160722.GD4889@bingen.suse.de> <m1prxbu2ah.fsf@ebiederm.dsl.xmission.com> <20071212202215.GB29735@hmsendeavour.rdu.redhat.com> <m1lk7ztx9p.fsf@ebiederm.dsl.xmission.com> <20071213143922.GA4674@hmsreliant.think-freely.org> <20071213151629.GB31269@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213151629.GB31269@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 04:16:29PM +0100, Andi Kleen wrote:
> On Thu, Dec 13, 2007 at 09:39:22AM -0500, Neil Horman wrote:
> > 
> > Ok, new patch attached, taking into account Andi's request for a cleaner method
> 
> Sorry for not noticing that earlier, but was there a specific reason this needs
> to be an early quirk at all? kexec can only happen after the standard quirks ran.
> I think it should be fine as a standard "late" quirk.
> 
> -Andi
> 
Early quirk seemed like the right thing to do to me.  Starting from boot up,
this (mis)configuration by the bios can mean that come cpus just don't get
interrupts.  I could imagine situations like serial console not working if the
serial port interrupt was routed to a cpu that used extended APIC id.  I've
never actually observed it happening, but making sure that all cpus were
eligible to get interrupts early in the boot process made sense to me.

Neil

> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
