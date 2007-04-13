Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXDMXDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXDMXDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965672AbXDMXDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:03:55 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:58329 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287AbXDMXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:03:54 -0400
Subject: Re: [RFD] swsusp problem: Drivers allocate much memory during
	suspend (was: Re: 2.6.21-rc5: swsusp: Not enough free memory)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
In-Reply-To: <200704140057.35829.rjw@sisk.pl>
References: <460B6E4B.3060004@gmail.com> <20070413224053.GT28264@elf.ucw.cz>
	 <1176504306.7112.206.camel@nigel.suspend2.net>
	 <200704140057.35829.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 14 Apr 2007 09:03:50 +1000
Message-Id: <1176505430.7112.216.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-04-14 at 00:57 +0200, Rafael J. Wysocki wrote:
> > > > Well, I'm not sure.  First, we don't really know what the value of it should be
> > > > and this alone is a good enough reason for making it tunable, IMHO.  Second, I
> > > > think different systems may need different PAGES_FOR_IO and taking just the
> > > > maximum (even if we learn how much that actually is) seems to be wasteful in
> > > 
> > > Well,  it is wasteful as in "we save slightly smaller image than we
> > > could". That's okay with me.
> > 
> > No. If the driver can't allocate the memory, your call to device_suspend
> > will fail. This isn't about image size but about success or failure to
> > hibernate.
> 
> If we take PAGES_FOR_IO to be the maximum over all possible configurations
> that can hibernate, the majority of systems will just create smaller images than
> they could have created for smaller PAGES_FOR_IO, but all of them will be
> able to hibernate. :-)

You also use PAGES_FOR_IO in enough_free_mem. Say you set it to the 9000
pages I mentioned before (35M). On a machine with 64 megabytes of
memory, you'll never be able to suspend because you'll never satisfy

free > nr_pages + PAGES_FOR_IO + meta

I'll freely admit that 64 megabytes is tiny nowadays, but it's not
completely unknown. The point is really that you're effectively making
swsusp unusable for machines with RAM < (PAGES_FOR_IO * (say) 3). But
what do you set PAGES_FOR_IO to? There'll always be someone with
$WHIZ_BANG_CONFIG who is pushing to have the value increased, and every
increase knocks out more of your lowend users.

Regards,

Nigel

