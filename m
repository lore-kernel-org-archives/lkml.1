Return-Path: <linux-kernel-owner+w=401wt.eu-S1765489AbYHEVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765489AbYHEVXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763625AbYHEVX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:23:27 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:33981
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1765401AbYHEVX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:23:26 -0400
Date: Tue, 5 Aug 2008 17:23:24 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: "Karsten Keil" <kkeil@suse.de>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>,
       <isdn4linux@listserv.isdn4linux.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-ID: <20080805172324.45853d98@lappy.seanm.ca>
In-Reply-To: <20080805210239.GB6052@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
	<1217910588.24157.151.camel@pasglop>
	<20080805113111.GA6827@pingi.kke.suse.de>
	<1217941466.24157.190.camel@pasglop>
	<20080805172549.GA6052@pingi.kke.suse.de>
	<alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
	<20080805210239.GB6052@pingi.kke.suse.de>
Organization: PIKA
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 23:02:39 +0200
"Karsten Keil" <kkeil@suse.de> wrote:

> On Tue, Aug 05, 2008 at 11:42:56AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 5 Aug 2008, Karsten Keil wrote:
> > > 
> > > Maybe we can use the trick from lib/iomap.c to detect which
> > > kind of IO is needed, but unfortunately PIO_OFFSET, PIO_MASK and
> > > PIO_RESERVED are not exported so it would need to copy the
> > > defines, which isn't a really clean solution.
> > 
> > Even if they were exported, you couldn't.
> > 
> > lib/iomap.c is _not_ generic code. It's a library function for 
> > architectures that don't do it some other way. But various
> > architectures can choose to not use lib/iomap.c at all - for
> > example, they may have MMIO and PIO in the same address space, so
> > they don't need the conditionals at all (because all the work was
> > done at mapping time, not at runtime).
> > 
> > So if you actually have different models of operation for PIO and
> > MMIO, then yes, you need to handle that in the driver itself.
> > 
> 
> One question here, what is the better approach to do such a different
> implementation, use one local function like
> 
> static void
> my_out32(struct card *c, u_int offset, u-int data) 
> {
> 	if (c->mode == MMIO) {
> 		...
> 	} else {
> 		...
> 	}
> }
> 
> or use 2 function, one for the MMIO and one for the PIO model and
> then use indirect calls (like c->my_out32(...)) ?

Why not select PIO or MMIO at config time?

Cheers,
   Sean
