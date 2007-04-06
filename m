Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbXDFWvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbXDFWvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXDFWvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:51:55 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36579 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294AbXDFWvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:51:54 -0400
Date: Fri, 6 Apr 2007 15:51:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <4616CBF0.7090606@garzik.org>
Message-ID: <Pine.LNX.4.64.0704061546590.6730@woody.linux-foundation.org>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
 <4616CBF0.7090606@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Apr 2007, Jeff Garzik wrote:
> 
> I would rather change the implementation under the hood to start per-CPU
> threads on demand, similar to a thread-pool implementation.
> 
> Boxes with $BigNum CPUs probably won't ever use half of those threads.

The counter-argument is that boxes with $BigNum CPU's really don't hurt 
from it either, and having per-process data structures is often simpler 
and more efficient than trying to have some thread pool.

IOW, once we get the processes off the global list, there just isn't any 
downside from them. Sure, they use some memory, but people who buy 
1024-cpu machines won't care about a few kB per CPU..

So the *only* downside is literally the process list, and one suggested 
patch already just removes kernel threads entirely from the parenthood 
lists.

The other potential downside could be "ps is slow", but on the other hand, 
having the things stick around and have things like CPU-time accumulate is 
probably worth it - if there are some issues, they'd show up properly 
accounted for in a way that process pools would have a hard time doing.

So I really don't think this is worth changing things over, apart from 
literally removing them from process lists, which I think everybody agrees 
we should just do - it just never even came up before!

			Linus
