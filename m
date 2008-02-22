Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYBVI7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYBVI7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 03:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYBVI67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 03:58:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:26994 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYBVI65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 03:58:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,390,1199692800"; 
   d="scan'208";a="382237974"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 1/2] x86, ptrace: support pebs in ds.c
Date: Fri, 22 Feb 2008 08:49:49 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF554440169D67E@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080221210026.7B1C62701D5@magilla.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/2] x86, ptrace: support pebs in ds.c
Thread-Index: Ach0zS9hpqj6FPIvQqyxReVmg9ooywAWiR2Q
References: <20080213112349.A3283@sedona.ch.intel.com> <20080221210026.7B1C62701D5@magilla.localdomain>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Roland McGrath" <roland@redhat.com>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>
X-OriginalArrivalTime: 22 Feb 2008 08:49:47.0311 (UTC) FILETIME=[E0A87BF0:01C8752F]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Roland McGrath [mailto:roland@redhat.com] 
>Sent: Donnerstag, 21. Februar 2008 22:00

>Sorry I haven't replied in this thread sooner.

Thanks for your comments. I hope we get this resolved quickly.


>For the user-level interface, we should not be hasty with cooking up
>hairy ptrace extensions.  Personally, I'd prefer that we never add a
>ptrace-based interface for this (ptrace must die).  I think it will
>fit much better either merged into the interfaces that come from
>perfmon2 integration, or into what replaces ptrace when that comes.

Ptrace seems the natural choice for a debug feature.

When ptrace goes away, I will be happy to integrate this feature into
its successor. But as long as ptrace lives, I think it should support
this.


>But I also don't know of anyone desperate and about to burst from lack
>of BTS functionality.

Intel is waiting for this interface - desperate and about to burst from
lack of it.

For one, Intel's debugger is ready to support this.
Second, Intel would like to see all linux debuggers use this hardware
debugging feature.


>The low-level implementation pieces should gel a bit more in -mm or
>whereever.  They should both get more testing and also get more
>concrete use from the perfmon2 integration effort to iron out their
>internal interface kinks.

I see the two parts (ptrace API and ds.c interface) independent from
each other.

The ptrace API is the user interface for the debugging/BTS aspect of it.
As such, it will remain stable.

The ds.c interface is the kernel interface to DS (which covers both BTS
and PEBS). It is currently used by ptrace (the per-thread BTS part) and
it will be used by perfmon2 (the PEBS part) and by kernel debuggers (the
per-cpu BTS part). 

If we need to change the ds.c interface to better fit perfmon2's needs,
we can easily adapt the ptrace layer without affecting the ptrace API.


>I would like to see all the BTS and DS work wait until after 2.6.25.
>We have a lot of x86 churn in 2.6.25 already, and I think we'd do
>better without adding this wrinkle at the same time.

The ptrace BTS extension has been out for review since 2.6.24 (that is,
2.6.23 was the stable kernel at that time). The ptrace API has been
extensively discussed by mostly Ingo and myself until we agreed on its
usefulness. I have not heard any complaints about the API, since then.

I would suggest that we iron out the ptrace API for 2.6.25. This would
introduce ds.c and a first user. It would allow application debuggers to
use that feature.

For 2.6.26 we would make perfmon2 use the ds.c interface. This would add
a second user to ds.c. It would allow profilers to use that feature.

As soon as a ptrace successor becomes available, we will integrate BTS
support into it. We might want to introduce another layer between ptrace
and ds to share some code. This would leave the ptrace layer almost
empty.


What do you think?


thanks and regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

