Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYAWDKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYAWDKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 22:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYAWDKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 22:10:10 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:49979 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751602AbYAWDKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 22:10:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAF8+lkdMROHU/2dsb2JhbACBV5ATmzo
Date: Tue, 22 Jan 2008 22:10:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jon Masters <jcm@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: CONFIG_MARKERS
Message-ID: <20080123031005.GA16766@Krystal>
References: <1201029235.18144.62.camel@perihelion> <y0modbdnt4e.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0modbdnt4e.fsf@ton.toronto.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:03:22 up 80 days,  8:08,  5 users,  load average: 0.27, 0.11,
	0.08
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> 
> Jon Masters <jcm@redhat.com> writes:
> 
> > I notice in module.c:
> >
> > #ifdef CONFIG_MARKERS
> > 	if (!mod->taints)
> > 		marker_update_probe_range(mod->markers,
> > 			mod->markers + mod->num_markers, NULL, NULL);
> > #endif
> >
> > Is this an attempt to not set a marker for proprietary modules? [...]
> 
> I can't seem to find any discussion about this aspect.  If this is the
> intent, it seems misguided to me.  There may instead be a relationship
> to TAINT_FORCED_{RMMOD,MODULE}.  Mathieu?
> 
> - FChE

On my part, its mostly a matter of not crashing the kernel when someone
tries to force modprobe of a proprietary module (where the checksums
doesn't match) on a kernel that supports the markers. Not doing so
causes the markers to try to find the marker-specific information in
struct module which doesn't exist and OOPSes.

Christoph's point of view is rather more drastic than mine : it's not
interesting for the kernel community to help proprietary modules writers,
so it's a good idea not to give them marker support. (I CC'ed him so he
can clarify his position).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
