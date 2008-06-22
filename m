Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYFVOfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYFVOfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYFVOfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:35:44 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3809 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752587AbYFVOfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:35:43 -0400
Date: Sun, 22 Jun 2008 10:35:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
In-Reply-To: <485D8829.2060901@firstfloor.org>
Message-ID: <Pine.LNX.4.44L0.0806221025220.3610-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008, Andi Kleen wrote:

> 
> >> - Is it performance critical?
> > 
> > For people using wireless USB drives, yes.
> 
> But only if there is a lot of 512 byte block IO? The only case I can think
> of right now would be XFS log IO and perhaps some O_DIRECT/raw device
> accesses.

Sorry, I misunderstood your question.  There probably will not be a lot 
of 512-byte block I/O -- not in the workloads I'm acquainted with.  But 
there will be some.

It isn't performance-critical, in the sense that slowing down the odd
512-byte block transfers won't hurt performance much.  But it is
critical in the sense that the transfers must work properly when they 
do occur.

> If it's only an relative oddball just copying is fine imho.

You mean, have the USB stack allocate bounce buffers and copy the data 
between the S-G buffers (which may be in high memory) and the bounce 
buffers?  We're talking about a potentially fairly large amount of 
data, say up to 100 KB.  Is that really easier than splitting up an I/O 
request?

Alan Stern

