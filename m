Return-Path: <linux-kernel-owner+w=401wt.eu-S1764575AbYHEVCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764575AbYHEVCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760810AbYHEVCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:02:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761469AbYHEVCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:02:42 -0400
Date: Tue, 5 Aug 2008 23:02:39 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-ID: <20080805210239.GB6052@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de> <1217910588.24157.151.camel@pasglop> <20080805113111.GA6827@pingi.kke.suse.de> <1217941466.24157.190.camel@pasglop> <20080805172549.GA6052@pingi.kke.suse.de> <alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 11:42:56AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 5 Aug 2008, Karsten Keil wrote:
> > 
> > Maybe we can use the trick from lib/iomap.c to detect which
> > kind of IO is needed, but unfortunately PIO_OFFSET, PIO_MASK and
> > PIO_RESERVED are not exported so it would need to copy the defines, which
> > isn't a really clean solution.
> 
> Even if they were exported, you couldn't.
> 
> lib/iomap.c is _not_ generic code. It's a library function for 
> architectures that don't do it some other way. But various architectures 
> can choose to not use lib/iomap.c at all - for example, they may have MMIO 
> and PIO in the same address space, so they don't need the conditionals at 
> all (because all the work was done at mapping time, not at runtime).
> 
> So if you actually have different models of operation for PIO and MMIO, 
> then yes, you need to handle that in the driver itself.
> 

One question here, what is the better approach to do such a different
implementation, use one local function like

static void
my_out32(struct card *c, u_int offset, u-int data) 
{
	if (c->mode == MMIO) {
		...
	} else {
		...
	}
}

or use 2 function, one for the MMIO and one for the PIO model and then use
indirect calls (like c->my_out32(...)) ?

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
