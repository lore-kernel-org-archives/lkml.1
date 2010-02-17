Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0BQQTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:19:52 -0500
Received: from new-admin0.cambridge.arm.com ([217.140.96.53]:56417 "EHLO
	new-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102Ab0BQQTu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:19:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: Re: Re: USB mass storage and ARM cache coherency
Date: Wed, 17 Feb 2010 16:19:16 -0000
Message-ID: <39E9E98DF632C2469FF2FC07853B70C6058006BA@ZIPPY.Emea.Arm.com>
In-Reply-To: <39E9E98DF632C2469FF2FC07853B70C6058006B7@ZIPPY.Emea.Arm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: Re: USB mass storage and ARM cache coherency
Thread-Index: Acqv7PNbN1CWlZHNQXmpf9j83lsT/Q==
References: <20100208065519.GE1290@ucw.cz> <1265628483.4020.63.camel@pc1117.cambridge.arm.com> <EAF47CD23C76F840A9E7FCE10091EFAB02C3CF7D50@dbde02.ent.ti.com> <201002160922.47072.oliver@neukum.org> <1266397543.16346.264.camel@pasglop> <39E9E98DF632C2469FF2FC07853B70C6058006B7@ZIPPY.Emea.Arm.com>
From: "Catalin Marinas" <Catalin.Marinas@arm.com>
To: <benh@kernel.crashing.org>
Cc: <mdharm-kernel@one-eyed-alien.net>, <linux-usb@vger.kernel.org>,
       <linux@arm.linux.org.uk>, <x0082077@ti.com>, <sshtylyov@ru.mvista.com>,
       <tom.leiming@gmail.com>, <bigeasy@linutronix.de>, <oliver@neukum.org>,
       <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
       <pavel@ucw.cz>, <greg@kroah.com>,
       <linux-arm-kernel@lists.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SORRY - one more message to apologise for the multiple reposts (and
automatically appended legal disclaimer). I've been moved to Exchange
2007 and trying to use Evolution + Exchange-MAPI. It looks like it went
terribly wrong.

Catalin


On Wed, 2010-02-17 at 15:40 +0000, Catalin Marinas wrote:
> On Wed, 2010-02-17 at 20:05 +1100, Benjamin Herrenschmidt wrote:
> > On Tue, 2010-02-16 at 09:22 +0100, Oliver Neukum wrote:
> > > This seems wrong to me. Buffers for control transfers may be
> > > transfered
> > > by DMA, so the caches must be flushed on architectures whose caches
> > > are not coherent with respect to DMA.
> > >=3D20
> > > Would you care to elaborate on the exact nature of the bug you are
> > > fixing?
> >=3D20
> > I missed part of this thread, so forgive me if I'm a bit off here, but
> > if the problem is indeed I$/D$ cache coherency vs. PIO transfers, then
> > this is a long solved issue on other archs such as ppc (and I _think_
> > sparc).
>=20
> The thread I started was indeed regarding I/D cache coherency and PIO.
> But it diverged into DMA issues a few days ago (should have been a new
> thread).
>=20
> > The way we do it, at least on powerpc which is PIPT, is to keep track o=
n
> > a per-page basis, whether a given page is clean for execution using
> > PG_arch1 bit. This bit is cleared when a new page is popped into the
> > page cache, and we clear it from flush_dcache_page() iirc (you may want
> > to dbl check I don't have the code at hand right now, or rather, I do
> > but I'm to lazy to look right now :-)
>=20
> We do the same on ARM. The problem with most (all) HCD drivers that do
> PIO is that they copy the data to the transfer buffer but there is no
> call in this driver to flush_dcache_page(). The upper mass storage or
> filesystem layers don't call this function either, so there isn't
> anything that would set the PG_arch1 bit.
>=20
> --=3D20
> Catalin
> --=20
> IMPORTANT NOTICE: The contents of this email and any attachments are
> confidential and may also be privileged. If you are not the intended
> recipient, please notify the sender immediately and do not disclose
> the contents to any other person, use it for any purpose, or store or
> copy the information in any medium.  Thank you.
>=20
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.
