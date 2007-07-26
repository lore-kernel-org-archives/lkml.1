Return-Path: <linux-kernel-owner+w=401wt.eu-S933890AbXGZNH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbXGZNH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 09:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbXGZNHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 09:07:10 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:42064 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759629AbXGZNHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 09:07:08 -0400
Date: Thu, 26 Jul 2007 22:06:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Bortas <bortas@gmail.com>
Cc: Marcus Comstedt <marcus@mc.pp.se>,
       Adrian McMenamin <adrianmcmenamin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix DMA on Dreamcast
Message-ID: <20070726130635.GA28375@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Peter Bortas <bortas@gmail.com>, Marcus Comstedt <marcus@mc.pp.se>,
	Adrian McMenamin <adrianmcmenamin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <92a12cdb0707191230g216feaf2ied3e95bacf4dd572@mail.gmail.com> <20070720120408.1f190269.akpm@linux-foundation.org> <92a12cdb0707210322m6670acaer768d078c5e358b0c@mail.gmail.com> <7e5f60720707210424w48f9dc10hff044d702f7bd1d3@mail.gmail.com> <92a12cdb0707210506t5cf58cc4gc5b70f335545dc3f@mail.gmail.com> <7e5f60720707210713o4ff0825eu463abee77dc1f04c@mail.gmail.com> <yf9y7h3a31l.fsf@mc.pp.se> <7e5f60720707260559m64211206q581a4c83c9060485@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e5f60720707260559m64211206q581a4c83c9060485@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 02:59:51PM +0200, Peter Bortas wrote:
> On 7/26/07, Marcus Comstedt <marcus@mc.pp.se> wrote:
> > "Peter Bortas" <bortas@gmail.com> writes:
> > > On 7/21/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> > >> On 21/07/07, Peter Bortas <bortas@gmail.com> wrote:
> > >> > Sidenote: Does Linux handle the Dreamcast DMA errata?
> > >>
> > >> You need to explain what you mean (at least to me!).
> > >>
> > >> If you mean will it degrade gracefully - not without this patch if set
> > >> to the (correct) defconfig. With iffy settings it will.
> > >
> > > If I remember correctly (and that's a big if since I last looked at it
> > > in 2001) some revisions of the Dreamcast hardware would sporadically
> > > lock up if you scheduled a new DMA request to quickly after a previous
> > > one, even if you checked the ready bit. It's worked around by a delay
> > > of X microseconds as recommended by Sega engineers. I don't remember
> > > the value of X, nor where exactly in the flow this workaround should
> > > be applied.
> > >
> > > Adding Marcus in case he has a better memory than me.
> >
> > I don't remeber any such delay.  Are you sure you're not thinking
> > about the G2 bus problem (where accesses need to be programatically
> > serialized, whether they are PIO or DMA)?
> 
> In that case my memory is worse than I thought. I'll see if I can dig
> up my old notes.
> 
We've never hit any problems with the SH DMAC, so it would be interesting
if you had some more information on this. The G2 problems are well known
and documented, and the driver takes care of those issues already.

Is this problem specifically an SH7091 errata, or have you heard of it
happening on normal SH7750 parts also? SH7091 is unfortunately not very
well documented ;-)
