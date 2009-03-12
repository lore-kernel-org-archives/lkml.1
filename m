Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZCLN3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZCLN3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZCLN3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:29:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZCLN3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:29:33 -0400
Date: Thu, 12 Mar 2009 09:29:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/4] ring-buffer: only allocate buffers for online cpus
In-Reply-To: <20090311203222.7515107d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0903120925120.3062@gandalf.stny.rr.com>
References: <20090312023720.144716747@goodmis.org> <20090312023936.696105567@goodmis.org> <20090311203222.7515107d.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Mar 2009, Andrew Morton wrote:

> On Wed, 11 Mar 2009 22:37:24 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: save on memory
> > 
> > Currently, a ring buffer was allocated for each "possible_cpus". On
> > some systems, this is the same as NR_CPUS. Thus, if a system defined
> > NR_CPUS = 64 but it only had 1 CPU, we could have possibly 63 useless
> > ring buffers taking up space. With a default buffer of 3 megs, this
> > could be quite drastic.
> > 
> > This patch changes the ring buffer code to only allocate ring buffers
> > for online CPUs.  If a CPU goes off line, we do not free the buffer.
> > This is because the user may still have trace data in that buffer
> > that they would like to look at.
> > 
> > Perhaps in the future we could add code to delete a ring buffer if
> > the CPU is offline and the ring buffer becomes empty.
> > 
> > ...
> >
> > +#ifdef CONFIG_HOTPLUG
> > +#ifdef CONFIG_HOTPLUG
> > +#ifdef CONFIG_HOTPLUG
> > +#ifdef CONFIG_HOTPLUG
> > +#ifdef CONFIG_HOTPLUG
> 
> CONFIG_HOTPLUG_CPU

Oops, well I did have both in my config to 'y'.

Thanks, will fix.

-- Steve

