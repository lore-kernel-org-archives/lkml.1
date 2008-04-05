Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYDEPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYDEPru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbYDEPrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 11:47:41 -0400
Received: from ns.suse.de ([195.135.220.2]:54375 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYDEPrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 11:47:40 -0400
Date: Sat, 5 Apr 2008 08:53:23 -0700
From: Greg KH <gregkh@suse.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080405155323.GA27252@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx> <20080404210132.GA14418@suse.de> <20080405115727.1265e8a9@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080405115727.1265e8a9@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2008 at 11:57:27AM +0200, Pierre Ossman wrote:
> On Fri, 4 Apr 2008 14:01:32 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > 
> > What "global list"?  You mean the one that I just deleted with my
> > patchset that is in -mm and going to be in 2.6.26?  :)
> > 
> 
> *gnn*

Well the "global list" was not being used for anything, and it was being
created at the same time the driver core list was, so unless you wanted
to change the way that all pci devices were probed/created, it would not
have worked out.

> > How will changing the addition of the device to the list affect this
> > behavior?  Do you want to walk the list in your driver's probe function,
> > looking for the "subfunction" that is not yet added to the list?
> > 
> 
> Yes. Things work fine when the driver is loaded after the entire PCI
> bus has been scanned, but not when new cards are hotplugged with the
> driver already present. I'd like the behaviour to be the same in both
> cases.

Why not just create a thread in your driver, or timer, and sleep until
you see the other devices?  If after a certian time you never do, then
bail out.

That should work properly for you for both cases (startup and loading
later.)

thanks,

greg k-h
