Return-Path: <linux-kernel-owner+w=401wt.eu-S935970AbXHICUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935970AbXHICUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbXHICUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:20:06 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:42649 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbXHICUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:20:05 -0400
Date: Wed, 8 Aug 2007 22:19:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 4/7] Moved the io struct up to the generic lg.h
In-Reply-To: <20070809115156.ef5fdc6c.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.58.0708082217470.19189@gandalf.stny.rr.com>
References: <20070809003211.373543702@goodmis.org> <20070809003343.664528532@goodmis.org>
 <20070809115156.ef5fdc6c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Thu, 9 Aug 2007, Stephen Rothwell wrote:

> On Wed, 08 Aug 2007 20:32:15 -0400 Steven Rostedt <rostedt@goodmis.org>
> wrote:
> >
> > diff --git a/drivers/lguest/i386/lg.h b/drivers/lguest/i386/lg.h
> > index 64f0abe..c5ea14c 100644
> > --- a/drivers/lguest/i386/lg.h
> > +++ b/drivers/lguest/i386/lg.h
> > @@ -20,6 +20,8 @@
> >  #include <linux/err.h>
> >  #include <asm/semaphore.h>
> >  #include "irq_vectors.h"
> > +/* some files include this, some include the parent */
> > +#include "../lg.h"
>
> Surely everything should just include the parent which allows for easier
> consolidation over time. (as you are doing here)

Yeah, that sounds better. This was my attempt at not modifing the
i386/ stuff too much.  But I can have those files change to do a "../lg.h"
include.  Again, doing the move plus change to keep things building. Hmm,
I guess git can handle that.

>
> > --- a/drivers/lguest/lg.h
> > +++ b/drivers/lguest/lg.h
> > @@ -1,3 +1,19 @@
> > +#ifndef _LGUEST_LG_GENERIC
> > +#define _LGUEST_LG_GENERIC
>
> Maybe _LGUEST_LG_H?  and the arch ones could use _LGUEST_I386_LG_H etc.

Noted. Will do in the next release.

Thanks,

-- Steve
