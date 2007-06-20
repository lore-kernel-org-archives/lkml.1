Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbXFTRSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbXFTRSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbXFTRS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:18:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbXFTRS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:18:28 -0400
Date: Wed, 20 Jun 2007 10:17:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: Change in default vm_dirty_ratio
In-Reply-To: <1182328536.21117.24.camel@twins>
Message-ID: <alpine.LFD.0.98.0706201015370.3593@woody.linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain> 
 <20070618164711.9de1c38e.akpm@linux-foundation.org>  <20070620042434.GC12096@redhat.com>
  <20070619214407.dfff0ca6.akpm@linux-foundation.org>
 <1182328536.21117.24.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Peter Zijlstra wrote:
> 
> Building on the per BDI patches, how about integrating feedback from the
> full-ness of device queues. That is, when we are happily doing IO and we
> cannot possibly saturate the active devices (as measured by their queue
> never reaching 75%?) then we can safely increase the total dirty limit.

The really annoying things are the one-off things. You've been happily 
working for a while (never even being _close_ to saturatign any IO 
queues), and then you untar a large tree.

If the kernel now let's you dirty lots of memory, you'll have a very 
unpleasant experience.

And with hot-pluggable devices (which is where most of the throughput 
problems tend to be!), the "one-off" thing is not a "just after reboot" 
kind of situation.

So you'd have to be pretty smart about it.

		Linus
