Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbXJ0OBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbXJ0OBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 10:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbXJ0OB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 10:01:26 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:54238 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751560AbXJ0OBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 10:01:25 -0400
Date: Sat, 27 Oct 2007 15:58:07 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Shannon Nelson" <shannon.nelson@intel.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] DMA: Correct invalid assumptions in the Kconfig text
Message-ID: <20071027155807.73976b0a@siona>
In-Reply-To: <e9c3a7c20710261002m1c5063bdqa040834c30d9ca8a@mail.gmail.com>
References: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
	<e9c3a7c20710240855j7bf1f0a6qa1d11af3a12910e5@mail.gmail.com>
	<20071024201616.02f87b20@siona>
	<20071025113240.466b69ba@siona>
	<e9c3a7c20710261002m1c5063bdqa040834c30d9ca8a@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 10:02:24 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:
> On 10/25/07, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > static irqreturn_t iop_adma_err_handler(int irq, void *data)
> > {
> >         (...)
> >
> >         BUG();
> > }
> >
> > That's a panic waiting to happen, isn't it?
> 
> Yes, and it should have a comment, because for now this is deliberate.
>  This was primarily driven by the fact that MD has no way of
> recovering from hardware errors during software-memcpy or
> software-xor_blocks so there was no where to plug-in
> accelerated-memcpy/xor error recovery.  I can foresee other clients
> wanting to have this information reported but async_tx based clients
> are supposed to be blissfully unaware of under the covers hardware
> acceleration.

Yeah, it's a pretty serious bug if the DMA engine flags an error. But
wouldn't it be better to BUG() in the context of the caller? That way,
you won't necessarily bring down the whole system.

> One idea is to pass an error-pointer as the parameter to callback
> routines, but that would hamper the client's ability to recover the
> context of the failure...

It's probably a good idea to dump the descriptors at some point. I
don't think the client has many options to deal with such failures
other than reset something or kill something, but if the client gets
notified, it at least has some chance of recovering.

Håvard
