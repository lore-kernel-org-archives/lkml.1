Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZAaSPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZAaSPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 13:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZAaSP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 13:15:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:34617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZAaSP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:15:26 -0500
Date: Sat, 31 Jan 2009 10:15:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090131101502.7ce8e7af@infradead.org>
In-Reply-To: <20090131180347.GC5884@nowhere>
References: <20090127001708.GA4815@nowhere>
	<20090126163015.7f879b18@infradead.org>
	<20090131180347.GC5884@nowhere>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 19:03:49 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > one thing to look at for work queues that never get work is to see
> > if they are appropriate for the async function call interface
> > (the only requirement for that is that they need to cope with
> > calling inline in exceptional cases)
> > 
> 
> 
> Hi Arjan,
> 
> There is one thing that make it hard to replace workqueues in such
> cases, there is not guarantee the function will run in user context
> because of this condition:
> 
> if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK)
> 
> I wanted to replace kpsmoused with an async function but I want to
> schedule a slow work that can't be done from irq...

if there is enough value in having a variant that is guaranteed to
always run from a thread we could add that. Likely that needs that the 
caller passes in a bit of memory, but that's not too big a deal.
If there is only 1 in the entire kernel it might not be worth it,
but if it's a common pattern then for sure...

do you have a feeling on how common this is ?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
