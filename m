Return-Path: <linux-kernel-owner+w=401wt.eu-S1761197AbYC0TEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197AbYC0TEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbYC0TEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:04:10 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:46229 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756132AbYC0TEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:04:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SSKwwSmKB3UnwhuAxSQT9XdBssI8FwPRJv/P/fQIPXBjnZOawkQiGxH7pDqrrQD6QHITSB25BU7U2uSz9EmXcL4WrQUe11nqu1Cg7EqfkascKnr5SGu4MAKi161z0o8Fzg2c5f2eFmS8CzP6KFBFv9uqWvlMoB8TRIkD3KPVwN0=  ;
X-YMail-OSG: adu8I7wVM1lC1skdEDW59z3AGZQlADFxfyKInTbqGOJhpZrc3z9RrXm1ZlauU8e6nHCqUjlJskE9c3CDkamO2lL0nqtYwKqZVsSNHBcxEJzRI9ydXw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Alan Stern <stern@rowland.harvard.edu>, rpurdie@rpsys.net
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Date: Thu, 27 Mar 2008 11:51:33 -0700
User-Agent: KMail/1.9.6
Cc: gitster@pobox.com, corbet@lwn.net, mingo@elte.hu, mb@bu3sch.de,
       linux-kernel@vger.kernel.org, khali@linux-fr.org, geert@linux-m68k.org,
       akpm@linux-foundation.org
References: <20080325232042.4EDA7346532@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <Pine.LNX.4.44L0.0803261027580.4969-100000@iolanthe.rowland.org> <20080326161724.GA3562@khazad-dum.debian.net>
In-Reply-To: <20080326161724.GA3562@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271151.34317.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008, Henrique de Moraes Holschuh wrote:
> On Wed, 26 Mar 2008, Alan Stern wrote:
> > On Tue, 25 Mar 2008, David Brownell wrote:
> > > I _almost_ hate bringing this lovely flamage back onto $SUBJECT ... but
> > > what's the resolution for the leds-gpio.c issue?  I've not seen a merge
> > > notice for the patch I submitted a week ago now:
> > > 
> > > 	http://marc.info/?l=linux-kernel&m=120597839009399&w=2
> > > 
> > > Just a "leaning..." comment:
> > > 
> > > 	http://marc.info/?l=linux-kernel&m=120606104619198&w=2
> > > 
> > > Seems to me that by now there ought to be resolution on at least
> > > one of the issues brought up on this thread.  :)
> > 
> > Is it reasonable to have two version of that subroutine: one meant to 
> > be called in a sleepable context and the other to be called when 
> > sleeping isn't allowed?

Not before 2.6.25 ships it isn't.  :)


> I have changed the thinkpad-acpi leds code to always assume an atomic
> context, but I too would appreciate a proper flag (or secondary hook)
> from the LED class to know when I am in an atomic context or not.
> 
> LED Triggers also need to be modified, they are mostly called from an
> atomic context so we have to assume that by default, but we'd do well to
> add a way to call them from non-atomic contexts.
> 
> Richard?  AFAIK, the ball *is* in your court as the LED maintainer.  You
> have to decide which way to go and tell us.

Presumably, both near-term and long-term solutions are needed.

I'd suggest merging the leds-gpio and thinkpad-acpi fixes
before 2.6.25 ships, and then *maybe* adopting something
more invasive.

- Dave
