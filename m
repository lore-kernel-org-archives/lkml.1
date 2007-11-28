Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbXK1Tqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbXK1Tqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbXK1TqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:46:24 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45507 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbXK1TqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:46:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, Ben Woodard <woodard@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>
	<200711271445.56792.ak@suse.de>
	<m1lk8jka8j.fsf@ebiederm.dsl.xmission.com>
	<474C64CB.7080004@redhat.com>
	<20071127194220.GG14887@hmsendeavour.rdu.redhat.com>
	<20071127200011.GA3703@redhat.com>
	<20071127222408.GH24223@one.firstfloor.org>
	<474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com>
	<20071128160206.GA21286@hmsendeavour.rdu.redhat.com>
	<20071128190525.GD3192@redhat.com>
Date: Wed, 28 Nov 2007 12:42:22 -0700
In-Reply-To: <20071128190525.GD3192@redhat.com> (Vivek Goyal's message of
	"Wed, 28 Nov 2007 14:05:25 -0500")
Message-ID: <m1d4tudun5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Ok. Got it. So in this case we route the interrupts directly through LAPIC
> and put LVT0 in ExtInt mode and IOAPIC is bypassed.
>
> I am looking at Intel Multiprocessor specification v1.4 and as per figure
> 3-3 on page 3-9, 8259 is connected to LINTIN0 line, which in turn is 
> connected to LINTIN0 pin on all processors. If that is the case, even in
> this mode, all the CPU should see the timer interrupts (which is coming
> from 8259)?

However things are implemented completely differently now.  I don't think
the coherent hypertransport domain of AMD processors actually routes
ExtINT interrupts to all cpus but instead one (the default route?) is
picked.

So I think for the kdump case we pretty much need to use an IOAPIC
in virtual wire mode for recent AMD systems.

For current Intel systems I believe either scenario still works.

> Can you print the LAPIC registers (print_local_APIC) during normal boot
> and during kdump boot and paste here?

It's worth a look.

I still think we need to just use apic mode at kernel startup, and
be done with it.

Eric
