Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYILWvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYILWvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbYILWuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:50:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43408 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753614AbYILWuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:50:52 -0400
Message-ID: <48CAF249.2050304@sgi.com>
Date: Fri, 12 Sep 2008 15:50:49 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] CPUMASK: proposal for replacing cpumask_t
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <200809121455.02180.rusty@rustcorp.com.au> <48CA7CA8.2000107@sgi.com> <200809130803.00563.rusty@rustcorp.com.au>
In-Reply-To: <200809130803.00563.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Saturday 13 September 2008 00:28:56 Mike Travis wrote:
>> Rusty Russell wrote:
>>> I'm yet to be convinced that we really need to allocate cpumasks in any
>>> fast paths.  And if not, we should simply allocate them everywhere.  I'd
>>> rather see one #ifdef around a place where we can show a perf issue.
>> Using a typedef came from Linus, and the idea is basically if NR_CPUS fits
>> into a long, then it's carried as an array of one (ie., local variable).
> 
> Sure it's clever.  ie. nice and confusing.
> 
> But do we have any code paths where we care?  Unless we do, let's just keep it 
> simple...
> 
> Cheers,
> Rusty.

Here's the thread:

	http://marc.info/?l=linux-kernel&m=121976977901223&w=4

It doesn't seem worthwhile to force all systems to deal with large cpumask's
if they don't need to.  Passing the value on the stack (actually usually in a
reg) if it fits into a long makes a lot of sense.

And I don't think it's that abstract, but I'm willing to hear other opinions.

Btw, most likely only distros that distribute an "Enterprise" edition of
Linux will ever set NR_CPUS so high, so the actual number of systems making
use of this will be a very small percentage (big $$-wise though... ;-) 

I even think that perhaps BITS_PER_LONG might be too low a threshold to kick
in this extra code.  A Larabee chip will have 128 cpus so maybe 128 or 256 is
a better metric...?

As soon as I get a working kernel with the proposed changes, I will definitely
be doing perf testing.

Thanks,
Mike
