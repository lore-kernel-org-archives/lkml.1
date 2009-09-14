Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZINQ0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZINQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbZINQ0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:26:20 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:43639 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbZINQ0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:26:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=DS2SI71Y82VlHLYzW/GRf0bLwfAcY31sGdSqnLw8UAx+WJ9J9+ah4SrK19Md/AqSDU
         tWDxF87Rdf9puam2If6ckKX+hR1MGSgV9jycsIqEL/21ZxvC4aPkzO0eqyjO0+RSUmgM
         qutg9CvkAUJmtA29UYXPfJUfr9ocTu3MDiIZ0=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH] arm: remove unused code in delay.S
Date: Mon, 14 Sep 2009 18:25:55 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-1-amd64; KDE/4.3.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <20090914152129.GI21580@n2100.arm.linux.org.uk> <94a0d4530909140850h3ec1bde2ifc05ff7d340f96fe@mail.gmail.com>
In-Reply-To: <94a0d4530909140850h3ec1bde2ifc05ff7d340f96fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909141825.55239.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Po 14. září 2009 17:50:15 Felipe Contreras napsal(a):
> On Mon, Sep 14, 2009 at 6:21 PM, Russell King - ARM Linux
> 
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Sep 14, 2009 at 06:14:08PM +0300, Felipe Contreras wrote:
> >> On Mon, Sep 14, 2009 at 5:40 PM, Russell King - ARM Linux
> >>
> >> <linux@arm.linux.org.uk> wrote:
> >> > On Mon, Sep 14, 2009 at 05:38:32PM +0300, Felipe Contreras wrote:
> >> >> On Mon, Sep 14, 2009 at 5:00 PM, Russell King - ARM Linux
> >> >>
> >> >> <linux@arm.linux.org.uk> wrote:
> >> >> > On Mon, Sep 14, 2009 at 03:58:24PM +0300, Felipe Contreras wrote:
> >> >> >> On Mon, Sep 14, 2009 at 11:10 AM, Russell King - ARM Linux
> >> >> >>
> >> >> >> <linux@arm.linux.org.uk> wrote:
> >> >> >> > On Mon, Sep 14, 2009 at 01:21:00AM +0100, Jamie Lokier wrote:
> >> >> >> >> Russell King - ARM Linux wrote:
> >> >> >> >> > On Sun, Sep 13, 2009 at 11:28:47PM +0200, Marek Vasut wrote:
> >> >> >> >> > > >                 bhi     __delay
> >> >> >> >> > > >                 mov     pc, lr
> >> >> >> >> > > >  ENDPROC(__udelay)
> >> >> >> >> > >
> >> >> >> >> > > Hi
> >> >> >> >> > >
> >> >> >> >> > > why was this code there in the first place ?
> >> >> >> >> >
> >> >> >> >> > To make the delay loop more stable and predictable on older
> >> >> >> >> > CPUs.
> >> >> >> >>
> >> >> >> >> So why has it been commented out, if it's needed for that?
> >> >> >> >
> >> >> >> > We moved on and it penalises later CPUs, leading to udelay
> >> >> >> > providing shorter delays than requested.
> >> >> >> >
> >> >> >> > So the choice was either stable and predictable on older CPUs
> >> >> >> > but buggy on newer CPUs, or correct on all CPUs but gives
> >> >> >> > unnecessarily longer delays on older CPUs.
> >> >> >>
> >> >> >> Why not add an #ifdef CPU_V4 or whatever?
> >> >> >
> >> >> > Because then you get it whenever you configure for V4 as the lowest
> >> >> > denominator CPU, which leads to the buggy behaviour on better CPUs.
> >> >> > It's far better to leave it as is and just accept that the old CPUs
> >> >> > will have longer than necessary delays.  If people really really
> >> >> > care (and there's likely to only be a small minority of them now)
> >> >> > changing the '0' to a '1' is a very simple change for them to carry
> >> >> > in their local tree.  Unlike getting the right unrolling etc.
> >> >>
> >> >> Well, they can also 'git revert' this patch. If somebody really cares
> >> >> I think they should shout now and provide a better patch, otherwise
> >> >> this one should be merged.
> >> >
> >> > On the other hand, having the code there as it currently stands is not
> >> > harmful in any way, so leaving it there is just as easy.
> >>
> >> It makes the code less understandable. I'm not sure about linux's
> >> practices, but an #if 0 generally means somebody is being lazy.
> >
> > I would agree with you if it was a complicated bit of code, but it
> > isn't.  It is a simple count to zero (or overflow) and terminate
> > loop.  And it's certainly not about me being lazy.

Russell, what about adding a comment somewhere explaining why it's there? That'd 
be a fine fix I think.
> 
> Maybe it's not complicated to you, but not everyone is so literate
> about ARM assembly code (e.g. me). When I first looked at the code I
> didn't even realize there was an #if 0 there, which yes, I grant is a
> problem of my editor, but the issue wouldn't have happened if the code
> wasn't there in the first place.

This is still religious argument and or your problem -- fix your editor.
> 
> And I'm not saying your are being lazy, if anything it's probably the
> people using this code. They should figure a way to avoid patching the
> code. However, these users are hypothetical at this point.

If you could invest your time into investigating how to make this configurable 
instead of arguing about #if 0, it'd be awesome.
> 
> > Unless there is a strong argument for removing it, the code stays as
> > is.
> >
> > So far, the argument is basically "it's a #if 0, we must get rid of
> > it" which is a religous argument, not a technical one.  The fact is
> > that (as I said above) keeping it there provides the code for when
> > people want to enable it.  That's a technical reason for keeping it.
> >
> > Please can we now move to something more productive instead of this
> > religous argument?
> 
> I don't think a good argument has been stated, I'll try to do that on
> Wolfram's reply.
> 
