Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYHSTWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYHSTWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbYHSTWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:22:15 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:45624 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757443AbYHSTWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:22:14 -0400
Subject: Re: [PATCH 1/2] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector
	0x6 cpu 1'
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Yinghai Lu <yhlu.kernel@gmail.com>, Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alex Nixon <alex.nixon@citrix.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440808181836v7e1f12dbrf059c1be23f155dd@mail.gmail.com>
References: <48A976E6.40906@citrix.com> <48A9EBBD.5010509@goop.org>
	 <86802c440808181836v7e1f12dbrf059c1be23f155dd@mail.gmail.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 19 Aug 2008 12:22:12 -0700
Message-Id: <1219173732.13032.43.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 18:36 -0700, Yinghai Lu wrote:
> On Mon, Aug 18, 2008 at 2:38 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Alex Nixon wrote:
> >> From: Alex Nixon <alex.nixon@citrix.com>
> >> Date: Mon, 18 Aug 2008 12:56:48 +0100
> >> Subject: [PATCH] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector 0x6 cpu 1'
> >>
> >> Following commit 9c3f2468d8339866d9ef6a25aae31a8909c6be0d, do_IRQ() looks up the IRQ number in the per-cpu variable vector_irq.
> >>
> >> This commit makes Xen initialise an identity vector_irq map for both X86_32 and X86_64.
> >>
> >
> > Thanks Alex.
> >
> > Ingo, please apply.
> >
> > Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >
> >> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> >> ---
> >>  arch/x86/xen/irq.c |    2 --
> >>  1 files changed, 0 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
> >> index 28b85ab..bb04260 100644
> >> --- a/arch/x86/xen/irq.c
> >> +++ b/arch/x86/xen/irq.c
> >> @@ -21,7 +21,6 @@ void xen_force_evtchn_callback(void)
> >>
> >>  static void __init __xen_init_IRQ(void)
> >>  {
> >> -#ifdef CONFIG_X86_64
> >>       int i;
> >>
> >>       /* Create identity vector->irq map */
> >> @@ -31,7 +30,6 @@ static void __init __xen_init_IRQ(void)
> >>               for_each_possible_cpu(cpu)
> >>                       per_cpu(vector_irq, cpu)[i] = i;
> >>       }
> >> -#endif       /* CONFIG_X86_64 */
> >>
> >>       xen_init_IRQ();
> >>  }
> >>
> 
> 
> Rusty,
> can you check tip/master with lguest?  wonder you need to do sth for lguest too.
> we are making 32 bit support per_cpu vector like 64 bit
> 
> also alok, can you check vmi etc...

Yes it crashes VMI too, i will get down to debug this maybe later in the
day. 
Thanks YH, for bringing this to my attention. 

Alok.


