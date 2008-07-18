Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbYGRVLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbYGRVLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYGRVLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:11:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41096 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbYGRVLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:11:37 -0400
Date: Fri, 18 Jul 2008 23:03:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080718210348.GB24373@elte.hu>
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl> <20080718105259.GY6875@elte.hu> <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com> <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > git merge tip/x86/x2apic
> CONFLICT (content): Merge conflict in arch/x86/kernel/Makefile
> CONFLICT (content): Merge conflict in arch/x86/kernel/paravirt.c
> CONFLICT (content): Merge conflict in arch/x86/kernel/smpboot.c
> CONFLICT (content): Merge conflict in arch/x86/kernel/vmi_32.c
> CONFLICT (content): Merge conflict in arch/x86/xen/enlighten.c
> CONFLICT (content): Merge conflict in include/asm-x86/apic.h
> CONFLICT (content): Merge conflict in include/asm-x86/paravirt.h

that's due to the changes in tip/x86/apic and in tip/x86/uv.

ok, i've just merged x86/apic into x86/x2apic and x86/uv as well, and 
pushed out the result.

Note: it's a first raw merge and completely untested. It will now merge 
cleanly into tip/master. There are probably a few details missing.

The smp-alternatives based trick that Maciej applied for write-around 
can stay in the mem_apic_* methods - modern APICs do not need any 
workaround in this area and can just use apic_ops.

> also please apply
> Fix VMI apic_ops.
> from Suresh
> 
> to x2apic

done.

	Ingo
