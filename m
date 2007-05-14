Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbXENW4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbXENW4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXENW4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:56:45 -0400
Received: from lixom.net ([66.141.50.11]:39770 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864AbXENW4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:56:45 -0400
Date: Mon, 14 May 2007 17:59:46 -0500
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, paulus@samba.org,
       linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] pcmcia: ppc64 needs 64-bit ioaddr_t
Message-ID: <20070514225946.GB4191@lixom.net>
References: <20070512143105.GA12890@lixom.net> <20070514150802.b9120e9f.akpm@linux-foundation.org> <1179182824.32247.131.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179182824.32247.131.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 08:47:04AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2007-05-14 at 15:08 -0700, Andrew Morton wrote:
> > 
> > Well that's some pretty sad code you've found there.  The kernel
> > surely has
> > some appropriate type to use here without us having to invent a new
> > one. 
> > But I suspect if we were to rationalise things in there it will get
> > messy.
> 
> There is more sad stuff involved with drivers assuming IO ports fit in
> int. A proper fix for 2.6.23 will be the rework of PIO allocation I'm
> doing. A temporary fix for 2.6.22 would be for Olof to use
> reserve_phb_iospace() to make sure his PIO gets in the low 31 bits. We
> need to add a spinlock to it though.

Yes, we should do fine with just a 32-bit type and my CF driver being
fixed. I've been travelling and catching up with other things today,
I should have something to post tomorrow.

Andrew, you can drop this patch for now. Sorry for the churn.


-Olof
