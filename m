Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbZBFQKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbZBFQKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZBFQJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:09:55 -0500
Received: from sous-sol.org ([216.99.217.87]:48995 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751646AbZBFQJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:09:54 -0500
Date: Fri, 6 Feb 2009 08:08:12 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>,
       fujita.tomonori@lab.ntt.co.jp, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/16] DMA-API debugging facility v2
Message-ID: <20090206160812.GH27684@sequoia.sous-sol.org>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com> <1233874352.8135.12.camel@macbook.infradead.org> <20090206020535.GE27684@sequoia.sous-sol.org> <1233907006.17724.83.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1233907006.17724.83.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> What machine did you get that on?

That's a T400 (I'd expect it's same issue as X200).

> Yeah, I saw one of those. If could be a driver bug, of course -- it
> could be unmapping a range before it's actually finished with it. But
> that's unlikely.

One thing I noticed is many of the faults are the page prior to a
coherent range 0x8000 in length, which seems to correspond to tfd buffer.
No obvious off-by-one error anywhere, and not all faults fit that pattern,
so w/out more iwlagn driver knowledge hard to say if that's meaningful
or just mapping coincidence.

> An alternative explanation... The DMA is aborted¹, and the device
> interrupts us to tell us about it at the _same_ time that the IOMMU
> interrupts us to tell us about the fault. We process the device
> interrupt first, unmap that buffer. And then we process the IOMMU
> interrupt... and the buffer is already gone from the list.

I'd have expected the iommu fault to be delivered first, but hey...

> It might be interesting to make this code also remember and print the
> last range that was unmapped, as well as the currently-mapped ranges.

That's what I was thinking too.  Almost need a flight recorder mode to
see if the range was ever mapped/unmapped.

thanks,
-chris
