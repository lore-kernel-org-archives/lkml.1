Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0CCFk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:40:29 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41379 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596Ab0CCFk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:40:28 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, catalin.marinas@arm.com,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org,
       linux@arm.linux.org.uk, greg@kroah.com, x0082077@ti.com,
       sshtylyov@ru.mvista.com, bigeasy@linutronix.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       santosh.shilimkar@ti.com, pavel@ucw.cz, tom.leiming@gmail.com,
       linux-arm-kernel@lists.infradead.org
In-Reply-To: <1267593032.16696.1.camel@pasglop>
References: <20100302211049V.fujita.tomonori@lab.ntt.co.jp>
	 <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com>
	 <1267572594.2173.25.camel@pasglop>
	 <20100303124624Z.fujita.tomonori@lab.ntt.co.jp>
	 <1267593032.16696.1.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 11:10:09 +0530
Message-ID: <1267594809.4383.27.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 16:10 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2010-03-03 at 12:47 +0900, FUJITA Tomonori wrote:
> > The ways to improve the approach (introducing PG_arch_2 or marking a
> > page clean on dma_unmap_* with DMA_FROM_DEVICE like ia64 does) is up
> > to architectures. 
> 
> How does the above work ? IE, the dma unmap will flush the D side but
> not the I side ... or is the ia64 flush primitive magic enough to do
> both ?

The point is that in a well regulated system, the I cache shouldn't need
extra flushing in the kernel.  We should only be faulting in R-X pages.
If we're operating on RWX pages (i.e. self modifying code), it's the job
of userspace to keep I/D coherency.

So the only case the kernel needs to worry about is the R-X fault case
for executable text code.

James


