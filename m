Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYFLFTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYFLFTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 01:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYFLFTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 01:19:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:45597 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYFLFTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:19:15 -0400
Date: Thu, 12 Jun 2008 14:18:30 +0900
To: miles.lane@gmail.com
Cc: Larry.Finger@lwfinger.net, mb@bu3sch.de, vegard.nossum@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>]
 :b43:b43_dma_mapping_error+0x16/0x155
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <a44ae5cd0806102257x61596782tc523de8c866cb58b@mail.gmail.com>
References: <a44ae5cd0806101857q54074c83w2eb470682b58a6cc@mail.gmail.com>
	<484F5DB2.4050705@lwfinger.net>
	<a44ae5cd0806102257x61596782tc523de8c866cb58b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080612142014T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 01:57:30 -0400
"Miles Lane" <miles.lane@gmail.com> wrote:

> > The line that fails is
> >
> > if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
> >
> > The value at 0x58(%eax) is zero, which corresponds to the "struct b43_wldev
> > *dev" line in struct b43_dmaring. In other words, ring->dev is NULL, which
> > causes the error. I'll leave it to FUJITA Tomonori to figure out why.
> 
> Thanks all,
> 
> I might have time in the morning to test one more patch, otherwise I
> will be back in about three weeks.

I think that Michael's patch should fix this bug, which is already in mmotm:

http://userweb.kernel.org/~akpm/mmotm/broken-out/dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix.patch

Miles, are you sure that you use a kernel including the patch?
