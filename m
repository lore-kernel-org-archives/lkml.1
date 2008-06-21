Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbYFUPVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbYFUPVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 11:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYFUPVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 11:21:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49150 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYFUPVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 11:21:14 -0400
Message-ID: <485D1C67.7050907@firstfloor.org>
Date: Sat, 21 Jun 2008 17:21:11 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
References: <Pine.LNX.4.44L0.0806211050390.18735-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806211050390.18735-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sat, 21 Jun 2008, Andi Kleen wrote:
> 
>> Alan Stern <stern@rowland.harvard.edu> writes:
>>
>>> This question arises in connection with wireless USB mass-storage
>>> devices.  The controller driver requires that all DMA segments
>>> in a transfer, other than the last one, have a multiple of 1024 bytes.  
>>> But we're sometimes getting s-g lists where an element contains an odd
>>> number of 512-byte sectors, and of course it doesn't work.
>> But you can handle a single 512 byte request?
> 
> Yes.  And we can handle a list containing a bunch of 1024-byte segments
> terminated by a single 512-byte segment.
> 
>> Splitting the request
>> in this case should work. Or maybe copying is cheaper than splitting?
> 
> Splitting would work.  But it has to be done fairly high up in the 
> stack, ideally in the block layer.

That's true. Or you would need to reserve requests for this, which is likely
a bad idea. Perhaps you're better off just copying in this (hopefully
rare) case. Fortunately lately thanks to work from Peter Z. allocating memory
in the write out path is much safer than it used to be.

Also for my edification: is that a general restriction of the wireless usb
spec or just a specific hardware quirk in some design?

> 
>> I don't think the block layer knows about such kinds of restrictions.
> 
> Evidently not.  Is it feasible to add such knowledge to the block
> layer?

You would need to ask Jens, but I would assume he would ask:
- Is it common?
- Is it performance critical?
and presumably the answer to both would be "no" ?

-Andi


