Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbXDLOQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbXDLOQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXDLOQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:16:32 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:10287 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbXDLOQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:16:31 -0400
From: Buytaert_Steven@emc.com
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: sched_yield proposals/rationale
Date: Thu, 12 Apr 2007 10:15:41 -0400
Message-ID: <585DC2133F7C974F87D4EC432896F1720309F485@CORPUSMX10A.corp.emc.com>
In-Reply-To: <20070412133158.GB31455@one.firstfloor.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: sched_yield proposals/rationale
Thread-Index: Acd9BvnK3OCZTh3AQgez9mbJK5LhEAAA2Egw
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de> <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com> <20070412133158.GB31455@one.firstfloor.org>
To: <andi@firstfloor.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Apr 2007 14:15:43.0128 (UTC) FILETIME=[0E4C5980:01C77D0D]
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.4.12.65634
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, SUPERLONG_LINE 0.05, NO_REAL_NAME 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __IMS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> > Agreed, but $ find . -name "*.[ch]" | xargs grep -E "yield[ ]*\(" | wc
> over
> > the 2.6.16 kernel yields 105 hits, note including comments... An
> interesting spot is e.g. fs/buffer.c free_more_memory()
> 
> A lot of those are probably broken in some way agreed.

OK, so there are 2 options: 1) fix 100 spots or 2) ... ;-)

> [ about giving a thread its full slice quota after yielding ]
> With a particular sleep pattern it could get more CPU time.

I'm not a linux scheduler expert, but I don't understand this. Suppose 2 extreme situations:

1) I have full time slices and call yield, going to the expired list with again full times slices; this is IMHO a NOOP, i.e. fair.

2) I have only a single slice left, NOT yielding would get me to the expired list via scheduler_tick the next timer interrupt and I would get my full time slice quota. DO YIELD at that moment, will give me full time slice quota again (with my proposal). 

> 
> 3) Put the task in the expired list at a random position [...]
> > while (X--) { prev = current; current = current->next }
> 
> You would need to rename the scheduler to "sometimes O(1)" first @)

Again, agreed, but this tight loop would run in code cache completely. We could call it O(1.1) ;-) With a duffs device it would mean a few clock cycles per position.

> Besides - but I guess you're aware of it - any randomized algorithms tend
> to drive benchmarkers and performance analysts crazy because their
> performance
> cannot be repeated. So it's usually better to avoid them unless there is
> really no alternative.

That could already solve your concern from above. Statistically speaking, it will give them (benchmarkers) the smoothest curve they've ever seen.

Please be aware that I'm just exploring options/insight here. It is not something I intend to push inside the mainline kernel. I just want to find reasonable and logic criticism as you and some others have provided already. Thanks for that!

Steven Buytaert
--
La perfection est atteinte non quand il ne reste rien ajouter, mais quand il ne reste rien à enlever. (Antoine de Saint-Exupéry)
