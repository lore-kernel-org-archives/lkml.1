Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbXKMWbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbXKMWbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbXKMWa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:30:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32796 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbXKMWa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:30:56 -0500
Date: Tue, 13 Nov 2007 14:22:42 -0800
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
       Guido Guenther <agx@sigxcpu.org>, Kevin Corry <kevcorry@us.ibm.com>,
       stable@kernel.org
Subject: Re: [stable] [2.6.24 PATCH 02/25] dm io:ctl use constant struct
	size
Message-ID: <20071113222242.GB6132@kroah.com>
References: <20071012170509.GM24157@agk.fab.redhat.com> <200710130016.29937.arnd@arndb.de> <20071015012621.GD10006@agk.fab.redhat.com> <200710150934.09842.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710150934.09842.arnd@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 09:34:09AM +0200, Arnd Bergmann wrote:
> On Monday 15 October 2007, Alasdair G Kergon wrote:
> > The underlying ABI is not changing, I hope - the trailing padding in the
> > struct should not affect the processing of the data by dm, and I see no
> > reason to continue maintaining the fiction that the 32-bit and 64-bit
> > ioctls are in some way incompatible with each other when they aren't
> > AFAIK.
> 
> It's a corner case of some sort, as DM uses ioctl numbers differently
> from most subsystems by splitting to code from the size argument
> during processing. Your change is certainly not an _incompatible_
> change to the ABI, but 32 bit binaries compiled against the new
> headers will use different ioctl numbers from those built against
> older headers.
> 
> This may break other code that expects a specific number, even
> if your handler does not care. The old compat code handles both
> variants (no variable size arguments), but /usr/bin/strace may have
> encoded only one set of numbers AFAICT.
> 
> > And yes, a follow-up patch can clean up our use of the compatibility
> > mechanism, going a little bit further than the patch you attached, I
> > hope.
> 
> Ok, sounds good. I don't think it's the kind of patch that should go
> into stable backports though.

Ok, I've not added this patch (2/25) to the queue at all.  If this is
incorrect, please let me know.

thanks,

greg k-h
