Return-Path: <linux-kernel-owner+w=401wt.eu-S966612AbXEVSuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966612AbXEVSuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbXEVSuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:50:08 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34334 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759055AbXEVSuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:50:07 -0400
Date: Tue, 22 May 2007 11:47:33 -0700
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the
	-stable cycle
Message-ID: <20070522184733.GA9357@kroah.com>
References: <46533314.10206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46533314.10206@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 02:14:44PM -0400, Chuck Ebbert wrote:
> I'd like to propose we allow adding new device IDs as part
> of the -stable process, but only under certain conditions:

Who would be the primary benifactor of this?

The very large majority of users out there use a distro kernel, and they
provide the ids whenever possible as patches to their kernels, _or_ as a
config option at startup that adds the ids to the drivers through sysfs.

> 1) Each device (or group of devices) gets added as a separate
>    patch, i.e. we don't just diff the device tables. This way
>    each original patch that added the device(s) upstream will
>    be become a single patch for -stable.
> 
> 2) Devices that require new features/capabilities in their
>    driver won't be added.

What's wrong with the current sysfs way of adding new device ids without
touching the kernel?  Devices described above was the very reason we
added that functionality, so users would not have to constantly update
their kernel.  The distros provide userspace tools that enable these ids
to be added and at boot time, everything "just works" properly.

So, because of that, I don't really see a need to be adding new device
ids to the -stable tree.

> Candidate patches would be something like these, which together
> add support for the ATI SB700 ATA controller:
> 
> 1)
> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=823777181b4c0200923dcb026efa5b37f55c0ecf
> 
> Adds ATI sb700 quirk, using exactly the same one as sb600.

That's a quirk addition, not a new device id following the above
mentioned rules you set out :)

thanks,

greg k-h
