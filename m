Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYHPUtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYHPUtK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbYHPUpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:45:55 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33105 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757670AbYHPUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:45:54 -0400
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
In-Reply-To: <86802c440808161334q75a7d019ofade0b6cabf3f74d@mail.gmail.com>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	 <86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
	 <1218898238.3940.6.camel@localhost.localdomain>
	 <20080816163945.74d487e9@lxorguk.ukuu.org.uk>
	 <1218903209.3940.14.camel@localhost.localdomain>
	 <86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>
	 <1218918341.3940.49.camel@localhost.localdomain>
	 <86802c440808161334q75a7d019ofade0b6cabf3f74d@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 15:45:46 -0500
Message-Id: <1218919547.3940.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 13:34 -0700, Yinghai Lu wrote:
> On Sat, Aug 16, 2008 at 1:25 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >> but msix current cached irq number, and it only use 16bit to store
> >> unsigned int irq., and later cards will call request_irq with
> >> truncated irq_number...card will fallback to MSI or INTa
> >
> > OK, sorry, I get that there's a bug in the msix_entry ... if it's going
> > to assign an irq to it, it should at least be the same type as irq.
> 
> good. for 2.6.27?

Well, given that 2.6.27 uses a compact irq space, probably not ...
unless there's actually something in 2.6.27 that trips it?

> >
> > What I still don't quite get is the benefit of large IRQ spaces ...
> > particularly if you encode things the system doesn't really need to know
> > in them.
> 
> then set nr_irqs = nr_cpu_ids * NR_VECTORS))
> and count down for msi/msi-x?

No, what I mean is that msis can trip directly to CPUs, so this is an
affinity thing (that MSI is directly bound to that CPU now), so in the
matrixed way we display this in show_interrupts() with the CPU along the
top and the IRQ down the side, it doesn't make sense to me to encode IRQ
affinity in the irq number again.   So it makes more sense to assign the
vectors based on both the irq number and the CPU affinity so that if the
PCI MSI for qla is assigned to CPU4 you can reassign it to CPU5 and so
on.

James


