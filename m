Return-Path: <linux-kernel-owner+w=401wt.eu-S965661AbXDMWx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661AbXDMWx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965662AbXDMWx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:53:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49054 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965661AbXDMWx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:53:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Subject: Re: [RFD] swsusp problem: Drivers allocate much memory during suspend (was: Re: 2.6.21-rc5: swsusp: Not enough free memory)
Date: Sat, 14 Apr 2007 00:57:35 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
References: <460B6E4B.3060004@gmail.com> <20070413224053.GT28264@elf.ucw.cz> <1176504306.7112.206.camel@nigel.suspend2.net>
In-Reply-To: <1176504306.7112.206.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704140057.35829.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 April 2007 00:45, Nigel Cunningham wrote:
> Hi.
> 
> On Sat, 2007-04-14 at 00:40 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > > > > Well, it looks like someone allocated about 6000 pages after we had freed
> > > > > > > enough memory for suspending.
> > > > > > 
> > > > > > We have a tunable allowance in Suspend2 for this, because fglrx
> > > > > > allocates a lot of pages in its suspend routine if DRI is enabled. I
> > > > > > think some other drivers do too, but fglrx is the main one I know.
> > > > > 
> > > > > I wasn't aware of that, thanks for the information.
> > > > > 
> > > > > I think this means we'll probably need to add a tunable, similar to image_size,
> > > > > that will allow the users to specify how much spare memory they want to reserve
> > > > > for suspending (instead of the constant PAGES_FOR_IO).  IMO we can call it
> > > > > 'spare_memory'.
> > > > 
> > > > Just increase PAGES_FOR_IO. This should not be tunable.
> > > 
> > > Well, I'm not sure.  First, we don't really know what the value of it should be
> > > and this alone is a good enough reason for making it tunable, IMHO.  Second, I
> > > think different systems may need different PAGES_FOR_IO and taking just the
> > > maximum (even if we learn how much that actually is) seems to be wasteful in
> > 
> > Well,  it is wasteful as in "we save slightly smaller image than we
> > could". That's okay with me.
> 
> No. If the driver can't allocate the memory, your call to device_suspend
> will fail. This isn't about image size but about success or failure to
> hibernate.

If we take PAGES_FOR_IO to be the maximum over all possible configurations
that can hibernate, the majority of systems will just create smaller images than
they could have created for smaller PAGES_FOR_IO, but all of them will be
able to hibernate. :-)

Greetings,
Rafael
