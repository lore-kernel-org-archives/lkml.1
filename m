Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbZCYNww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbZCYNww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759188AbZCYNwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:52:38 -0400
Received: from emulex.emulex.com ([138.239.112.1]:38528 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761808AbZCYNwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:52:37 -0400
From: Chetan.Loke@Emulex.Com
To: <mingo@elte.hu>, <mathieu.desnoyers@polymtl.ca>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <ltt-dev@lists.casi.polymtl.ca>, <fweisbec@gmail.com>,
       <jbaron@redhat.com>, <peterz@infradead.org>, <tglx@linutronix.de>,
       <rmk+lkml@arm.linux.org.uk>, <mhiramat@redhat.com>, <fche@redhat.com>,
       <haoki@redhat.com>, <t-nishiie@np.css.fujitsu.com>,
       <rostedt@goodmis.org>, <eduard.munteanu@linux360.ro>
Date: Wed, 25 Mar 2009 06:52:32 -0700
Subject: RE: [patch 3/9] LTTng instrumentation tasklets
Thread-Topic: [patch 3/9] LTTng instrumentation tasklets
Thread-Index: AcmsqkNgvgu5qm0AT2aX5WwWDwWgaAAo+HGw
Message-ID: <BD597E014482714090555A6376F9CA8B771BE5A0BD@EXMAIL.ad.emulex.com>
References: <20090324155625.420966314@polymtl.ca>
 <20090324160148.238795468@polymtl.ca> <20090324175621.GE31117@elte.hu>
In-Reply-To: <20090324175621.GE31117@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Mar 2009 13:52:34.0308 (UTC) FILETIME=[F306FC40:01C9AD50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Ingo Molnar
> Sent: Tuesday, March 24, 2009 1:56 PM
> To: Mathieu Desnoyers
> Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org; 
> ltt-dev@lists.casi.polymtl.ca; Frederic Weisbecker; Jason 
> Baron; Peter Zijlstra; Thomas Gleixner; Russell King; Masami 
> Hiramatsu; Frank Ch. Eigler; Hideo AOKI; Takashi Nishiie; 
> Steven Rostedt; Eduard - Gabriel Munteanu
> Subject: Re: [patch 3/9] LTTng instrumentation tasklets
> 
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > tasklet entry and exit events.
> 
> > +DEFINE_TRACE(irq_tasklet_high_entry);
> > +DEFINE_TRACE(irq_tasklet_high_exit);
> > +DEFINE_TRACE(irq_tasklet_low_entry);
> > +DEFINE_TRACE(irq_tasklet_low_exit);
> 
> Dunno - tasklets are a legacy mechanism, not sure we want to 
> instrument them. 


Quick question. I understand this is unrelated to this patch. So I apologize in advance.
Ingo - you mentioned "tasklets are a legacy mechanism". Is there a plan to phase them out ? Let me draw a small picture as to what's bothering me.

With the SR-IOV support if there are 'N' virtual functions then there will be 'N' driver instances(actually N+1, 1 for the PF). If that driver drains the responses in the interrupt context then all such VF-instances could virtually block everyone else(because SR-IOV guys might also have MSI-X enabled).
So now all such drivers should alter their Rx path.Driver's can queue tasklets and can also get the performance they want.

Any suggestions?

thanks
Chetan