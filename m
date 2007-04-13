Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbXDMFgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbXDMFgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 01:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXDMFgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 01:36:19 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:45007 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXDMFgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 01:36:18 -0400
From: Buytaert_Steven@emc.com
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: sched_yield proposals/rationale
Date: Fri, 13 Apr 2007 01:36:08 -0400
Message-ID: <585DC2133F7C974F87D4EC432896F1720309F645@CORPUSMX10A.corp.emc.com>
In-Reply-To: <461EB367.1050405@tmr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: sched_yield proposals/rationale
Thread-Index: Acd9U1k6Lh6ZExJaQ1mW3UjGKpyR9gAN2GnA
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de> <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com> <20070412133158.GB31455@one.firstfloor.org> <585DC2133F7C974F87D4EC432896F1720309F485@CORPUSMX10A.corp.emc.com> <461EB367.1050405@tmr.com>
To: <davidsen@tmr.com>
Cc: <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Apr 2007 05:36:09.0578 (UTC) FILETIME=[A3D3DCA0:01C77D8D]
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.4.12.221434
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, SUPERLONG_LINE 0.05, NO_REAL_NAME 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __IMS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Bill Davidsen
>
> And having gotten same, are you going to code up what appears to be a
> solution, based on this feedback?

The feedback was helpful in verifying whether there are any arguments against my approach. The real proof is in the pudding.

I'm running a kernel with these changes, as we speak. Overall system throughput is about up 20%. With 'system throughput' I mean measured performance of a rather large (experimental) system. The patch isn't even 24h old... Also the application latency has improved.

Additional settings: my patch is running *also* with a kernel modified to have only 8 default time slices at 250Hz setting. And no, the overall number of context switches per second hasn't blown up. The kernel was compiled with low latency and in-kernel preemption enabled, BKL preemption enabled. I haven't checked the patch stand alone yet.

> I'm curious how well it would run poorly written programs, having
> recently worked with a company which seemed to have a whole part of
> purchasing dedicated to buying same. :-(

So first signs are positive; note that it requires much more run time and a slew of other tests/scrutiny before we can be really sure.

W.r.t. the remarks; I am most interested in possibilities of DOS attacks that could exploit this change in sched_yield. Therefore the comments of Andi were interesting, but I haven't heard back from him yet. I'm still not sure how a task could juggle more slices from the system because of these changes.

Last remark on the O(1)'ness being violated. I think it's a mooth point. The sched_yield is executed on the CPU time of the yielder. Being O(1) is most important for the scheduler proper at each timer tick (interrupt). That being O(1) is crucial.

Steven Buytaert
--
La perfection est atteinte non quand il ne reste rien ajouter, mais quand il ne reste rien à enlever. (Antoine de Saint-Exupéry)
