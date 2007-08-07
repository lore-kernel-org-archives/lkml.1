Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbXHGHrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbXHGHrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 03:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbXHGHrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 03:47:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:38114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbXHGHrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 03:47:41 -0400
Date: Tue, 7 Aug 2007 00:42:32 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Denis V. Lunev" <den@sw.ru>, "Denis V. Lunev" <den@openvz.org>,
       dev@openvz.org, devel@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci_get_device call from interrupt in reboot fixups
Message-ID: <20070807074232.GA11682@suse.de>
References: <20070803103924.GA23786@iris.sw.ru> <20070804040806.GF23330@suse.de> <46B6CAC4.3080202@sw.ru> <20070807024910.GB13657@suse.de> <20070807002437.0e7b9ee5.akpm@linux-foundation.org> <20070807004455.b634c5d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807004455.b634c5d0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 12:44:55AM -0700, Andrew Morton wrote:
> On Tue, 7 Aug 2007 00:24:37 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > Andrew, I really don't want to change the PCI core to handle this, as we
> > > finally fixed a lot of issues with drivers trying to walk these lists
> > > from interrupt context.  So if you want to just hide the warning message
> > > as we are shutting down, that's fine with me.  Or just don't do the
> > > fixups.  But grabbing a reference to the pci device is unsafe in my
> > > opinion and I do not want to do that.
> > > 
> > 
> > OK, good decision ;)
> > 
> > One approach would be for some brave soul to pick his way through
> > the reboot code and ensure that we are correctly and reliably setting
> > system_state to SYSTEM_RESTART, then test that in __might_sleep().
> > 
> > But this does suppress somewhat-useful debugging just because of sysrq-B
> > and I really wouldn't want to utilise the horrid system_state any more that
> > we are presently doing.  I think on balance that it would be better if we
> > could do something more targetted, like modify emergency_restart() to test
> > in_interrupt() and to then apologetically set some well-named global flag
> > which will shut up __might_sleep().  Pretty foul, but I can't think of
> > anything better.
> 
> ok, this might be better.  How about we just stop calling mach_reboot_fixups()
> at sysrq-B time?

Fine with me, but what hardware will be messed up because of this?

thanks,

greg k-h
