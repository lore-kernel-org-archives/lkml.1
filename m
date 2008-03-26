Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbYCZStU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbYCZStU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbYCZStM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:49:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53507 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755497AbYCZStL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:49:11 -0400
Date: Wed, 26 Mar 2008 13:49:10 -0500 (CDT)
From: Alan Mayer <ajm@sgi.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Mayer <ajm@sgi.com>, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines
In-Reply-To: <20080325231034.GA3894@ucw.cz>
Message-ID: <Pine.SGI.3.96.1080326134839.7873204Y-100000@fergus.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Mar 2008, Pavel Machek wrote:

> Hi!
> 
> > Subject: [PATCH] x86_64: resize NR_IRQS for large machines
> > 
> > From: Alan Mayer <ajm@sgi.com>
> > 
> > On machines with very large numbers of cpus, tables that are dimensioned
> > by NR_IRQS get very large, especially the irq_desc table.  They are also
> > very sparsely used.  When the cpu count is > MAX_IO_APICS, use MAX_IO_APICS
> > to set NR_IRQS, otherwise use NR_CPUS.
> > 
> > Signed-off-by: Alan Mayer <ajm@sgi.com>
> > 
> > Reviewed-by: Christoph Lameter <clameter@sgi.com>
> 
> > ===================================================================
> > --- v2.6.25-rc6.orig/include/asm-x86/irq_64.h	2008-03-19 16:52:52.000000000 -0500
> > +++ v2.6.25-rc6/include/asm-x86/irq_64.h	2008-03-20 16:46:51.000000000 -0500
> > @@ -10,6 +10,10 @@
> >   *	<tomsoft@informatik.tu-chemnitz.de>
> >   */
> >  
> > +#if !defined(MAX_IO_APICS)
> > +#include <asm/apicdef.h>
> > +#endif
> > +
> 
> This is very ugly. Why not include it unconditionally -- with guard in
> apicdef.h?
> 							Pavel

Okay, I can change that.

		--ajm

> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 

--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--

