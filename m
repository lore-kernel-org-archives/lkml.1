Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbYDNRCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbYDNRCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYDNRCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:02:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50329 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbYDNRCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:02:17 -0400
Date: Mon, 14 Apr 2008 09:56:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080414095638.64943a98@laptopd505.fenrus.org>
In-Reply-To: <1208190749.7375.10.camel@twins>
References: <20080411210022.GJ11962@parisc-linux.org>
	<1208003081.7427.7.camel@twins>
	<20080412172606.GL11962@parisc-linux.org>
	<adaskxqrgsl.fsf@cisco.com>
	<20080412204748.GN11962@parisc-linux.org>
	<20080413070833.GC19773@elte.hu>
	<20080413125758.GQ11962@parisc-linux.org>
	<20080414153928.GA22259@elte.hu>
	<adafxtoqvgh.fsf@cisco.com>
	<1208190749.7375.10.camel@twins>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 18:32:28 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2008-04-14 at 08:58 -0700, Roland Dreier wrote:
> > > which ones exactly are these places that demand the use of a
> > > counting 
> >  > semaphore? I cannot think of a single place where it's the best
> >  > choice, let alone one where it's the only choice.
> > 
> > Two of the places that use semaphores are
> > drivers/infiniband/hw/mthca and drivers/net/mlx4 -- in both cases,
> > the device firmware allows up to "N" outstanding firmware commands
> > to be in flight, and the driver uses a semaphore to handle issuing
> > firmware commands.  That is, down() when we want to issue a
> > command, and up() when the firmware responds that the command is
> > complete.
> > 
> > What would you suggest as a better way to code this?  This is an
> > honest question -- there probably is a more elegant way to handle
> > this situation and I really would like to learn about it.
> > 
> > Also, the argument that removing semaphores makes the kernel as a
> > whole better does make sense to me; I wouldn't be opposed to
> > basically open-coding semaphores in terms of wait_event() in the
> > driver or something like that, but I wouldn't say that such an
> > implementation is locally more readable or maintainable if we look
> > only at the driver code.
> 
> Yeah, I would open code it.  But this is indeed a sane usage of the
> counting semaphore because there is no priority inversion.

Maybe we need a "counter" primitive instead?
>From a conceptual point of view that even makes sense

(the implementation can be pretty much the current semaphore one of course)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
