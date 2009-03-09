Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbZCINRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbZCINRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 09:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZCINRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 09:17:00 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37629 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022AbZCINQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 09:16:59 -0400
Date: Mon, 9 Mar 2009 08:16:56 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: access to efi reserved memory type
Message-ID: <20090309131656.GK10460@sgi.com>
References: <E1Lfe8A-00056c-SH@eag09.americas.sgi.com> <49B44BE8.1080700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B44BE8.1080700@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 03:51:20PM -0700, H. Peter Anvin wrote:
> Cliff Wickman wrote:
...
> > The walk() function scans the EFI memory map and does a callback to a
> > specified function for each memory area of a specified type.
> > efi_memmap_walk_reserved() provides a scan for type EFI_RESERVED_TYPE.
> >  (an earlier version of this patch had proposed a new EFI type, but
> >   EFI_RESERVED_TYPE should be sufficient, given that the firmware follows
> >   the standard and does not use such memory for its own purposes)
...
> In particular, I really want to know why a plain platform device is
> insufficient, and look for a better solution than this, using the
> generic memory map interfaces rather than something EFI-specific.

For the driver Cliff is referring to, we are attempting to provide EFI
reserved memory to a special hardware (drivers/misc/sgi-gru) device
which is capable of handling pages up to 1TB in size.  Additionally, a
previously posted xpmem driver could make those pages available via
Numalink to other SSIs connected to the same fabric.

Excuse my ignorance, but what do you mean by a "plain platform device"?
By generic memory map interfaces, are you proposing we use order based
allocations?  If so, how do you propose we zero these 1TB (worst case)
size pages.  Our current estimate is this will take approx 20 minutes,
but newer processors might shorten that.  What assurances can we get on
these large pages not getting fragmented and therefore becoming useless
and requiring a reboot to reclaim.

I believe we have a special case of memory needing to be reserved by
BIOS, passed to a special driver which can utilize the GRU for async
zero on allocation and to prevent unintended fragmentation.  I agree we
probably made a small mistake in our submission in that the patch set
which adds the EFI walk should have included the special purpose driver.
We will work to correct that.

Thanks,
Robin
