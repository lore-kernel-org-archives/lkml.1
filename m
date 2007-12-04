Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbXLDTp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbXLDTp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXLDTpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:45:10 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:36536 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbXLDTpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:45:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAEc9VUdMROHU/2dsb2JhbACBWg
Date: Tue, 4 Dec 2007 14:45:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, mmlnx@us.ibm.com,
       dipankar@in.ibm.com, dsmith@redhat.com, paulmck@us.ibm.com
Subject: Re: [patch 1/2] Linux Kernel Markers - Support Multiple Probes
Message-ID: <20071204194506.GA1431@Krystal>
References: <20071204181845.895090222@polymtl.ca> <20071204182402.940135178@polymtl.ca> <20071204110648.dd918789.akpm@linux-foundation.org> <20071204192100.GB31752@Krystal> <20071204113954.c1dc9d87.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071204113954.c1dc9d87.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:42:11 up 31 days, 47 min,  6 users,  load average: 0.61, 0.44,
	0.55
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Tue, 4 Dec 2007 14:21:00 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > > > + */
> > > > +void marker_probe_cb(const struct marker *mdata, void *call_private,
> > > > +	const char *fmt, ...)
> > > > +{
> > > > +	va_list args;
> > > > +	char ptype;
> > > > +
> > > > +	preempt_disable();
> > > 
> > > What are the preempt_disable()s doing in here?
> > > 
> > > Unless I missed something obvious, a comment is needed here (at least).
> > > 
> > 
> > They make sure the teardown of the callbacks can be done correctly when
> > they are in modules and they insure RCU read coherency. Will add
> > comment.
> 
> So shouldn't it be using rcu_read_lock()?  If that does not suit, should we
> be adding new rcu primitives rather than open-coding and adding dependencies?

Hrm, yes, good point. Since there seems to be extra magic under
__acquire(RCU);  and  rcu_read_acquire();, the the fact that I use
rcu_barrier() for synchronization, we should. I'll change it.


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
