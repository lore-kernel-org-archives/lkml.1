Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbYCCV7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbYCCV7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYCCV7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:59:40 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:21478 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751275AbYCCV7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:59:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=R2wGn25e8yGzDkhOYJIqd3PzoQy+wRz8WZxmfJfwQHsbfT+KxWvpZAKbFzbJbGT1SyH9gAj6+f24p9jES6h0aiR7j1lbPQ3zW5OMZg6raA3OI4iepc4wl7wHX4aTGwsZYUaxkkvKbF3EgaDjs3mpDH5a5yQKKfunoUSE/XRpt7s=  ;
X-YMail-OSG: tA9bSWYVM1nT2IX8c7kD7RJRUA7dfwa_lOaR7y8rsIuCKn74Gf6gIWKuUcUnbc09CgEMHq4kBQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card is inserted]
Date: Mon, 3 Mar 2008 13:59:37 -0800
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <200802241500.41969.rjw@sisk.pl> <Pine.LNX.4.44L0.0802240941440.29504-100000@netrider.rowland.org> <20080225184102.0a2e2bb5@mjolnir.drzeus.cx>
In-Reply-To: <20080225184102.0a2e2bb5@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031359.38263.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008, Pierre Ossman wrote:
> On Sun, 24 Feb 2008 10:33:34 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > But even changing that won't solve the second issue, which is a genuine
> > bug.  There is a race between detect events and suspend events.  The
> > mmc_suspend_host() routine starts out by flushing the kmmcd workqueue
> > before calling the host's suspend routine.  So what happens if another
> > detect event occurs in between?
> > 
> 
> The idea is that host drivers shouldn't do that. Once they've called
> mmc_suspend_host(), then they shouldn't be poking the MMC core in any
> other way. None of this is of course properly documented. :/

Card insert/remove events can be system wake events though.  Which
makes that restriction impractical.

I think hosts need to be able to call mmc_detect_change() as soon as
they see a stable signal.  The MMC core can hold off handling that
for a while, if it needs to wait until the code walking the device
tree gets around to resuming that host.  It's a lot more natural to
hold off such stuff one time there than in N host drivers; especially
since the MMC core already has such hold-off code.

- Dave

