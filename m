Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbYLLIrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbYLLIrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYLLIrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:47:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:38307 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYLLIrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:47:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,210,1228118400"; 
   d="scan'208";a="370285888"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "eranian@googlemail.com" <eranian@googlemail.com>
Date: Fri, 12 Dec 2008 08:46:46 +0000
Subject: RE: [PATCH] x86, bts: fix build error
Thread-Topic: [PATCH] x86, bts: fix build error
Thread-Index: AclcKpfXs2E0yfj3Qky3dX+O/RjEDQACrbkw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E0CB57BC4@irsmsx504.ger.corp.intel.com>
References: <20081211134959.A13599@sedona.ch.intel.com>
 <20081212070932.GB7589@elte.hu> <20081212072324.GA10705@elte.hu>
In-Reply-To: <20081212072324.GA10705@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Freitag, 12. Dezember 2008 08:23
>To: Metzger, Markus T

>i fixed a build failure via the commit below - but the 
>recursion in that 
>code is really nasty. Could you please clean it all up to plain flat 
>code?

Sure.

How could I find those things myself?
Gcc 4.3.0 does not even give a warning for a defconfig build. Is there a config option I should set?


thanks,
markus.


>
>	Ingo
>
>----------------->
>From ffc2238af8431d930d2c15f16feecf1fd6d75642 Mon Sep 17 00:00:00 2001
>From: Ingo Molnar <mingo@elte.hu>
>Date: Fri, 12 Dec 2008 08:21:19 +0100
>Subject: [PATCH] x86, bts: fix build error
>
>Impact: build fix
>
> arch/x86/kernel/ds.c: In function 'ds_request':
> arch/x86/kernel/ds.c:236: sorry, unimplemented: inlining 
>failed in call to 'ds_get_context': recursive inlining
>
>but the recursion here is scary ...
>
>Signed-off-by: Ingo Molnar <mingo@elte.hu>
>---
> arch/x86/kernel/ds.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
>index f058300..dc1e712 100644
>--- a/arch/x86/kernel/ds.c
>+++ b/arch/x86/kernel/ds.c
>@@ -232,7 +232,7 @@ static DEFINE_PER_CPU(struct ds_context *, 
>system_context_array);
> 
> #define system_context per_cpu(system_context_array, 
>smp_processor_id())
> 
>-static inline struct ds_context *ds_get_context(struct 
>task_struct *task)
>+static struct ds_context *ds_get_context(struct task_struct *task)
> {
> 	struct ds_context **p_context =
> 		(task ? &task->thread.ds_ctx : &system_context);
>
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

