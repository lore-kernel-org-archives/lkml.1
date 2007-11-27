Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbXK0PAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbXK0PAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXK0PAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:00:22 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3172 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbXK0PAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:00:21 -0500
Date: Tue, 27 Nov 2007 09:48:56 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Neil Horman <nhorman@redhat.com>, hbabu@us.ibm.com, vgoyal@in.ibm.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071127144856.GC31376@hmsreliant.think-freely.org>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <200711271445.56792.ak@suse.de> <20071127142826.GB31376@hmsreliant.think-freely.org> <200711271543.11809.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711271543.11809.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 03:43:11PM +0100, Andi Kleen wrote:
> 
> > 
> > As for solution 2, that brings me to my previous question.  Is that really as
> > simple as just not moving the apic to legacy mode?  It would seem some
> > additional programming would be in order to route the interrupt in question to
> > the proper cpu.
> 
> The Linux kernel right now relies on being in legacy mode at bootup.
> So obviously kexec has to switch back to that.
> 
> Not relying on legacy mode would require moving APIC setup much earlier which
> is difficult because that's quite fragile. Longer term it might be a good
> idea though anyways -- at least the timer code was always fragile
> and eliminating one failure case and only ever running it in true
> APIC mode would be probably a good thing.
> 

So, it sounds to me then, like unless I'm willing to really re-write the APIC
setup code (which I don't feel qualified to do quite yet), that the immediate
solution would be to not rely on interrupts in legacy mode, which was according
to my understanding, what the use of the irqpoll command line option was
supposed to enable.  Any thoughts as to why that might not be working in this
case, or suggested tests to determine a cause there?

Thanks & Regards
Neil

> -Andi
