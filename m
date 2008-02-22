Return-Path: <linux-kernel-owner+w=401wt.eu-S935830AbYBVKO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935830AbYBVKO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYBVKOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:14:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:55349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbYBVKOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:14:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,390,1199692800"; 
   d="scan'208";a="344027783"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 1/2] x86, ptrace: support pebs in ds.c
Date: Fri, 22 Feb 2008 10:12:48 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF554440169D824@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080222095322.GD6269@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 1/2] x86, ptrace: support pebs in ds.c
Thread-Index: Ach1OTf3qMtVNXNYQYq2IecRTfmvsgAAFt5Q
References: <20080213112349.A3283@sedona.ch.intel.com> <20080221210026.7B1C62701D5@magilla.localdomain> <029E5BE7F699594398CA44E3DDF554440169D67E@swsmsx413.ger.corp.intel.com> <20080222095322.GD6269@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Roland McGrath" <roland@redhat.com>, <ak@suse.de>, <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
       <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>
X-OriginalArrivalTime: 22 Feb 2008 10:12:39.0486 (UTC) FILETIME=[744E2DE0:01C8753B]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Freitag, 22. Februar 2008 10:53
>To: Metzger, Markus T

>> The ptrace API is the user interface for the debugging/BTS aspect of 
>> it. As such, it will remain stable.
>
>your last patch does this to arch/x86/kernel/ptrace.c:
>
>  266 insertions(+), 174 deletions(-)
>
>doesnt that change the ptrace bits and the ptrace API semantics?

The last patch does change the ptrace API - before it becomes public.

After it becomes public, ds.c can be changed without affecting the
ptrace API.


The last changes are not strictly necessary - I could as well implement
the old interface. If there are objections to or concerns regarding
those API changes, I will do just that. The changes are:
- add PTRACE_BTS_O_ALLOC to explicitly request reallocation of the BTS
buffer.
  This used to be implicit when the size changes.
- remove PTRACE_BTS_O_CUT_SIZE
  This used to reduce the size requested for the BTS buffer to the
maximal available size, if necessary.
  I do not think this is necessary. Users should check their ulimits.

This is what I meant with ironing out the ptrace API.


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

