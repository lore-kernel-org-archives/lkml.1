Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZCYRwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZCYRwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZCYRwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:52:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbZCYRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:52:37 -0400
Date: Wed, 25 Mar 2009 13:52:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Chetan.Loke@Emulex.Com
cc: peterz@infradead.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, fweisbec@gmail.com, jbaron@redhat.com,
       tglx@linutronix.de, rmk+lkml@arm.linux.org.uk, mhiramat@redhat.com,
       fche@redhat.com, haoki@redhat.com, t-nishiie@np.css.fujitsu.com,
       eduard.munteanu@linux360.ro
Subject: RE: [patch 3/9] LTTng instrumentation tasklets
In-Reply-To: <BD597E014482714090555A6376F9CA8B771BE5A25D@EXMAIL.ad.emulex.com>
Message-ID: <alpine.DEB.2.00.0903251351440.5675@gandalf.stny.rr.com>
References: <20090324155625.420966314@polymtl.ca>  <20090324160148.238795468@polymtl.ca> <20090324175621.GE31117@elte.hu>  <BD597E014482714090555A6376F9CA8B771BE5A0BD@EXMAIL.ad.emulex.com> <1237990678.7972.1094.camel@twins>
 <BD597E014482714090555A6376F9CA8B771BE5A25D@EXMAIL.ad.emulex.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Chetan.Loke@Emulex.Com wrote:

>  
> 
> > -----Original Message-----
> > From: Peter Zijlstra [mailto:peterz@infradead.org] 
> > Sent: Wednesday, March 25, 2009 10:18 AM
> > To: Loke,Chetan
> > Cc: mingo@elte.hu; mathieu.desnoyers@polymtl.ca; 
> > akpm@linux-foundation.org; linux-kernel@vger.kernel.org; 
> > ltt-dev@lists.casi.polymtl.ca; fweisbec@gmail.com; 
> > jbaron@redhat.com; tglx@linutronix.de; 
> > rmk+lkml@arm.linux.org.uk; mhiramat@redhat.com; 
> > fche@redhat.com; haoki@redhat.com; 
> > t-nishiie@np.css.fujitsu.com; rostedt@goodmis.org; 
> > eduard.munteanu@linux360.ro
> > Subject: RE: [patch 3/9] LTTng instrumentation tasklets
> > 
> > On Wed, 2009-03-25 at 06:52 -0700, Chetan.Loke@Emulex.Com wrote:
> > > Quick question. I understand this is unrelated to this patch. So I 
> > > apologize in advance.
> > > Ingo - you mentioned "tasklets are a legacy mechanism". Is there a 
> > > plan to phase them out ? Let me draw a small picture as to what's 
> > > bothering me.
> > > 
> > > With the SR-IOV support if there are 'N' virtual functions 
> > then there 
> > > will be 'N' driver instances(actually N+1, 1 for the PF). If that 
> > > driver drains the responses in the interrupt context then all such 
> > > VF-instances could virtually block everyone else(because 
> > SR-IOV guys 
> > > might also have MSI-X enabled).
> > > So now all such drivers should alter their Rx path.Driver's 
> > can queue 
> > > tasklets and can also get the performance they want.
> > > 
> > > Any suggestions?
> > 
> > Threaded interrupts?
> > 
> 
> If we truly need to address performance and scalability for the SCSI-subsystem then we need something lightweight.

Threaded interrupts are actually quite light.

-- Steve

