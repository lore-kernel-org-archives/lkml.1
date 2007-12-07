Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbXLGNh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbXLGNh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 08:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbXLGNhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 08:37:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:23770 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbXLGNhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 08:37:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,267,1194249600"; 
   d="scan'208";a="239043480"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: ptrace API extensions for BTS
Date: Fri, 7 Dec 2007 13:36:18 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444010F91A7@swsmsx413.ger.corp.intel.com>
In-Reply-To: <200712071404.06594.ak@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ptrace API extensions for BTS
thread-index: Acg40a0OAWzBSa+uS26knDP1xoz0ZgAAg41A
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com> <200712071218.17914.ak@suse.de> <029E5BE7F699594398CA44E3DDF55444010F9074@swsmsx413.ger.corp.intel.com> <200712071404.06594.ak@suse.de>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <roland@redhat.com>, <markus.t.metzger@gmail.com>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <mingo@elte.hu>, "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 07 Dec 2007 13:37:06.0739 (UTC) FILETIME=[4259B030:01C838D6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Andi Kleen [mailto:ak@suse.de] 
>Sent: Freitag, 7. Dezember 2007 14:04

>With Out-of-order CPUs exact global metrics are pretty difficult.
>At which point of the instruction execution would you measure? 

All I want to do is order the execution chunks of different 
threads. Taking two snapshots somewhere near the beginning and 
the end of context switching should be good enough.

There's all the scheduler code in between (or at least the context
switch code). I don't think I need to worry about the exact point
during instruction execution.

I don't think it makes sense to try to correlate instructions
from different threads. It would be a wonderful feature to show
a synchronous trace across multiple threads. But that would require
you to measure time for each instruction. I don't think that's
feasible without reducing performance to single stepping;-)


>Anyways if RDTSC doesn't work the only global alternatives are 
>much slower
>(like southbridge timers) or very inaccurate (jiffies) 

Would jiffies be a metric that works across cpu's?
At the granularity that I want to measure, I guess that accuracy
is not important at all.


>I would just drop it since it'll likely always be somewhat misleading.

I guess I will (have to) drop it if it cannot be used for what I
intended.


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
