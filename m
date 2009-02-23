Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbZBWWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbZBWWn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZBWWnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:43:20 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:28909 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753693AbZBWWnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:43:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SbPrL220CLD1a/O/NugCWGQFd5iN0SBEz5TUgvQE8cupSir3jc3N46XPqAd8A+9hnqYgCRex+PoDBhlhie5GXTPuhPUk5Vv2kkNN/PXO4ASAdjTNmIuPdpfIWLcYUdqD8v5EsnkSqt0E1MsK4dYAOFcmyY7yd2xc/wR9+bB7clY=  ;
X-YMail-OSG: TQ1XNywVM1lNIH9DbMlgtOQSBX.Fq6gMFFIZaadSX844.7KredWm1oMBDN.Pq4PUkO9AK10pp5KJuoAo7LFTa_qj0bVb9CDDhOrybEmApaOdO5EuJl8JSNf9PqKLSnVbzO5mITkX27rZitW8lisxR2S5
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
Date: Mon, 23 Feb 2009 14:43:16 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902231245.44360.david-b@pacbell.net> <20090223220359.GA3601@sirena.org.uk>
In-Reply-To: <20090223220359.GA3601@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231443.16334.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Mark Brown wrote:
> On Mon, Feb 23, 2009 at 12:45:44PM -0800, David Brownell wrote:
> 
> > > another with a TWL4030 driver using that API 
> > > and a third patch making the core do something with that data.
> 
> > Best IMO to switch the last two around.  Effectively
> > there'd be one patch "add new features to regulator
> > core", followed by the first of a set of "implement
> > those new features in the driver for regulator X".
> 
> > And in fact that's what I've done with the two patches
> > I'll be sending in a moment.
> 
> The reason I'm suggesting splitting things up the way I am is that it
> separates out the TWL4030 driver (which looks very mergable to me right
> now) from the behaviour changes.  Ordering things that way makes it
> clear what the dependency is.  Another way of splitting it out would be
> to remove the new API from the TWL4030, make that the first patch, then
> have further patches adding the new API and the TWL4030 code to use it.
> 
> I don't see any reason why the TWL4030 regulator support needs to be
> blocked on adding the new API and it makes review easier to keep them
> separate.

I think we're talking past each other.  I agree the twl4030 driver
is very mergeable right now; that's why it was submitted.  You could
do so, and then apply the two patches on top ... very clear what the
dependency is, and as I understand it the result would be more or less
to your liking.

My comment was more along the lines of "avoid adding unused hooks,
just merge the create-hook and use-hook patches".  Having "create"
separate from "use" is often troublesome.


> > Then what would you call constraints by/from the regulator?
> 
> They're subsumed within the constraints supplied by the machine driver
> at the minute.

That is, they are not named.  :)


> > I suggest updating your terminology.  "machine constraints"
> > would be much more clear for what's there now:  they relate
> > to the machine.  Other constraints (regulator, consumer)
> > relate to the other components ... the ones for which they
> > are an adjective.
> 
> Yeah, I kind of agree.  To avoid confusion from changing the names I'd
> be tempted to go for something like "regulator driver constraints" but
> it's not desparately nice.

Hence my suggestion:  {regulator,machine,consumer} constraints,
going from bottom up.  They aren't driver constraints; they
are hardware constraints:  regulators can't supply arbitrary
voltages.


> 	 To be honest I'm not
> 100% clear why this new feature is essential to supporting the TWL4030 -
> I can see that it could be useful but I'm not clear on what makes it
> essential for this driver.

I never said it was "essential".  However it does simplify
the core driver code a lot by moving a lot of error checks
to the init code; the checks need to live someplace.  You're
the one asking for them to be packaged as a new framework
feature.

- Dave

