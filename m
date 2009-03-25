Return-Path: <linux-kernel-owner+w=401wt.eu-S1763861AbZCYRhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763861AbZCYRhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763678AbZCYRh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:37:29 -0400
Received: from emulex.emulex.com ([138.239.112.1]:63374 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763700AbZCYRh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:37:27 -0400
From: Chetan.Loke@Emulex.Com
To: <peterz@infradead.org>
CC: <mingo@elte.hu>, <mathieu.desnoyers@polymtl.ca>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <ltt-dev@lists.casi.polymtl.ca>, <fweisbec@gmail.com>,
       <jbaron@redhat.com>, <tglx@linutronix.de>, <rmk+lkml@arm.linux.org.uk>,
       <mhiramat@redhat.com>, <fche@redhat.com>, <haoki@redhat.com>,
       <t-nishiie@np.css.fujitsu.com>, <rostedt@goodmis.org>,
       <eduard.munteanu@linux360.ro>
Date: Wed, 25 Mar 2009 10:37:20 -0700
Subject: RE: [patch 3/9] LTTng instrumentation tasklets
Thread-Topic: [patch 3/9] LTTng instrumentation tasklets
Thread-Index: AcmtVIuhXSFJkV1OQxOJCrZQf+Wq0gAG4Wmw
Message-ID: <BD597E014482714090555A6376F9CA8B771BE5A25D@EXMAIL.ad.emulex.com>
References: <20090324155625.420966314@polymtl.ca>
	 <20090324160148.238795468@polymtl.ca> <20090324175621.GE31117@elte.hu>
	 <BD597E014482714090555A6376F9CA8B771BE5A0BD@EXMAIL.ad.emulex.com>
 <1237990678.7972.1094.camel@twins>
In-Reply-To: <1237990678.7972.1094.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Mar 2009 17:37:23.0490 (UTC) FILETIME=[5B34D020:01C9AD70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org] 
> Sent: Wednesday, March 25, 2009 10:18 AM
> To: Loke,Chetan
> Cc: mingo@elte.hu; mathieu.desnoyers@polymtl.ca; 
> akpm@linux-foundation.org; linux-kernel@vger.kernel.org; 
> ltt-dev@lists.casi.polymtl.ca; fweisbec@gmail.com; 
> jbaron@redhat.com; tglx@linutronix.de; 
> rmk+lkml@arm.linux.org.uk; mhiramat@redhat.com; 
> fche@redhat.com; haoki@redhat.com; 
> t-nishiie@np.css.fujitsu.com; rostedt@goodmis.org; 
> eduard.munteanu@linux360.ro
> Subject: RE: [patch 3/9] LTTng instrumentation tasklets
> 
> On Wed, 2009-03-25 at 06:52 -0700, Chetan.Loke@Emulex.Com wrote:
> > Quick question. I understand this is unrelated to this patch. So I 
> > apologize in advance.
> > Ingo - you mentioned "tasklets are a legacy mechanism". Is there a 
> > plan to phase them out ? Let me draw a small picture as to what's 
> > bothering me.
> > 
> > With the SR-IOV support if there are 'N' virtual functions 
> then there 
> > will be 'N' driver instances(actually N+1, 1 for the PF). If that 
> > driver drains the responses in the interrupt context then all such 
> > VF-instances could virtually block everyone else(because 
> SR-IOV guys 
> > might also have MSI-X enabled).
> > So now all such drivers should alter their Rx path.Driver's 
> can queue 
> > tasklets and can also get the performance they want.
> > 
> > Any suggestions?
> 
> Threaded interrupts?
> 

If we truly need to address performance and scalability for the SCSI-subsystem then we need something lightweight.