Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYFZCGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYFZCGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYFZCGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:06:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:35098 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYFZCGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:06:43 -0400
Date: Thu, 26 Jun 2008 11:06:03 +0900
To: stern@rowland.harvard.edu
Cc: fujita.tomonori@lab.ntt.co.jp, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, antonio.lin@alcormicro.com,
       david.vrabel@csr.com
Subject: Re: Scatter-gather list constraints
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.44L0.0806251017320.2578-100000@iolanthe.rowland.org>
References: <20080625091813Z.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.44L0.0806251017320.2578-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080626110615U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 10:23:00 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 25 Jun 2008, FUJITA Tomonori wrote:
> 
> > > For example, suppose an I/O request starts out with two S-G elements
> > > of 1536 bytes and 2048 bytes respectively, and the DMA requirement is
> > > that all elements except the last must have length divisible by 1024.  
> > > Then the request could be broken up into three requests of 1024, 512,
> > > and 2048 bytes.
> > 
> > I can't say that it's easy to implement a clean mechanism to break up
> > a request into multiple requests until I see a patch.
> 
> And I can't write a patch without learning a lot more about how the
> block core works.
> 
> > What I said is that you think that this is about extending something
> > in the block layer but it's about adding a new concept to the block
> > layer.
> 
> Is it?  What does the block layer do when it receives an I/O request
> that don't satisfy the other constraints (max_sectors or
> dma_alignment_mask, for example)?

As I explained, you need something new.

I don't think that max_sectors works as you expect.

dma_alignment_mask is not used in the FS path. And I think that
dma_alignment_mask doens't solve your problems.


> > > Is it reasonable to have 120-KB bounce buffers?
> > 
> > The block layer does. Why do you think that USB can't?
> 
> Why do you think I think that USB can't?  I didn't ask whether it was
> _possible_; I asked whether it was _reasonable_.

What the block layer does is reasonable with regard to this, I think.
