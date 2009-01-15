Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbZAOV3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbZAOV3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZAOV3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:29:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:38856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091AbZAOV27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:28:59 -0500
Date: Thu, 15 Jan 2009 13:27:07 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, linux-usb@vger.kernel.org
Subject: Re: [patch 00/94] 2.6.28.1 stable review
Message-ID: <20090115212707.GA2983@suse.de>
References: <200901152200.04272.s.L-H@gmx.de> <Pine.LNX.4.44L0.0901151617300.2181-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0901151617300.2181-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 04:19:49PM -0500, Alan Stern wrote:
> On Thu, 15 Jan 2009, Stefan Lippers-Hollmann wrote:
> 
> > Please consider adding the following patch, referring to
> > http://bugzilla.kernel.org/show_bug.cgi?id=12301
> > 
> > commit 2caf7fcdb8532045680f06b67b9e63f0c9613aaa
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Wed Dec 31 11:31:33 2008 -0500
> > 
> >     USB: re-enable interface after driver unbinds
> > 
> >     This patch (as1197) fixes an error introduced recently.  Since a
> >     significant number of devices can't handle Set-Interface requests, we
> >     no longer call usb_set_interface() when a driver unbinds from an
> >     interface, provided the interface is already in altsetting 0.  However
> >     the interface still does get disabled, and the call to
> >     usb_set_interface() was the only thing re-enabling it.  Since the
> >     interface doesn't get re-enabled, further attempts to use it fail.
> > 
> >     So the patch adds a call to usb_enable_interface() when a driver
> >     unbinds and the interface is in altsetting 0.  For this to work
> >     right, the interface's endpoints have to be re-enabled but their
> >     toggles have to be left alone.  Therefore an additional argument is
> >     added to usb_enable_endpoint() and usb_enable_interface(), a flag
> >     indicating whether or not the endpoint toggles should be reset.
> > 
> >     This is a forward-ported version of a patch which fixes Bugzilla
> >     #12301.
> > 
> >     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> >     Reported-by: David Roka <roka@dawid.hu>
> >     Reported-by: Erik Ekman <erik@kryo.se>
> >     Tested-by: Erik Ekman <erik@kryo.se>
> >     Tested-by: Alon Bar-Lev <alon.barlev@gmail.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > This patch seems to fix other USB related issues in 2.6.28 as well, for 
> > example:
> > - random failures to boot from usb-storage (sometimes it works, sometimes 
> >   it's slower to detect the rootfs, sometimes it fails alltogether)
> > - problems to detect USB scanners (Epson snapscan (3490), invoking xsane 
> >   the first time fails to detect the scanner, the second time the scanner 
> >   warms up, but fails to get detected by xsane, the third time it finally 
> >   works - sometimes it works directly).
> > - issues to connect a ZyDAS zd1211rw based USB wlan stick through wpa2psk 
> >   with wpasupplicant.
> > 
> > Adding this patch (slightly backported to 2.6.28) seems to fix these issues
> > reliably. Rediff/ backport below, tested under the circumstances above and 
> > hopefully correct.
> 
> It turns out that this patch isn't sufficient.  Additional changes are 
> needed, as posted here:
> 
> 	http://marc.info/?l=linux-usb&m=123196296431175&w=2
> 
> In principle these two patches should be combined into a single one.  
> Unfortunately the new patch has not yet even been submitted for 
> mainline, let alone accepted, so it can't go into a stable kernel.

Ah, ok, sorry about that.  I need to flush out a .27-stable update next,
and then I can start to tackle my pending USB queue...

thanks,

greg k-h
