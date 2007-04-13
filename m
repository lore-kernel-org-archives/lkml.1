Return-Path: <linux-kernel-owner+w=401wt.eu-S1030862AbXDMWgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030862AbXDMWgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030865AbXDMWgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:36:06 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:50203 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030862AbXDMWgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:36:03 -0400
Subject: Re: [RFD] swsusp problem: Drivers allocate much memory during
	suspend (was: Re: 2.6.21-rc5: swsusp: Not enough free memory)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
In-Reply-To: <200704140035.36355.rjw@sisk.pl>
References: <460B6E4B.3060004@gmail.com> <200704132241.52725.rjw@sisk.pl>
	 <20070413221016.GQ28264@elf.ucw.cz>  <200704140035.36355.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 14 Apr 2007 08:36:00 +1000
Message-Id: <1176503760.7112.194.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2007-04-14 at 00:35 +0200, Rafael J. Wysocki wrote:
> On Saturday, 14 April 2007 00:10, Pavel Machek wrote:
> > Hi!
> > 
> > > > > Well, it looks like someone allocated about 6000 pages after we had freed
> > > > > enough memory for suspending.
> > > > 
> > > > We have a tunable allowance in Suspend2 for this, because fglrx
> > > > allocates a lot of pages in its suspend routine if DRI is enabled. I
> > > > think some other drivers do too, but fglrx is the main one I know.
> > > 
> > > I wasn't aware of that, thanks for the information.
> > > 
> > > I think this means we'll probably need to add a tunable, similar to image_size,
> > > that will allow the users to specify how much spare memory they want to reserve
> > > for suspending (instead of the constant PAGES_FOR_IO).  IMO we can call it
> > > 'spare_memory'.
> > 
> > Just increase PAGES_FOR_IO. This should not be tunable.
> 
> Well, I'm not sure.  First, we don't really know what the value of it should be
> and this alone is a good enough reason for making it tunable, IMHO.  Second, I
> think different systems may need different PAGES_FOR_IO and taking just the
> maximum (even if we learn how much that actually is) seems to be wasteful in
> the vast majority of cases.  Finally, I think it may be possible to speed up
> image saving by increasing PAGES_FOR_IO without playing with the
> image size and we can let the user try it (think of distro kernels that are
> compiled for many different users).

It does vary according to the amount of video memory used for DRM, if I
understand correctly.

Nigel

