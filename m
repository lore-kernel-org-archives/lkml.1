Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbYBOJy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbYBOJy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYBOJyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:54:51 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41315 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755727AbYBOJyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:54:49 -0500
Date: Fri, 15 Feb 2008 03:54:45 -0600
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <ak@suse.de>
Cc: clameter@sgi.com, rientjes@google.com, Lee.Schermerhorn@hp.com,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       travis@sgi.com
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
Message-Id: <20080215035445.84be9287.pj@sgi.com>
In-Reply-To: <200802142102.41420.ak@suse.de>
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>
	<Pine.LNX.4.64.0802141126340.375@schroedinger.engr.sgi.com>
	<200802142102.41420.ak@suse.de>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, responding to Christoph, wrote:
> You're saying the kernel should use these relative masks internally?

In a conversation with Christoph Thursday afternoon, I got the
impression that he liked the idea of using some more compact
representation of sparse collections of CPUs (or Nodes) than cpumask_t.
We end up with some big arrays of big cpumask_t's and nodemask_t's,
mostly filled with zero bits ... wasting memory.

I'll agree with Christoph on that, though I'd agree with you that this
bitmap relative operator is probably -not- the key to that more compact
representation.

The place that my thinking grinds to a halt on this is dealing with the
problem that all the more compact representations of a collection of
CPU numbers that I can think of either (1) are variable length (usually
leading to dynamic storage), or (2) impose some artificial restriction
on how many elements they can represent, or perhaps (3) use some
complex data structure to enumerate just the actual elements of the
power set of all cpus (or all nodes) that we actually use, which is
vastly less than the set of all possible subsets of such.

You address this artificial restriction yourself, in another message:
> I would rather just use arrays of integers in this case with a
> reasonable fixed upper limit (e.g. 16 or 32 -- if there are ever
> >32 thread x86 CPUs presumably they will require an updated cpufreq
> driver too...)

That might be the key here.  Perhaps as you suggest we can identify
some places where we can replace sparse cpumask_t's with (fixed length?)
arrays of integers, with little or no practical loss of generality, and
with nice reductions in memory footprint.

Mike Travis <travis@sgi.com> -- do you see some places where replacing
cpumask_t's with fixed arrays of 16 or 32 CPU numbers would be a big
enough win to be worth the effort?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
