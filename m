Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYHPXJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYHPXJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 19:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYHPXJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 19:09:29 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41549 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbYHPXJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:09:29 -0400
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
In-Reply-To: <86802c440808161517y1eaa5a4eo817b8a1bf75945be@mail.gmail.com>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	 <86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
	 <1218898238.3940.6.camel@localhost.localdomain>
	 <20080816163945.74d487e9@lxorguk.ukuu.org.uk>
	 <1218903209.3940.14.camel@localhost.localdomain>
	 <86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>
	 <1218918341.3940.49.camel@localhost.localdomain>
	 <86802c440808161334q75a7d019ofade0b6cabf3f74d@mail.gmail.com>
	 <1218919547.3940.57.camel@localhost.localdomain>
	 <86802c440808161517y1eaa5a4eo817b8a1bf75945be@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 18:09:22 -0500
Message-Id: <1218928162.3940.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 15:17 -0700, Yinghai Lu wrote:
> On Sat, Aug 16, 2008 at 1:45 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >> > What I still don't quite get is the benefit of large IRQ spaces ...
> >> > particularly if you encode things the system doesn't really need to know
> >> > in them.
> >>
> >> then set nr_irqs = nr_cpu_ids * NR_VECTORS))
> >> and count down for msi/msi-x?
> >
> > No, what I mean is that msis can trip directly to CPUs, so this is an
> > affinity thing (that MSI is directly bound to that CPU now), so in the
> > matrixed way we display this in show_interrupts() with the CPU along the
> > top and the IRQ down the side, it doesn't make sense to me to encode IRQ
> > affinity in the irq number again.   So it makes more sense to assign the
> > vectors based on both the irq number and the CPU affinity so that if the
> > PCI MSI for qla is assigned to CPU4 you can reassign it to CPU5 and so
> > on.
> 
> msi-x entry index, cpu_vector, irq number...
> 
> you want to different cpus have same vector?

Obviously I'm not communicating very well.  Your apparent assumption is
that irq number == vector.  What I'm saying is that's not what we've
done for individually vectored CPU interrupts in other architectures.
In those we did (cpu no, irq) == vector.  i.e. the affinity and the irq
number identify the vector.  For non-numa systems, this is effectively
what you're interested in doing anyway.  For numa systems, it just
becomes a sparse matrix.

James


