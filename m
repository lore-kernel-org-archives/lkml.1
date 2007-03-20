Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbXCTLgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbXCTLgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXCTLgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:36:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57497 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbXCTLgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:36:49 -0400
Date: Tue, 20 Mar 2007 12:36:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <greg@kroah.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Len Brown <lenb@kernel.org>, tglx@linutronix.de,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far
Message-ID: <20070320113644.GA7751@one.firstfloor.org>
References: <200703161230.03712.maximlevitsky@gmail.com> <1174088686.13341.347.camel@localhost.localdomain> <200703162132.53906.lenb@kernel.org> <1174127539.3538.207.camel@laptopd505.fenrus.org> <p73k5xg6lwe.fsf@bingen.suse.de> <20070320042734.GA9700@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320042734.GA9700@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 09:27:34PM -0700, Greg KH wrote:
> On Sat, Mar 17, 2007 at 02:26:57PM +0100, Andi Kleen wrote:
> > Arjan van de Ven <arjan@infradead.org> writes:
> > > 
> > > well we can do the handshake to take ownership like we do much later in
> > > boot, but that requires PCI to be there and fully discovered, which we
> > > don't have this early.
> > 
> > That's not true - we do early pci discovery. Doing USB handsoff
> > there would be quite possible.
> 
> What, we don't do USB "handoff" early enough in the boot process?  It's
> happening at PCI quirk time now, which I think should be early enough
> for everyone (and too early for some who rely on USB keyboards and

Early for drivers, but quite late for architecture initialization.

> initramfs shells...)

It's long after timer calibration, which is what it interfered with here.

To handle that it would need to be moved to the x86 early quirks and
use boot_ioremap etc. It would be probably somewhat messy, but doable.

-Andi

