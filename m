Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbYFLFTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbYFLFTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 01:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYFLFTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 01:19:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:45594 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYFLFTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:19:13 -0400
Date: Thu, 12 Jun 2008 14:18:32 +0900
To: mb@bu3sch.de
Cc: fujita.tomonori@lab.ntt.co.jp, vegard.nossum@gmail.com,
       miles.lane@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>]
 :b43:b43_dma_mapping_error+0x16/0x155
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200806111205.10433.mb@bu3sch.de>
References: <200806101650.27180.mb@bu3sch.de>
	<20080611095844J.fujita.tomonori@lab.ntt.co.jp>
	<200806111205.10433.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080612142235A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 12:05:10 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> On Wednesday 11 June 2008 02:58:44 FUJITA Tomonori wrote:
> > On Tue, 10 Jun 2008 16:50:26 +0200
> > Michael Buesch <mb@bu3sch.de> wrote:
> > 
> > > On Tuesday 10 June 2008 16:42:41 Vegard Nossum wrote:
> > > > This change comes from
> > > > 
> > > > commit 353c409463ecba63c3a41a992d3f5fba935eada9
> > > > Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > Date:   Fri May 23 19:02:30 2008 +0000
> > > 
> > > 
> > > Ok, FUJITA Tomonori, please make sure a patch like the following goes
> > > into the same trees that you submitted commit 353c409 to.
> > > Also make sure to check b43legacy. I _guess_ you might have added
> > > the same bug there.
> > 
> > Ah, sorry about the bug.
> > 
> > From a quick look, mainline needs the same fix too?
> > 
> > b43_dma_mapping_error calls unmap_descbuffer() on the failure, which
> > assumes that ring->dev is set up properly.
> 
> Yeah ok. That's an unlikely error path.

Yeah, it doesn't always happen, but it possible that it happens?


> The new bug is in the main path which will always trigger.

Right.


> Next time please send _any_ patch for review to me and to the wireless list.
> Please tell me which trees this bug has been merged to. Is it already in
> Linus' tree?

No, seems that there are some confusion. This is just in -mm to find
problems:

http://userweb.kernel.org/~akpm/mmotm/broken-out/dma-mapping-add-the-device-argument-to-dma_mapping_error.patch

This patch is a trivial but changes lots of places. So it's difficult
to get an ACK on all the places.

This patch need several fixes but all the patches are trivial except
for b34. I guess that it is because b34 handles devices for
dma-mapping in an uncommon way.

http://userweb.kernel.org/~akpm/mmotm/broken-out/dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
