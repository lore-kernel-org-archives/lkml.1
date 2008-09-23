Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbYIWSNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbYIWSNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYIWSNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:13:21 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:47987 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993AbYIWSNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:13:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsFANzJ2EhMQWq+/2dsb2JhbACBXrcXgWc
Date: Tue, 23 Sep 2008 14:13:13 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <zanussi@comcast.net>, prasad@linux.vnet.ibm.com,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: Unified tracing buffer
Message-ID: <20080923181313.GA4947@Krystal>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <1221869279.8359.31.camel@lappy.programming.kicks-ass.net> <20080922140740.GB5279@in.ibm.com> <1222094724.16700.11.camel@lappy.programming.kicks-ass.net> <1222147545.6875.135.camel@charm-linux> <1222162270.16700.57.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222162270.16700.57.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:03:24 up 110 days, 22:43,  8 users,  load average: 1.06, 0.89,
	0.74
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Tue, 2008-09-23 at 00:25 -0500, Tom Zanussi wrote:
> 
> > - get rid of anything having to do with padding, nobody needs it and its
> > only affect has been to horribly distort and complicate a lot of the
> > code
> > - get rid of sub-buffers, they just cause confusion
> > - get rid of mmap, nobody uses it
> > - no sub-buffers and no mmap support means we can get rid of most of the
> > callbacks, and a lot of API confusion along with them
> > - add relay flags - they probably should have been used from the
> > beginning and options made explicit instead of being shoehorned into the
> > callback functions.
> 
>  - get rid of the vmap buffers as they cause tlb pressure and eat up
> precious vspace on 32 bit platforms.
> 

Although I agree on the basic idea, namely to use a sane amount of TLB
entries for tracing, I disagree on the way proposed to reach this goal.
Such memory management concerns belong to the mm field and should not be
done "oh so cleverly" by a buffer management infrastructure in the back
of the kernel memory management infrastructure.

I think we should instead try to figure out what is currently missing in
the kernel vmap mechanism (probably the ability to vmap from large 4MB
pages after boot), and fix _that_ instead (if possible), which would not
only benefit to tracing, but also to module support.

Also, I would like to keep a contiguous address mapping within buffers
so we could keep the buffer read/write code as simple as possible,
leveraging the existing CPU MM unit.

I added Christoph Lameter to the CC list, he always comes with clever
ideas. :)

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
