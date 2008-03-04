Return-Path: <linux-kernel-owner+w=401wt.eu-S1765692AbYCDUb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765692AbYCDUb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763233AbYCDUaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:30:46 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:36208 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761520AbYCDUao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:30:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=J4MdnNp8LI3H3GQ6V6sMbwVPN//etO6UObH86q5a908xwSL1tpwTBOvLPhjBtkSF077+2eQAGjBb804lP7Y2RqFZTpe4/Cu+C7P7syO9If9mqW3GRTbsq7uTPaT3V/IBxXvNO81oKEDVKWplzJoOM8b/0w6ChDlDHUjQvTwEsZA=  ;
X-YMail-OSG: idGQ6V0VM1krBBdwbjAg7FVycArsBFWfMf1b3MEvyns7rs8cJeXrVEPiFUPQfPc2J0D_X9guvQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is inserted]
Date: Tue, 4 Mar 2008 12:30:41 -0800
User-Agent: KMail/1.9.6
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803041447090.15190-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803041447090.15190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041230.42152.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Alan Stern wrote:
> On Tue, 4 Mar 2008, David Brownell wrote:
> 
> > > I don't understand this comment.  Suppose a card was inserted while the 
> > > system was hibernating.  If the core didn't reprobe, when would that 
> > > card be discovered?
> > 
> > The host controller would tell the core to check for a card, exactly
> > like it does at all other times.
> 
> But how would the host controller know to do that?  Isn't card 
> insertion detection often driven by interrupts?  If a card is 
> inserted while the computer is off, no interrupt will be generated.

I'm talking about Real Suspend States (tm), not hibernation.
The systems in question tend to not support hibernation.

In particular:  system sleep states where IRQs work ... that's a
common way for non-x86 platforms to work.


> > That's the natural alternative to having the MMC core assume that card
> > detection was broken in low power states, so that the core needed to
> > forcibly remove the cards before suspend, and reprobe during resume
> > processing.
> 
> Is that the assumption the MMC core was really making?  Are you sure it 
> wasn't assuming something else (perhaps equally as bad)?

On the systems I was looking at, that assumption seems equivalent to
what the latest MMC core is assuming.  (I think this came as part of
the rewrite/refactoring a while back.)  But since the assumptions aren't
documented as such, you could say all guesses are equal.  ;)


> > Having the MMC core make such needless assumptions can cause problems
> > for the upper layers, including filesystems.
> 
> What's wrong with a superfluous probe at resume time, besides the waste 
> of a few milliseconds?

I'm more concerned with the undesirable removal of devices at suspend
time ... ones with mounted filesystems etc.

- Dave

