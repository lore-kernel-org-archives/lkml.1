Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYFHU1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYFHU1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYFHU1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:27:33 -0400
Received: from wsip-70-184-212-2.om.om.cox.net ([70.184.212.2]:37153 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbYFHU1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:27:33 -0400
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: bcm33xx port
Date: Sun, 8 Jun 2008 15:27:28 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
References: <200806072113.26433.luke@dashjr.org> <200806081357.02601.luke@dashjr.org> <Pine.LNX.4.55.0806082041150.15673@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806082041150.15673@cliff.in.clinika.pl>
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081527.31221.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 June 2008, Maciej W. Rozycki wrote:
> On Sun, 8 Jun 2008, Luke -Jr wrote:
> > the bcm63xx patches OpenWrt has that I'm using as a base for this...
>
>  It would be best if the patches you are referring to got merged with the
> mainline.  Otherwise whoever uses them is essentially on their own --
> people lack the resources needed to chase random changes out there in
> general.

Is merging with mainline something I can help with, being a beginner in this 
area generally and not having any part in writing them?

> > >  That's grossly wrong.  If you need to preset it for the time being
> > > till you debug calibration, then for a MIPS processor assume one
> > > instruction per clock tick and two instructions per loop -- that may
> > > not be entirely correct, but is a good approximation.  Otherwise you
> > > risk peripheral devices are not driven correctly with all sorts of the
> > > nasty results.
> >
> > Meaning this?
> > 	preset_lpj = loops_per_jiffy = 2;
>
>  Not exactly.  Try harder -- this is simple arithmetic and you've got all
> the data given above already. :)

200 / 2? I'm not really sure what a 'jiffy' is..

> > > and (b) control being transferred to a block of memory that isn't
> > > actually code, as can happen if exception vectors or global
> > > pointers-to-functions aren't set up correctly, or if the kernel stack
> > > is being corrupted.   When you say "the instruction in question is a
> > > store word", how do you know that?
> >
> > The RI error spits out a bunch of info, including epc which presumably
> > points to the instruction causing the problem: ac85ffc0; this is 'sw
> > a1,-64(a0)'
>
>  I have seen that already and wrote these stores in __bzero are protected.
> Perhaps the fixup fails for some reason, but you need to investigate it
> and this is why I suggested to see how the RI handler is reached.  Since
> this is a known point the failure leads to, you should be able to work
> backwards from there quite easily.

Ah, so what you're saying is that perhaps the 'sw' is triggering a TLB 
exception, and the handler for *that* is causing the RI problem?

Thanks,

Luke
