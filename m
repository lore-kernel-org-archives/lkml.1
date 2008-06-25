Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYFYASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYFYASy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 20:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYFYASp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 20:18:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:49833 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYFYASo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 20:18:44 -0400
Date: Wed, 25 Jun 2008 09:18:15 +0900
To: stern@rowland.harvard.edu
Cc: fujita.tomonori@lab.ntt.co.jp, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, antonio.lin@alcormicro.com,
       david.vrabel@csr.com
Subject: Re: Scatter-gather list constraints
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.44L0.0806241050350.2160-100000@iolanthe.rowland.org>
References: <20080624194119H.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.44L0.0806241050350.2160-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080625091813Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 10:57:13 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 24 Jun 2008, FUJITA Tomonori wrote:
> 
> > I don't think that the block layer has the DMA alignment concept in FS
> > I/O path. And I think that you need kinda the DMA padding instead the
> > DMA alignment though again The block layer doesn't have the DMA
> > padding concept in FS I/O path. And the DMA padding applies to only
> > the last SG element.
> > 
> > I guess that it's pretty hard to implement such a strange restriction
> > in the block layer cleanly.
> 
> I don't see why there should be any problem.  It's simply a matter of 
> splitting a single request into multiple requests, at places where 
> the length restriction would be violated.
>
> For example, suppose an I/O request starts out with two S-G elements
> of 1536 bytes and 2048 bytes respectively, and the DMA requirement is
> that all elements except the last must have length divisible by 1024.  
> Then the request could be broken up into three requests of 1024, 512,
> and 2048 bytes.

I can't say that it's easy to implement a clean mechanism to break up
a request into multiple requests until I see a patch.

What I said is that you think that this is about extending something
in the block layer but it's about adding a new concept to the block
layer.


> > The iSER driver has a strange restriction too. I think that as iSER
> > does, bouncing is a better option, though adding some generic
> > mechanism to reserve buffer in the block layer might be nice, I
> > gueess.
> 
> Is it reasonable to have 120-KB bounce buffers?

The block layer does. Why do you think that USB can't?
