Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbXCWWZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbXCWWZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932738AbXCWWZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:25:33 -0400
Received: from mail.kroah.org ([69.55.234.183]:45813 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992593AbXCWWZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:25:18 -0400
Date: Fri, 23 Mar 2007 15:22:07 -0700
From: Greg KH <gregkh@suse.de>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Mitch Williams <mitch.a.williams@intel.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, john.ronciak@intel.com, jesse.brandeburg@intel.com
Subject: Re: [PATCH 2.6.20.3] Flush writes to MSI-X table
Message-ID: <20070323222207.GB22500@suse.de>
References: <1174597699.24177.32.camel@strongmad> <20070323210729.GC12182@suse.de> <46044BB5.7080209@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46044BB5.7080209@intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 02:50:45PM -0700, Kok, Auke wrote:
> Greg KH wrote:
> >On Thu, Mar 22, 2007 at 02:08:19PM -0700, Mitch Williams wrote:
> >>Because both MSI-X interrupt messages and MSI-X table writes are posted,
> >>it's possible for them to cross while in-flight.  This results in
> >>interrupts being received long after the kernel thinks they're disabled,
> >>and in interrupts being sent to stale vectors after rebalancing.
> >>
> >>This patch performs a read flush after writes to the MSI-X table for
> >>enable/disable and rebalancing operations.  Because this is an expensive
> >>operation, we do not perform the read flush after mask/unmask
> >>operations.  Hardware which supports MSI-X typically also supports some
> >>sort of interrupt moderation, so a read-flush is not necessary for
> >>mask/unmask operations.
> >>
> >>This patch has been validated with (unreleased) network hardware which
> >>uses MSI-X.
> >
> >Is this needed for any hardware that is public today?
> 
> yes. Every msi-x capable piece of hardware in the field will crash if it 
> does any form of interrupt balancing. (okay that is not that much stuff out 
> there... I know, but the patch is not that big at all - all it does is 
> subtly add a few read flushes to make sure that critical changes in the 
> msix vector tables are pushed out at the proper time).
> 
> >Also, it seems a bit too big of a patch for -stable right now,
> >especially as the mainline patch will not make it into 2.6.22 at the
> >earliest.
> 
> I think Mitch was way too sensitive when he worded his e-mail. We should 
> really be trying to get this fix into 2.6.21 at least.
> 
> Mitch, can you re-post this and include Eric Biederman, linux-pci, our 
> intel platform guys and perhaps Linus and Andrew?
> 
> A lot of vendors (not just us) will be pushing msi-x capable hardware out, 
> and this fix is absolutely needed. Getting it in soon is really preferred. 
> Not to mention that Mitch has spent well over 8 weeks I think making sure 
> that this is indeed the issue and the proper fix...

Well, I'm sure you can agree that it is _very_ late in the 2.6.21
release cycle to expect to get this in for that kernel.  How about
waiting for 2.6.22 and if it's a big deal, getting it into the
2.6.21-stable tree if needed.

So far I have not seen any bug reports that this patch would fix, have
you?

thanks,

greg k-h
