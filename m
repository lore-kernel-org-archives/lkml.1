Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbXLCLuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbXLCLuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 06:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXLCLuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 06:50:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38363 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbXLCLuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 06:50:12 -0500
Date: Mon, 3 Dec 2007 12:50:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@argo.co.il>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071203115010.GA2986@one.firstfloor.org>
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com> <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de> <47539030.10600@argo.co.il> <20071203095022.GA28560@one.firstfloor.org> <4753ECA5.2010604@argo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4753ECA5.2010604@argo.co.il>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 01:46:45PM +0200, Avi Kivity wrote:
> If you have 10M packets/sec no amount of cycle-saving will help you.  
> You need high level optimizations like TSO.  I'm not saying we should 
> sacrifice cycles like there's no tomorrow, but the big wins are elsewhere.

Both high and low level optimizations are needed for good performance.

> >Similar with highend routing or in some latency sensitive network
> >applications (e.g. in HPC). 
> 
> True.  And here, the hardware can cut hundreds of cycles by avoiding the 
> kernel completely for the fast path.

A lot of applications don't and the user space networking schemes
tend to have their own drawbacks anyways.

> >Another simple noticeable case is Unix
> >sockets and your X server communication.
> 
> Your reflexes are *much* better than mine if you can measure half a 
> nanosecond on X.

That's not about mouse/keyboard input, but about all X protocol communication
between X clients and X server. The key is not large copies here 
anyways (large data is put into shm) but latency.

> And again the key is batching, improving cpu affinity, and caching, not 
> looking for a faster instruction sequence.

That's not the whole story no. Batching etc are needed, but the
faster instruction sequences are needed too. 

> Nanooptimizations are fun (I do them myself, I admit) but that's not 
> where performance as measured by the end user lies.

It depends. Often high level (and then caching) optimizations are better 
bang for the buck, but completely disregarding the fast path work is a bad 
thing too. As an example see Christoph's recent work on the slub fastpath
which makes a quite measurable difference on benchmarks.


-Andi

