Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZIPHBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZIPHBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbZIPHBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:01:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57544 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbZIPHBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:01:06 -0400
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
In-Reply-To: <alpine.DEB.1.00.0909152351510.13366@chino.kir.corp.google.com>
References: <1253083059.5478.1.camel@penberg-laptop>
	 <alpine.DEB.1.00.0909152351510.13366@chino.kir.corp.google.com>
Date: Wed, 16 Sep 2009 10:01:08 +0300
Message-Id: <1253084468.6749.27.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, 16 Sep 2009, Pekka Enberg wrote:
> > The SLQB allocator is known to be broken on certain PowerPC and S390
> > configurations. Disable the allocator in Kconfig for those architectures
> > until the issues are resolved.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Christoph Lameter <cl@linux-foundation.org>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Nick Piggin <npiggin@suse.de>
> > Cc: Sachin Sant <sachinp@in.ibm.com>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > ---
> >  init/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/init/Kconfig b/init/Kconfig
> > index c0d8a47..aaeddeb 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1033,6 +1033,7 @@ config SLUB
> >  
> >  config SLQB
> >  	bool "SLQB (Queued allocator)"
> > +	depends on !PPC && !S390
> >  	help
> >  	  SLQB is a proposed new slab allocator.
> >  

On Tue, 2009-09-15 at 23:55 -0700, David Rientjes wrote:
> I think this should be (!PPC && !S390) || EXPERIMENTAL so that it can 
> still be enabled for debugging and development.

Everybody enables EXPERIMENTAL so that seems pointless. Developers can
hack Kconfig locally, no?

On Tue, 2009-09-15 at 23:55 -0700, David Rientjes wrote:
> Is this in preparation for slqb inclusion as a non-default slab
> allocator in 2.6.32?  2.6.33?

Non-default for 2.6.32.

			Pekka

