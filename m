Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYFJQrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYFJQrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYFJQqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:46:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYFJQqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:46:53 -0400
Date: Tue, 10 Jun 2008 09:42:41 -0700
From: Greg KH <greg@kroah.com>
To: Arthur Jones <ajones@riverbed.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>
Subject: Re: on static kobjects and double frees...
Message-ID: <20080610164241.GA13928@kroah.com>
References: <20080610155848.GS26334@ajones-laptop.nbttech.com> <20080610162341.GA13538@kroah.com> <20080610163800.GA28572@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610163800.GA28572@ajones-laptop.nbttech.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 09:38:00AM -0700, Arthur Jones wrote:
> Hi Greg, ...
> 
> On Tue, Jun 10, 2008 at 09:23:41AM -0700, Greg KH wrote:
> > On Tue, Jun 10, 2008 at 08:58:50AM -0700, Arthur Jones wrote:
> > > Hi Greg,  The edac pci sysfs generic layer uses a static
> > > kobject as a placeholder parent where edac pci drivers
> > > are inserted.
> > 
> > Hm, stop right there.
> > 
> > kobjects are not supposed to be static, bad things happen if you do that
> > (including the kernel itself will warn you about them, unless you gave
> > it an empty release function, and if so, then see
> > Documentation/kobject.txt and prepare to be mocked...)
> 
> OK, I wondered about this, but I didn't see anything
> in Documentation/kobject.txt that said that kobjects
> can not be static.  But now that I've fixed the double
> free bug, I'm seeing the warning you mentioned above...

Hm, there is the following text in that file:
	Because kobjects are dynamic, they must not be declared
	statically or on the stack, but instead, always allocated
	dynamically.  Future versions of the kernel will contain a
	run-time check for kobjects that are created statically and will
	warn the developer of this improper usage.

> I don't know how the current code came to be, so I
> can't speak to your issues below.  But, with these
> pointers, I think I can get things cleaned up properly.

Great, if you want me to review it, I'd be glad to do so.

thanks,

greg k-h
