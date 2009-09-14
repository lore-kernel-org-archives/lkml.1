Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbZINOkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbZINOkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZINOkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:40:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48463 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbZINOkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:40:39 -0400
Date: Mon, 14 Sep 2009 15:40:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>, Marek Vasut <marek.vasut@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090914144028.GG21580@n2100.arm.linux.org.uk>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <200909132328.47079.marek.vasut@gmail.com> <20090913230008.GC30169@n2100.arm.linux.org.uk> <20090914002100.GD30621@shareable.org> <20090914081001.GB14519@n2100.arm.linux.org.uk> <94a0d4530909140558nd8d2c47lc9954563c80a574f@mail.gmail.com> <20090914140059.GC21580@n2100.arm.linux.org.uk> <94a0d4530909140738t7e4d646r134cfd884da21348@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94a0d4530909140738t7e4d646r134cfd884da21348@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 05:38:32PM +0300, Felipe Contreras wrote:
> On Mon, Sep 14, 2009 at 5:00 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Sep 14, 2009 at 03:58:24PM +0300, Felipe Contreras wrote:
> >> On Mon, Sep 14, 2009 at 11:10 AM, Russell King - ARM Linux
> >> <linux@arm.linux.org.uk> wrote:
> >> > On Mon, Sep 14, 2009 at 01:21:00AM +0100, Jamie Lokier wrote:
> >> >> Russell King - ARM Linux wrote:
> >> >> > On Sun, Sep 13, 2009 at 11:28:47PM +0200, Marek Vasut wrote:
> >> >> > > >                 bhi     __delay
> >> >> > > >                 mov     pc, lr
> >> >> > > >  ENDPROC(__udelay)
> >> >> > > >
> >> >> > > Hi
> >> >> > >
> >> >> > > why was this code there in the first place ?
> >> >> >
> >> >> > To make the delay loop more stable and predictable on older CPUs.
> >> >>
> >> >> So why has it been commented out, if it's needed for that?
> >> >
> >> > We moved on and it penalises later CPUs, leading to udelay providing
> >> > shorter delays than requested.
> >> >
> >> > So the choice was either stable and predictable on older CPUs but
> >> > buggy on newer CPUs, or correct on all CPUs but gives unnecessarily
> >> > longer delays on older CPUs.
> >>
> >> Why not add an #ifdef CPU_V4 or whatever?
> >
> > Because then you get it whenever you configure for V4 as the lowest
> > denominator CPU, which leads to the buggy behaviour on better CPUs.
> > It's far better to leave it as is and just accept that the old CPUs
> > will have longer than necessary delays.  If people really really
> > care (and there's likely to only be a small minority of them now)
> > changing the '0' to a '1' is a very simple change for them to carry
> > in their local tree.  Unlike getting the right unrolling etc.
> 
> Well, they can also 'git revert' this patch. If somebody really cares
> I think they should shout now and provide a better patch, otherwise
> this one should be merged.

On the other hand, having the code there as it currently stands is not
harmful in any way, so leaving it there is just as easy.
