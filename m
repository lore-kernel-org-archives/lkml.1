Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbXEaPRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbXEaPRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXEaPR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:17:26 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:50289 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbXEaPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:17:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Date: Thu, 31 May 2007 09:17:18 -0600
User-Agent: KMail/1.9.6
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, "Andi Kleen" <ak@suse.de>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200705291844.00308.yinghai.lu@sun.com> <86802c440705302136h1f2da2d8j881e062dfa6b7d7a@mail.gmail.com> <20070530214859.ec026ac8.akpm@linux-foundation.org>
In-Reply-To: <20070530214859.ec026ac8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705310917.19205.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007 10:48:59 pm Andrew Morton wrote:
> On Wed, 30 May 2007 21:36:41 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> 
> > On 5/30/07, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > On 5/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Tue, 29 May 2007 18:43:59 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > > >
> > > > > [PATCH 4/5] serial: convert early_uart to earlycon for 8250
> > > >
> > > > drivers/serial/8250_early.c: In function 'parse_options':
> > > > drivers/serial/8250_early.c:143: error: 'FIX_EARLYCON_MEM_BASE' undeclared (first use in this function)
> > > > drivers/serial/8250_early.c:143: error: (Each undeclared identifier is reported only once
> > > >
> > > > That was with http://userweb.kernel.org/~akpm/config-sony.txt, but this is
> > > > going to break a whole pile of architectures (alpha, powerpc, others).
> > >
> > > alpha, powerpc, others may need sth like ia64, if they do not support fixmap.
> > 
> > or create dummy fixmap.h that doesn't support fixmap.
> 
> You could require that the architecture implement some specific function
> for mapping the early-uart.

We could, but we already have bt_ioremap, dmi_ioremap, and early_ioremap.
Do we really want to proliferate more flavors of "early ioremap"?  I'd
rather consolidate the ones we already have.
