Return-Path: <linux-kernel-owner+w=401wt.eu-S1161479AbXBHIJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161479AbXBHIJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161541AbXBHIJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:09:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60956 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161479AbXBHIJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:09:06 -0500
Date: Thu, 8 Feb 2007 00:08:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, clameter@sgi.com,
       GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [BUG][PATCH] fix mempolcy's check on a system with
 memory-less-node take2
Message-Id: <20070208000857.7296b94b.akpm@linux-foundation.org>
In-Reply-To: <200702080903.46242.ak@suse.de>
References: <20070208110606.ebf668d3.kamezawa.hiroyu@jp.fujitsu.com>
	<200702080849.42167.ak@suse.de>
	<20070208000001.9e303a1a.akpm@linux-foundation.org>
	<200702080903.46242.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 09:03:46 +0100 Andi Kleen <ak@suse.de> wrote:

> On Thursday 08 February 2007 09:00, Andrew Morton wrote:
> > On Thu, 8 Feb 2007 08:49:41 +0100 Andi Kleen <ak@suse.de> wrote:
> > 
> > > 
> > > > This panic(hang) was found by a numa test-set on a system with 3 nodes, where
> > > > node(2) was memory-less-node.
> > > 
> > > I still think it's the wrong fix -- just get rid of the memory less node.
> > 
> > "Let's break it even more"?
> 
> I still don't get what you believe what would be broken then.

A node with no memory is physical reality.  The kernel should do its best
handle and report it accurately.  Pretending that the CPUs on that node are
local to a different node's memory (as I understand your proposal) goes
against that.

> > > I expect you'll likely run into more problems with that setup anyways.
> > 
> > What happens if he doesn't run into more problems?
> 
> Then he's lucky. I ran into problems at least when I still had the empty
> nodes some time ago on x86-64.  Christoph said SN2 is doing the same.
> 
> iirc slab blew up at least, but that  might be fixed by now. But it's a little risky 
> because there is more code now that is node aware.
> 

Well...  I'd suggest that we try to struggle on, get it working.  Is there
a downside to doing that?  
