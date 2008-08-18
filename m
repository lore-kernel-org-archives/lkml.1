Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYHRWEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYHRWEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYHRWEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:04:30 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55758 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbYHRWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:04:29 -0400
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
In-Reply-To: <m17iaexai3.fsf@frodo.ebiederm.org>
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
	 <1218928162.3940.62.camel@localhost.localdomain>
	 <m14p5i2iwx.fsf@frodo.ebiederm.org>
	 <1219093158.3261.70.camel@localhost.localdomain>
	 <m17iaexai3.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 17:04:21 -0500
Message-Id: <1219097061.3261.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 14:45 -0700, Eric W. Biederman wrote:
> > Yes, agree with the above except the static irq number ... although once
> > that's hidden from the user, I suppose I really don't care any more.
> 
> There is no point at all in having an irq number if it is not visible
> to user space.
> 
> Reaching a point where we don't export irq numbers to user space is
> a hard problem.  We have the irq balancer in user space (gag) and as
> well as interfaces like /proc/interrupts, and for old ISA devices
> there is no way to autodetect the configuration.  So it requires a lot
> of work.

Sure, but you have 16 (or whatever) legacy interrupts.  You still call
them 1-16 (or ISA-1 through ISA-16).  By the time we reach this stage,
we're essentially doing string table lookups for the interrupts, so
there's no need to pre-allocate them (except as a possible arch
implementation detail).

> The obvious first step is still to remove the architecture dependence
> on irq number, and introduce another way of talking about irqs.  Then
> we can proceed to change the driver and the user space interfaces.
> 
> I completely agree that irq number 99.9% of the time should be a completely
> abstract token.

Sure, although one nice reason for doing the abstraction first is that
it stops people imposing fragile numbering schemes on irq ...

James


