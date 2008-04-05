Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbYDEJ6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbYDEJ6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 05:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYDEJ56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 05:57:58 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:39765 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYDEJ55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 05:57:57 -0400
Date: Sat, 5 Apr 2008 11:57:27 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080405115727.1265e8a9@mjolnir.drzeus.cx>
In-Reply-To: <20080404210132.GA14418@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
	<20080404210132.GA14418@suse.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008 14:01:32 -0700
Greg KH <gregkh@suse.de> wrote:

> 
> What "global list"?  You mean the one that I just deleted with my
> patchset that is in -mm and going to be in 2.6.26?  :)
> 

*gnn*

> 
> How will changing the addition of the device to the list affect this
> behavior?  Do you want to walk the list in your driver's probe function,
> looking for the "subfunction" that is not yet added to the list?
> 

Yes. Things work fine when the driver is loaded after the entire PCI
bus has been scanned, but not when new cards are hotplugged with the
driver already present. I'd like the behaviour to be the same in both
cases.

> > Is it possible to do this or will things break left and right if I
> > add them to the global list before I register them with the driver core?
> 
> As I mention above, the "global list" is now gone, so it's going to be a
> bit harder to do this.  We now only keep one list of all PCI devices,
> and that is with the driver core mechanisms as the duplicate list was
> just sitting there doing nothing for the past 4 years.
> 

Talk about bad timing...

> So is the problem that your driver need to bind to multiple pci devices
> at the same time in order to work properly?
> 

More or less. Primarily it needs to know which other subfunctions are
there, but in one of the two cases it also needs to fiddle some PCI
config space registers.

> Or is this just really broken hardware?
> 

It is. Deliberately broken in order to work with a certain other broken
operating system.

They have two interfaces for the same piece of hardware, and you need
to make sure you only use one of them or things go south very quickly.
To make things worse, you do not know which of the two will be
available for any given card. Hence the need to scan the bus.

In one of the cases we currently try to disable the secondary
interface, which is done by PCI config space modifications on
subfunction 0.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
