Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZBZPNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZBZPNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 10:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbZBZPMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 10:12:53 -0500
Received: from imr1.ericy.com ([198.24.6.9]:41406 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbZBZPMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 10:12:53 -0500
X-Greylist: delayed 9258 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Feb 2009 10:12:52 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] new irq tracer
Date: Thu, 26 Feb 2009 07:37:18 -0500
Message-ID: <806EF3041844884CAC68E1E16026AB8905CE58DA@ecamlmw720.eamcs.ericsson.se>
In-Reply-To: <alpine.DEB.2.00.0902252040210.12697@gandalf.stny.rr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] new irq tracer
Thread-Index: AcmXs15m0Qy8zmUgRHahED7/wVuymQAW1xBg
References: <1234995035.4799.14.camel@laptop> <20090220195236.GB3104@redhat.com> <20090222123543.359C.A69D9226@jp.fujitsu.com> <49A5765C.2020001@redhat.com> <20090225165747.GC3123@redhat.com> <20090225173412.GA14269@Krystal> <alpine.DEB.2.00.0902251250110.12697@gandalf.stny.rr.com> <20090225221210.GA20133@Krystal> <20090225222001.GC5838@nowhere> <20090225231325.GB21928@Krystal> <alpine.DEB.2.00.0902252040210.12697@gandalf.stny.rr.com>
From: "Dominique Toupin" <dominique.toupin@ericsson.com>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>
Cc: "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Jason Baron" <jbaron@redhat.com>,
       "Masami Hiramatsu" <mhiramat@redhat.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <acme@ghostprotocols.net>
X-OriginalArrivalTime: 26 Feb 2009 12:37:20.0405 (UTC) FILETIME=[F760CC50:01C9980E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In many cases we don't use Linux real-time, we have many systems that
are soft-real-time an non real-time Linux is good enough.
 

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org] 
> Sent: 25-Feb-09 20:42
> To: Mathieu Desnoyers
> Cc: Frederic Weisbecker; Jason Baron; Masami Hiramatsu; 
> KOSAKI Motohiro; Peter Zijlstra; Frank Ch. Eigler; 
> mingo@elte.hu; linux-kernel@vger.kernel.org; 
> acme@ghostprotocols.net; Dominique Toupin
> Subject: Re: [PATCH] new irq tracer
> 
> 
> On Wed, 25 Feb 2009, Mathieu Desnoyers wrote:
> > > > > 
> > > > > Then use the function_graph tracer.
> > > > > 
> > > > 
> > > > Sadly, the function tracer cannot be enabled on 
> production systems.
> > > > Therefore it's not a usable solution in the context 
> where I need this.
> > > > 
> > > > Mathieu
> > > 
> > > 
> > > Why?
> > > If this is about the interrupt latency caused by 
> stop_machine, I still don't understand.
> > > This latency happens before the tracing (function filter 
> which use 
> > > patching), not during tracing.
> > > 
> > 
> > Given this scenario :
> > 
> > A telecommunication system runs, but the client notices 
> something wrong.
> > They call their service provider. The provider enables tracing 
> > _remotely_ on the _production system_ while it's _active in 
> the field_.
> > 
> > Bam, those few milliseconds interrupt latencies become unacceptable.
> > 
> > Hopefully this scenario makes the use-case clearer. The 
> problem is not 
> > that interrupt latencies would occur while tracing is on, 
> but rather 
> > that it would happen on a running production system when switching 
> > tracing on. This is what is totally unacceptable for this use-case.
> > 
> > For more details about such requirements, I'm CCing 
> Dominique Toupin 
> > from Ericsson who I'm sure would be happy to give more 
> details about 
> > this if needed.
> 
> Hmm, so this system in the field is running Linux with the 
> Real-Time Patch?  Because if it isn't it will suffer from 
> millisecond latencies in normal operation.
> 
> -- Steve
> 
> 
