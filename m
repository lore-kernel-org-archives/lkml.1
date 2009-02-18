Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZBRUrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZBRUrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZBRUrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:47:40 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:33879 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378AbZBRUrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:47:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMFAGgBnElMQWt2/2dsb2JhbACBbtNqhBMG
Date: Wed, 18 Feb 2009 15:47:34 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       pierre-marc.fournier@polymtl.ca
Subject: Re: Moving Userspace RCU (urcu) from GPL to LGPL license
Message-ID: <20090218204734.GB26625@Krystal>
References: <20090218180232.GA21389@Krystal> <20090218200608.GD7011@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090218200608.GD7011@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:42:38 up 48 days, 20:40,  3 users,  load average: 0.33, 0.34,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Feb 18, 2009 at 01:02:32PM -0500, Mathieu Desnoyers wrote:
> > Hi Paul,
> > 
> > I think that it would be good to distribute the userspace rcu work we
> > are currently doing (ref. :
> > http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git) as a
> > LGPL library rather than GPL so it can be linked to the userspace part
> > of the LTTng tracer. We want to provide this tracer as a LGPL library so
> > proprietary applications can link to it and therefore be traceable. The
> > only thing is that we cannot put GPL code into a LGPL library.
> 
> Ouch!  I only have approval for RCU implementations under GPL.  :-(
> 
> One theoretical exception is that GPL covers only distribution.  Of couse,
> several have been known to express strong feelings about this exception.
> The system-library exception would seem to only cover proprietary
> applications that shipped with the platform, so I don't see how it is
> generally useful in this case.
> 
> So, thoughts about the traced proprietary executables not being
> distributed?  Or does the process of tracing them somehow distribute
> them in some situations?  If so, can these situations be feasibly
> avoided by people tracing proprietary applications.
> 
> > The other point is that I use a few low-level primitives from the Linux
> > kernel header (e.g. atomic increment for x86, barrier macros). Those are
> > simple one-liners, but, still, I wonder about the licensing
> > implications. I could simply "rewrite" them, but that would be a shame
> > to have a different primitive implementation of those simple primitives
> > in userspace and in kernel-space just for a licensing question. I would
> > really like to keep the Linux kernel coding-style within this library.
> > So the question would be : are those headers, distributed with the Linux
> > kernel, distributed under GPL license ? Is there any special clause that
> > would permit using their content under LGPL ? If not, would the
> > community see such use favorably ?
> > 
> > Ideas/comments are welcome.
> 
> My understanding is that any file in the Linux source tree that does not
> contain a specific license is licensed GPLv2-only courtesy of the COPYING
> file at the top of the source tree.
> 
> Of course, I am not a lawyer, and even if I was, I doubt that I would
> be permitted to dispense legal advice...
> 
> 							Thanx, Paul
> 

Yes, I think that it's good to limit use of such RCU primitive to
GPL-only applications. It will give them an advantage over proprietary
apps. As far as tracing is concerned, we might be OK with leaving LTTng
userspace libs GPL, but people would have to either create a (slow)
IPC-based wrapper to send the information out of their application or
just to do not distribute their instrumented application.

Mathieu


> > Thanks,
> > 
> > Mathieu
> > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
