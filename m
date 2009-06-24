Return-Path: <linux-kernel-owner+w=401wt.eu-S1751238AbZFXOUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbZFXOUC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZFXOTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:19:51 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:55840 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754213AbZFXOTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:19:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEEAP/RQUpMQWRX/2dsb2JhbACBUdJFhAsFgTQ
Date: Wed, 24 Jun 2009 10:14:39 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       Tom Zanussi <tzanussi@gmail.com>, karim@opersys.com,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, Lai Jiangshan <laijs@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: Dual-licensing LTTng, marker and tracepoints under
	GPLv2+/LGPLv2.1+
Message-ID: <20090624141438.GA15420@Krystal>
References: <4A412702.80707@polymtl.ca> <20090623191128.GA19010@Krystal> <20090623191513.GA20253@Krystal> <20090624004356.GB28911@Krystal> <20090624083334.GB16850@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090624083334.GB16850@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:55:44 up 116 days, 10:21,  3 users,  load average: 0.46, 0.26,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > Hi,
> > 
> > We want to re-license LTTng as
> > 
> >   dual-license GPLv2 (or better)/LGPLv2.1 (or better)
> > 
> > to facilitate code exchange between the GPLv2 LTTng kernel tracer 
> > and LGPLv2.1 userspace LTTng tracing library.  This will also 
> > include kernel/marker.c, include/linux/marker.h, 
> > kernel/tracepoint.c and include/linux/tracepoint.h. For the LTTng 
> > tree, everything under the ltt/ subdirectory is targeted.
> > 
> > I am the main author of most of these files, and I allow such 
> > license change as far as my code is concerned. Additionally, we 
> > need the approval of most people who contributed code to either 
> > LTTng, Linux Kernel Marker and Tracepoints.
> 

Hi Ingo,

> Why dont you license the user-space library under the GPLv2?
> 

The goal we pursue by dual-licensing with GPLv2/LGPLv2.1 is to permit
instrumented applications to be themselves distributed under other
license than GPL. We currently have a working userspace tracing library
port of the LTTng tracer. The goal is to permit this library, which
includes the tracepoints, markers and LTTng features, to be used by
userspace applications and libraries so they can add static
instrumentation (as we currently do in the kernel). We already got the
OK from IBM to release the userspace RCU library I've created to support
the userspace LTTng port under LGPL. We have also re-created most of the
low-level primitives we needed under the MIT-style or LGPL license.


> Also, i dont agree that such interfaces should be ABIs, hence i 
> oppose the librarization of such raw kernel interfaces. For example 
> markers will be removed in the future, and tracepoints will sure 
> undergo more corrective iterations as well.
> 
> 	Ingo

There might be some misunderstanding here: the portion of
markers/tracepoints/LTTng added to a userspace library have absolutely
nothing to do with the kernel anymore. Their scope is only the process
they instrument and trace. Therefore this is a different and separate
API provided by a userspace library. I don't see how this can be related
to the kernel ABI.. ?

And we plan to release these first versions of the library by stating
clearly that we reserve all rights to change the interface to match the
Linux kernel modifications. But we have to start somewhere you know. :)

And keeping these libraries under LGPL will ensure that we offer
interfaces that permits to re-link the applications with newer
instrumentation/tracing libraries, so we won't get stucked with
compatibility problems.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
