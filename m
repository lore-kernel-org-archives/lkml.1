Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYILXFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYILXFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbYILXFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:05:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbYILXFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:05:33 -0400
Message-ID: <48CAF406.5030607@zytor.com>
Date: Fri, 12 Sep 2008 15:58:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <200809121455.02180.rusty@rustcorp.com.au> <48CA7CA8.2000107@sgi.com> <200809130803.00563.rusty@rustcorp.com.au> <48CAF249.2050304@sgi.com>
In-Reply-To: <48CAF249.2050304@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> Here's the thread:
> 
> 	http://marc.info/?l=linux-kernel&m=121976977901223&w=4
> 
> It doesn't seem worthwhile to force all systems to deal with large cpumask's
> if they don't need to.  Passing the value on the stack (actually usually in a
> reg) if it fits into a long makes a lot of sense.
> 
> And I don't think it's that abstract, but I'm willing to hear other opinions.
> 
> Btw, most likely only distros that distribute an "Enterprise" edition of
> Linux will ever set NR_CPUS so high, so the actual number of systems making
> use of this will be a very small percentage (big $$-wise though... ;-) 
> 
> I even think that perhaps BITS_PER_LONG might be too low a threshold to kick
> in this extra code.  A Larabee chip will have 128 cpus so maybe 128 or 256 is
> a better metric...?
> 
> As soon as I get a working kernel with the proposed changes, I will definitely
> be doing perf testing.
> 

If the performance difference isn't significant, then there is a major 
advantage to getting rid of a configuration option.  At that point we 
can basically scale to an arbitrary number of processors in a stock 
configuration.

	-hpa

