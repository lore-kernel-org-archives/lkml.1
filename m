Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYG2Qb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYG2Qb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbYG2QbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:31:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60951 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYG2QbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:31:19 -0400
Date: Tue, 29 Jul 2008 18:31:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Frederik Deweerdt <deweerdt@free.fr>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000002
Message-ID: <20080729163113.GP30344@one.firstfloor.org>
References: <20080725095317.GA12636@skywalker> <20080728222643.GA6339@slug> <1217305335.5553.3.camel@marge.simson.net> <20080729120911.GI30344@one.firstfloor.org> <20080729065635.27630e33@infradead.org> <20080729145348.GN30344@one.firstfloor.org> <20080729083029.094a32cb@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729083029.094a32cb@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > A power saving feature that has a significant trade off between power
> > and performance. 
> 
> do you have numbers to explain "significant tradeoff" ?

I don't have numbers, but from the theory it seems pretty clear. 
When you e.g. have two processes with 6MB cache foot print and 
you have two 2C CPUs with 6MB cache they will fit in cache, but 
with power aware scheduler they won't because both processes will run on 
the single 6MB package.  With NUMA the effect is even worse because
also the memory controllers are not used evenly.
And there's the FSB bandwidth, but that's a secondary issue.
> 
>  
> > This means performance will go down. Perhaps it would be ok on
> > battery, 
> 
> the illusion that power only matters on battery got buried a few years
> ago ;)

My understanding was always that unless you're on battery power saving
features that are enabled by default are not supposed to impact performance
significantly. When the user says impacting performance is ok then
doing that is fine of course, but not by default. And I don't think
that's an illusion. In fact if power saving means losing a lot of performance
people would get discouraged from using it, and surely you don't want that.

-Andi

