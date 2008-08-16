Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYHPQNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYHPQNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 12:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYHPQNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 12:13:37 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41109 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbYHPQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 12:13:37 -0400
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
In-Reply-To: <20080816163945.74d487e9@lxorguk.ukuu.org.uk>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	 <86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
	 <1218898238.3940.6.camel@localhost.localdomain>
	 <20080816163945.74d487e9@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 11:13:29 -0500
Message-Id: <1218903209.3940.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 16:39 +0100, Alan Cox wrote:
> > Where exactly is this code in the kernel?  Most arches assume the irq is
> > an index to a compact table bounded by NR_IRQS, so something like this
> > would violate that assumption.
> 
> Yes, which is no bad thing for some platforms. There are some driver
> assumptions like that but those have also been stomped.

I'm not saying we couldn't do this, or even that we shouldn't; I'm just
asking why would we want to?

All arches currently seem to have show_interrupts() which loop over
0..NR_IRQS where the interrupt is printed as %d.  In this encoded scheme
they would show up with rather nastily large numbers that have no
visible meaning unless we switch to hex for displaying them.

What I'm really saying is that irq as the interrupt number is really the
*user's* handle for the interrupt not the machine's, so it needs to be
something the user is comfortable with.  We could overcome this
objection by encoding the number to something meaningful for the
user ... I'm just asking if there's any benefit to doing this?

James


