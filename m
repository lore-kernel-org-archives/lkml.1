Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXF3O3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXF3O3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbXF3O2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:28:54 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:47002 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756309AbXF3O2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:28:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ad2upBeboYFbDZ3rVxtjbVvTZod09C0BB0B5TxrrQb2Xwi1WFXV1cIevhV/WqeCNF1nImTkvQJh2fHiGlGLInKDmUF2uJj0nAWoSnz6VU1qoBOhy56t+DBNR9gbaCxyfcDNCHdjgFUExDF/K/NjTlAoQOWJmYvO/jh9Wg8F+V84=  ;
X-YMail-OSG: iRN4gHUVM1lcbivqdQZokujwgoX3hjv6TgjwF3N8CTE4DO_QY0rx46XugnDCo2pfnyV0ukDvDAEwhzOP7bojjUaC7e8lIedlfISPo6Vik2AquTEFww--
From: David Brownell <david-b@pacbell.net>
To: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
Subject: Re: [linux-usb-devel] [PATCH] PXA27x UDC driver.
Date: Sat, 30 Jun 2007 06:46:14 -0700
User-Agent: KMail/1.9.6
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>,
       linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <20070628103619.GW13886@enneenne.com> <200706281453.23414.david-b@pacbell.net> <4684CAF7.9050201@gmail.com>
In-Reply-To: <4684CAF7.9050201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706300646.14399.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2007, Dmitry Krivoschekov wrote:
> David Brownell wrote:
> > On Thursday 28 June 2007, Rodolfo Giometti wrote:
> >
> >> As suggest by Leo let me propose to you my new patch for PXA27x UDC
> >> support.
> >>
> >> Please, let me know what I have to do for kernel inclusion. :)
> >
> > Let's start with *JUST* a driver, not trying to update everything
> > else in the USB Gadget stack so that it looks like it's designed
> > specifically to handle all of Intel's design botches related to
> > endpoint config ... and work worse for essentially everything else.
> >
> > (Unlike pretty much every other vendor, Intel wanted hardware config
> > management. It was unusably buggy in pxa21x/25x/26x, and not much
> > better in pxa27x.)
> >
> >
> > So in technical terms, and to repeat what I've said before: just
> > configure it to act more like a PXA 25x chip (no altsettings) and
> > get it so it passes all the tests [1], modulo errata which have no
> > workarounds
> 
> Other options are:
> 
>     1. pre-program endpoints so the setting covers all gadget
>        configurations, it seems it's feasible. The only appreciable
>        change is, CDC Ethernet config number should be 3 instead of 1.
>        It should not break anything.

ISTR looking at this in some detail a few years back, and
concluding that it wouldn't quite work.  That was before
started to hear back from people that the pxa27x hardware
didn't really match its documentation, too ...


>     2. Implement a FAKE call of GET_CONFIGURATION command so upon
>        gadget binding you can issue the command and program endpoints
>        according to the received gadget configuration.

That would involve *multiple* such fake calls.  Not the most
elegant of solutions, but ISTR using it in some other context.

But again, that presumes sane hardware, or at least hardware
that matches the docs.  And people who've looked at this in
more pain than I have are consistent in telling me that pxa27x
endpoint configuration has problems that the docs and errata
do not describe.  (If it were just one person, rather than four
different developers, I'd be somewhat skeptical.)  Hence my
eventual conclusion (and advice) to just stop trying to use
that misfeature.

 
> Also, considering that PXA3XX processors include PXA27x-compatible
> USB device controller it makes sense to develop a driver that
> will support both processor families. Hopefully PXA3XX arch
> support will be merged some day (the arch support has been already
> submitted here, but I don't know about its current status).

Has someone actually signed up to develop and maintain such a
controller driver?  If so, that would be a Fine Thing, but not
one I've heard rumored before.  I've assumed that the best we'd
have is someone (Rodolfo?!) finally cleaning up a pxa27x version
so it could be merged.

- Dave


> 
> 
> Regards,
> Dmitry
> 
> > ... then submit that. No epautoconfig updates, no
> > patches to every gadget driver to cope with updated autoconfig.
> >
> > Once there's a basic working no-frills version merged, then we can
> > talk about whether things in the rest of the stack should change
> > to accomodate the bizarre concepts of this controller.
> >
> > - Dave
> >
> >
> > [1] http://www.linux-usb.org/usbtest/
> >
> 


