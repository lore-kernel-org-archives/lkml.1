Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbZE2UdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbZE2UdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbZE2UdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:33:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZE2UdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:33:08 -0400
Subject: Re: comments on Performance Counters for Linux (PCL)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <1243527919.6645.75.camel@laptop>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
	 <1243527919.6645.75.camel@laptop>
Content-Type: text/plain
Date: Fri, 29 May 2009 22:32:22 +0200
Message-Id: <1243629142.6645.108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 18:25 +0200, Peter Zijlstra wrote:
> >   10/ Group event buffer entry
> > 
> >        This is activated by setting the PERF_RECORD_GROUP in the record_type
> >        field.  With this bit set, the values of the other members of the
> >        group are stored sequentially in the buffer. To help figure out which
> >        value corresponds to which event, the current implementation also
> >        stores the raw encoding of the event.
> > 
> >        The event encoding does not help figure out which event the value refers
> >        to. There can be multiple events with the same code. This does fit the
> >        API model where events are identified by file descriptors.
> > 
> >        The file descriptor must be provided and not the raw encoding.
> 
> OK, sounds sensible.

This can't actually be done, fds can change, and there is no struct
file* to fd map.

If the config isn't good enough, the best we could do is something
unique per instance.

