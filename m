Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYFUOyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYFUOyv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYFUOyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:54:41 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3475 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751132AbYFUOyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:54:41 -0400
Date: Sat, 21 Jun 2008 10:54:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
In-Reply-To: <87fxr6yjl4.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.44L0.0806211050390.18735-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jun 2008, Andi Kleen wrote:

> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > This question arises in connection with wireless USB mass-storage
> > devices.  The controller driver requires that all DMA segments
> > in a transfer, other than the last one, have a multiple of 1024 bytes.  
> > But we're sometimes getting s-g lists where an element contains an odd
> > number of 512-byte sectors, and of course it doesn't work.
> 
> But you can handle a single 512 byte request?

Yes.  And we can handle a list containing a bunch of 1024-byte segments
terminated by a single 512-byte segment.

> Splitting the request
> in this case should work. Or maybe copying is cheaper than splitting?

Splitting would work.  But it has to be done fairly high up in the 
stack, ideally in the block layer.

> I don't think the block layer knows about such kinds of restrictions.

Evidently not.  Is it feasible to add such knowledge to the block
layer?

Alan Stern

