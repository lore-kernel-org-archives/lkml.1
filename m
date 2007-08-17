Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbXHQP5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbXHQP5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbXHQP4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:56:52 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:59632 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756943AbXHQP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:56:50 -0400
Date: Fri, 17 Aug 2007 11:56:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] Linux Kernel Markers - Documentation
Message-ID: <20070817155645.GB29458@Krystal>
References: <20070812151052.704221166@polymtl.ca> <20070812151221.048605202@polymtl.ca> <y0my7ggldi9.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0my7ggldi9.fsf@ton.toronto.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:43:14 up 18 days, 16:02,  3 users,  load average: 0.66, 1.67, 1.59
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> 
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > [...]
> > +A marker placed in your code provides a hook to call a function (probe) that
> > +you can provide at runtime. A marker can be "on" (a probe is connected to it)
> > +or "off" (no probe is attached). When a marker is "off" it has no
> > +effect. [...]
> 
> Add something like, ", except for a (how?) small time/space penalty."
> 

Yup, good idea. I plan to add:

When a marker is "off" it has no effect, except for adding a tiny time
penality (checking a condition for a branch) and space penality (adding
a few bytes for the function call at the end of the instrumented
function and adds a data structure in a separate section). The
immediate values are used to minimize the impact on data cache, encoding
the condition in the instruction stream.

> > +[...]
> > +trace_mark(subsystem_event, "%d %s", someint, somestring);
> > +Where :
> > +- subsystem_event is an identifier unique to your event
> > +    - subsystem is the name of your subsystem.
> > +    - event is the name of the event to mark.
> > +[...]
> 
> It would be useful to clarify that this "subsystem_event" scheme is
> only a suggested naming convention intended to limit collisions.
> 

Sure. Adding:

The naming scheme "subsystem_event" is suggested here as a convention
intended to limit collisions.



> > +Connecting a function (probe) to a marker is done by providing a
> > probe +(function to call) for the specific marker through
> > marker_probe_register() and +can be activated by calling
> > marker_arm().
> 
> It would help to spell out the nature of the marker namespace.  Is it
> global to the kernel?  Per-module?  Are conflicting "subsystem_event"
> names but different format strings considered separate markers?
> 

What do you think of :

Marker names are global to the kernel: they are considered as being the
same whether they are in the core kernel image or in modules.
Conflicting format strings for markers with the same name will cause the
markers to be detected to have a different format string not to be armed
and will output a printk warning which identifies the inconsistency:

"Format mismatch for probe probe_name (format), marker (format)"



> > + [...] Marker disactivation [...]
> 
> "deactivation"
> 

Thanks for the review,

Mathieu


> - FChE

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
