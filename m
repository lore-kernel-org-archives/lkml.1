Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445Ab0ADR4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0ADR4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157Ab0ADR4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:56:15 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:50857 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601Ab0ADR4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:56:14 -0500
Date: Mon, 4 Jan 2010 12:51:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to
	dynamically allocate counters
Message-ID: <20100104175105.GA15195@Krystal>
References: <20091218222617.384355422@quilx.com> <20091218222651.319887863@quilx.com> <4B2F2820.5030904@kernel.org> <alpine.DEB.2.00.0912220956340.12163@router.home> <4B317B5E.1010500@kernel.org> <alpine.DEB.2.00.1001041121570.7191@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1001041121570.7191@router.home>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:48:55 up 19 days,  2:07,  5 users,  load average: 0.05, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> On Wed, 23 Dec 2009, Tejun Heo wrote:
> 
> > On 12/23/2009 12:57 AM, Christoph Lameter wrote:
> > > On Mon, 21 Dec 2009, Tejun Heo wrote:
> > >
> > >>
> > >>> Index: linux-2.6/kernel/trace/ring_buffer.c
> > >>> ===================================================================
> > >>> --- linux-2.6.orig/kernel/trace/ring_buffer.c	2009-12-18 13:13:24.000000000 -0600
> > >>> +++ linux-2.6/kernel/trace/ring_buffer.c	2009-12-18 14:15:57.000000000 -0600
> > >>> @@ -12,6 +12,7 @@
> > >>>  #include <linux/hardirq.h>
> > >>>  #include <linux/kmemcheck.h>
> > >>>  #include <linux/module.h>
> > >>> +#include <asm/local.h>
> > >>
> > >> This doesn't belong to this patch, right?  I stripped this part out,
> > >> added Cc: to Rusty and applied 1, 2, 7 and 8 to percpu branch.  I'll
> > >> post the updated patch here. Thanks.
> > >
> > > If you strip this part out then ringbuffer.c will no longer compile
> > > since it relies on the "#include <local.h>" that is removed by this patch
> > > from the module.h file.
> >
> > Oh... alright.  I'll add that comment and drop the offending chunk and
> > recommit.
> 
> So we need a separate patch to deal with remval of the #include
> <asm/local.h> from modules.h?
> 

I think this would make sense, yes. This would be a patch specific to
the ring-buffer code that would go through (or be acked by) Steven.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
