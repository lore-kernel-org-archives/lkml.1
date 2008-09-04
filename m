Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYIDHYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYIDHYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYIDHYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:24:36 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54934 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbYIDHYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:24:35 -0400
Date: Thu, 4 Sep 2008 09:22:52 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: benh@kernel.crashing.org
Cc: dwalker@mvista.com, tinytim@us.ibm.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       jean-pierre.dion@bull.net, michael@ellerman.id.au,
       linuxppc-dev@ozlabs.org, paulus@samba.org, gilles.carry@ext.bull.net,
       tglx@linutronix.de
Subject: Re: [PATCH 2/2] powerpc - Make the irq reverse mapping radix tree
 lockless
Message-ID: <20080904092252.12b3df4a@bull.net>
In-Reply-To: <1220496739.4879.20.camel@pasglop>
References: <1218029429-21114-1-git-send-email-sebastien.dugue@bull.net>
	<1218029429-21114-3-git-send-email-sebastien.dugue@bull.net>
	<1219209781.21386.25.camel@pasglop>
	<20080903154105.7dff49db@bull.net>
	<1220496739.4879.20.camel@pasglop>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 12:52:19 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2008-09-03 at 15:41 +0200, Sebastien Dugue wrote:
> > On Wed, 20 Aug 2008 15:23:01 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > 
> > > BTW. It would be good to try to turn the GFP_ATOMIC into GFP_KERNEL,
> > 
> >   That would be nice indeed
> > 
> > > maybe using a semaphore instead of a lock to protect insertion vs.
> > > initialisation.
> > 
> >   a semaphore? are you meaning a mutex? If not, I fail to understand what you're
> > implying.
> 
> Right, a mutex, bad habit calling those semaphores from the old days :-)

  OK, then we're on the same line ;-)

> 
> >   Right, that's the problem with this new scheme and I'm still trying
> > to find a way to handle memory allocation failures be it for GFP_ATOMIC or
> > GFP_KERNEL.
> > 
> >   I could not think of anything simple so far and I'm open for suggestions.
> 
> GFP_KERNEL should not fail, it will just block no ?

  No it won't block and will fail (returns NULL).

> If it fails, it's
> probably catastrophic enough not to care.

  Yep, I'd tend to agree with that.

> You can always fallback to linear lookup.

  I will have to add that back as there is no more fallback.

> I don't know if it's worth trying to fire off a new
> allocation attempt later, probably not.

  I've been pondering with this lately, but I think that adding a linear
lookup fallback should be OK.

  Thanks,

  Sebastien.

> 
> Ben.
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
