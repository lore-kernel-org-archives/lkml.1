Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbZDBOFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbZDBOFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZDBOFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:05:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:39013 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbZDBOFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:05:23 -0400
Date: Thu, 2 Apr 2009 23:03:58 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, shemminger@vyatta.com, davej@redhat.com,
       tglx@linuxtronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [Bug 487894] New: sky2 0000:06:00.0: DMA-API: device driver
	frees DMA memory with different size
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090402111839.GE21083@amd.com>
References: <20090402105415.GD21083@amd.com>
	<20090402200634I.fujita.tomonori@lab.ntt.co.jp>
	<20090402111839.GE21083@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090402230346B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 02 Apr 2009 23:03:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 13:18:39 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, Apr 02, 2009 at 08:06:26PM +0900, FUJITA Tomonori wrote:
> > On Thu, 2 Apr 2009 12:54:15 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > On Wed, Apr 01, 2009 at 11:02:45AM -0700, Stephen Hemminger wrote:
> > > > 
> > > > The sky2 driver uses pci_unmap_len and pci_unmap_len_set which on 32 bit
> > > > platforms are meaningless so they are stubbed out. 
> > > > Basically, DMA-API checks are wrong/bogus to enforce on 32bit x86 as is.
> > > 
> > > As far as I know the VT-d driver is available on 32 bit x86 too. So this should
> > > not always be a nop.
> > 
> > VT-d is available on only x86_64.
> 
> At least there was a patch to enable it on 32 bit too. See
> 
> https://lists.linux-foundation.org/pipermail/iommu/2009-February/001080.html
> 
> It seems not to be upstream yet.

It's not in upstream.


Anyway, about the original problem, I think that the best fix is not
to stub out the dma API; using the dma API properly is always a good
thing.
