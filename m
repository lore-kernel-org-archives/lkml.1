Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbXJZBPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbXJZBPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbXJZBOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:14:51 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:50571 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761360AbXJZBOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:14:50 -0400
Subject: Re: Is gcc thread-unsafe?
From: Zachary Amsden <zach@vmware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0710251651550.30120@woody.linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au>
	 <200710260116.10904.ak@suse.de>
	 <alpine.LFD.0.999.0710251628440.30120@woody.linux-foundation.org>
	 <200710260142.37902.ak@suse.de>
	 <alpine.LFD.0.999.0710251651550.30120@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 18:15:38 -0700
Message-Id: <1193361338.9793.37.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 16:57 -0700, Linus Torvalds wrote:
> 
> On Fri, 26 Oct 2007, Andi Kleen wrote:
> > 
> > The conditional add/sub using carry trick is not generally bogus. 
> > But for registers it's a fine optimization.
> 
> For registers it's fine. For memory, it's a disaster. It's more than just 
> dirty cachelines and introducing race conditions, it's also about 
> protection and dirty pages.
> 
> So even in user space, to even be correct in the first place, the compiler 

It's actually a fair bit worse for us.  We have paths where a false
optimization like this would hyperspace the machine.  In fact, this
frightens me so much I've just gone off to investigate whether gcc has
gone and done this to any of our code.

Clearly the right solution is to introduce threads and write protected
memory into gcc so that the developers are either motivated to ensure
they work or self-destruct.

Zach

