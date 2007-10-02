Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbXJBWkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbXJBWkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbXJBWkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:40:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:11223 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbXJBWkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:40:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,221,1188802800"; 
   d="scan'208";a="161030993"
Message-ID: <4702C897.3030301@linux.intel.com>
Date: Tue, 02 Oct 2007 15:39:19 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Anders Bostr?m <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: high load average when idle
References: <20071002.233731.119908363.anders@bostrom.dyndns.org> <20071002150748.906970bc.akpm@linux-foundation.org> <alpine.LFD.0.999.0710021514040.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710021514040.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> I wonder if the whole "round_jiffies()" thing should be written so that it 
> never rounds down, or at least never rounds down to before the current 
> second!

that's what it is supposed to do already...

166
167         if (j <= jiffies) /* rounding ate our timeout entirely; */
168                 return original;
169         return j;
170 }

so there is always a gap of at least 1 jiffie no matter what


> 
> I have to say, I also think it's a bit iffy to do "round_jiffies()" at all 
> in that per-CPU kind of way. The "per-cpu" thing is quite possibly going 
> to change by the time we actually add the timer, so the goal of trying to 
> get wakeups to happen in "bunches" per CPU should really be done by 
> setting a flag on the timer itself - so that we could do that rounding 
> when the timer is actually added to the per-cpu queues!

it's pretty much the same thing though
