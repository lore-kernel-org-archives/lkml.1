Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYGOW7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYGOW7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYGOW7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:59:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbYGOW73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:59:29 -0400
Date: Tue, 15 Jul 2008 18:59:17 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: David Miller <davem@davemloft.net>
cc: andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <20080715.153751.71531968.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0807151845360.23237@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807141903001.2825@devserv.devel.redhat.com>
 <20080714.183116.121978835.davem@davemloft.net>
 <Pine.LNX.4.64.0807151830290.22181@devserv.devel.redhat.com>
 <20080715.153751.71531968.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, David Miller wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Tue, 15 Jul 2008 18:32:37 -0400 (EDT)
> 
> > On Mon, 14 Jul 2008, David Miller wrote:
> > 
> > > From: Mikulas Patocka <mpatocka@redhat.com>
> > > Date: Mon, 14 Jul 2008 19:16:17 -0400 (EDT)
> > > 
> > > > So the question is: to reduce number of requests by 12% on an outdated 
> > > > SCSI card, it is sensible to maintain complicated merge accounting logic 
> > > > in the core block layer? To me, it doesn't seem sensible.
> > > 
> > > Rip out the code if you like, then.  I really don't have time to
> > > work on this myself.  So if you do, by all means do whatever
> > > you think is appropriate.
> > 
> > So add signed-off line and forward it to Linus.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> I said remove code, not turn if off.

Removing the code from the block layer needs to be ACKed by block 
maintainers --- and it can be done if it will be found that on 
architectures that use it (alpha, pa-risc) it has no benefit. I believe 
that it will eventually show up that there is little/no benefit from the 
hw_segments accounting, but it will take some time.

This patch is a simple fix that can be done now to stop sparc64 from 
crashing. (most other architectures also define it as 0 --- for the same 
reason, they can't guarantee that the merge will happen).

> I guess you didn't like that option even though you seem heavily 
> convinced that it buys us essentially nothing, and I'm even starting to 
> agree with you.
> 
> If the VMERGE code is going to stay, and it's a bug or a limitation in
> the sparc64 IOMMU code, I'd rather that get fixed.

So if it stays and if you find time to fix it, you can revert it back to 
8192.

But until one of two possible solutions happen (removing the virtual merge 
accounting or declaring that it must stay and fixing sparc64), the 
simplest way to avoid crashes is to define BIO_VMERGE_BOUNDARY 0.

> I have FUJITA's excellent analysis of the sparc64 specific IOMMU issue
> in my inbox and I intend to have a look at it when I get a chance.

Mikulas
