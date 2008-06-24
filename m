Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbYFXO5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbYFXO5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbYFXO5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:57:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38998 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755999AbYFXO5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:57:14 -0400
Date: Tue, 24 Jun 2008 10:57:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
cc: andi@firstfloor.org, <linux-kernel@vger.kernel.org>,
       <antonio.lin@alcormicro.com>, <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
In-Reply-To: <20080624194119H.fujita.tomonori@lab.ntt.co.jp>
Message-ID: <Pine.LNX.4.44L0.0806241050350.2160-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008, FUJITA Tomonori wrote:

> I don't think that the block layer has the DMA alignment concept in FS
> I/O path. And I think that you need kinda the DMA padding instead the
> DMA alignment though again The block layer doesn't have the DMA
> padding concept in FS I/O path. And the DMA padding applies to only
> the last SG element.
> 
> I guess that it's pretty hard to implement such a strange restriction
> in the block layer cleanly.

I don't see why there should be any problem.  It's simply a matter of 
splitting a single request into multiple requests, at places where 
the length restriction would be violated.

For example, suppose an I/O request starts out with two S-G elements
of 1536 bytes and 2048 bytes respectively, and the DMA requirement is
that all elements except the last must have length divisible by 1024.  
Then the request could be broken up into three requests of 1024, 512,
and 2048 bytes.

> The iSER driver has a strange restriction too. I think that as iSER
> does, bouncing is a better option, though adding some generic
> mechanism to reserve buffer in the block layer might be nice, I
> gueess.

Is it reasonable to have 120-KB bounce buffers?

Alan Stern

