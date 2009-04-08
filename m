Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbZDHOKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbZDHOKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760217AbZDHOKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:10:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45211 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364AbZDHOKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:10:15 -0400
Subject: Re: Multiple Tracers
From: Steven Whitehouse <swhiteho@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       axboe@kernel.dk
In-Reply-To: <20090408135312.GR18581@elte.hu>
References: <1239197703.3359.25.camel@localhost.localdomain>
	 <20090408135312.GR18581@elte.hu>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 08 Apr 2009 15:11:39 +0100
Message-Id: <1239199899.3359.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-04-08 at 15:53 +0200, Ingo Molnar wrote:
> * Steven Whitehouse <swhiteho@redhat.com> wrote:
> 
> > Hi,
> > 
> > A little while back I posted a RFC patch which added gfs2 glock 
> > tracing to blktrace. There was a suggestion that I should look 
> > instead at the generic tracing code and add a new tracer, but I've 
> > come up with a couple of issues along the way.
> > 
> > I think from what I can see that its only possible to run a single 
> > tracer at once, so running blktrace (for example) would preclude 
> > me from also tracing gfs2's glocks at the same time. Also, I can 
> > see no mechanism by which I could ensure the sequencing between 
> > the blktrace and glock traces other than exporting the blktrace 
> > sequence number, even if running multiple tracers at the same time 
> > was possible.
> 
> There's a recent addition: the EVENT_TRACE() facility. Would that 
> suit your purposes?
> 
> 	Ingo

If I can get both blktrace and glock trace info from it, then yes. I
thought that the blktrace output went either via the original relayfs
path, or via its own tracer so that it wasn't possible to use it and the
event trace facility at the same time, unless I use blktrace via
relayfs. From what I've read I thought that probably the relayfs
interface for blktrace might eventually be removed in favour of the
generic tracing interface, but I'm not 100% sure of that, so perhaps
someone can confirm the plans in that area?

Even if I did use EVENT_TRACE(), wouldn't I still need to put the
blktrace sequence numbers in my glock messages in order to maintain the
correct ordering?

Perhaps I ought to explain a bit more about what I'd like to do... my
plan was to do some automated testing of GFS2's cache control by
watching the glocks and the block I/O and ensuring that the only blocks
which are read/written are those for which the currently held glocks
allow for. Obviously the exact sequencing between the block I/O and
glocks is critical.

I've used the previously posted patches for some testing here, and
already they have shown their worth with one bug already found & fixed
in the current tree that way.

I have some other ideas too, based on measuring latency between glocks
and I/O events which might be used for future performance
analysis/tuning which would also require something similar,

Steve.


