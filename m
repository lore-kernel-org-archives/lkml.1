Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXDNJaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXDNJaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 05:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXDNJaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 05:30:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50367 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbXDNJaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 05:30:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: [RFD] swsusp problem: Drivers allocate much memory during suspend (was: Re: 2.6.21-rc5: swsusp: Not enough free memory)
Date: Sat, 14 Apr 2007 11:33:32 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
References: <460B6E4B.3060004@gmail.com> <200704140057.35829.rjw@sisk.pl> <1176505430.7112.216.camel@nigel.suspend2.net>
In-Reply-To: <1176505430.7112.216.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704141133.33366.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 April 2007 01:03, Nigel Cunningham wrote:
> Hi.
> 
> On Sat, 2007-04-14 at 00:57 +0200, Rafael J. Wysocki wrote:
> > > > > Well, I'm not sure.  First, we don't really know what the value of it should be
> > > > > and this alone is a good enough reason for making it tunable, IMHO.  Second, I
> > > > > think different systems may need different PAGES_FOR_IO and taking just the
> > > > > maximum (even if we learn how much that actually is) seems to be wasteful in
> > > > 
> > > > Well,  it is wasteful as in "we save slightly smaller image than we
> > > > could". That's okay with me.
> > > 
> > > No. If the driver can't allocate the memory, your call to device_suspend
> > > will fail. This isn't about image size but about success or failure to
> > > hibernate.
> > 
> > If we take PAGES_FOR_IO to be the maximum over all possible configurations
> > that can hibernate, the majority of systems will just create smaller images than
> > they could have created for smaller PAGES_FOR_IO, but all of them will be
> > able to hibernate. :-)
> 
> You also use PAGES_FOR_IO in enough_free_mem. Say you set it to the 9000
> pages I mentioned before (35M). On a machine with 64 megabytes of
> memory, you'll never be able to suspend because you'll never satisfy
> 
> free > nr_pages + PAGES_FOR_IO + meta

Well, in fact our tunable would need to be independent of PAGES_FOR_IO so that
the memory shrinker could free some spare memory for the drivers.

> I'll freely admit that 64 megabytes is tiny nowadays, but it's not
> completely unknown. The point is really that you're effectively making
> swsusp unusable for machines with RAM < (PAGES_FOR_IO * (say) 3). But
> what do you set PAGES_FOR_IO to? There'll always be someone with
> $WHIZ_BANG_CONFIG who is pushing to have the value increased, and every
> increase knocks out more of your lowend users.

Yes, that's why I said I wasn't sure whether or not the additional tunable was
needed.

Still, with the notifiers we have a chance to handle the problem automatically
and the tunable would require the user to set the right value.

Greetings,
Rafael
