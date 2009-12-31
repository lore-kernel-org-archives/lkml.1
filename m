Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZLaSt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZLaSt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZLaSt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:49:58 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48970 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZLaSt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:49:58 -0500
Date: Fri, 1 Jan 2010 00:19:49 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegardno@ifi.uio.no>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC Patch 1/2][Bugfix][x86][hw-breakpoint] Clear reserved
	bits of DR6 in do_debug()
Message-ID: <20091231184949.GB3676@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182725.GB9494@in.ibm.com> <20091230234458.GA23808@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230234458.GA23808@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 12:45:00AM +0100, Frederic Weisbecker wrote:
> On Sat, Dec 26, 2009 at 11:57:25PM +0530, K.Prasad wrote:
> > Clear the reserved bits from the stored copy of debug status register (DR6).
> > This will help easy bitwise operations.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > ---
> >  arch/x86/include/asm/debugreg.h |    3 +++
> >  arch/x86/kernel/traps.c         |    3 +++
> >  2 files changed, 6 insertions(+)
> > 
> > Index: linux-2.6-tip/arch/x86/include/asm/debugreg.h
> > ===================================================================
> > --- linux-2.6-tip.orig/arch/x86/include/asm/debugreg.h
> > +++ linux-2.6-tip/arch/x86/include/asm/debugreg.h
> > @@ -14,6 +14,9 @@
> >     which debugging register was responsible for the trap.  The other bits
> >     are either reserved or not of interest to us. */
> >  
> > +/* Define reserved bits in DR6 which are always set to 1 */
> > +#define DR6_RESERVED	(0xFFFF0FF0)
> > +
> 
> 
> The 12th bit seems to be also reserved.
> Shouldn't it be 0xffff1ff0 ?
> 

The 12th bit is reserved to be 0 always.

> What kind of bitwise operations do you think it could help?
> 
> All of the operations I can find on dr6 are simple masks
> test/set/clear.
> 

As you found out later, this bitmask helps us in
hw_breakpoint_handler().

Thanks,
K.Prasad

