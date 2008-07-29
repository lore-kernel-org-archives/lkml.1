Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYG2XTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYG2XTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYG2XTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:19:38 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:53748 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbYG2XTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:19:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0GAMI/j0hMRKxB/2dsb2JhbACBW4lEpjo
Date: Tue, 29 Jul 2008 19:19:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: module-placed markers/tracepoints
Message-ID: <20080729231935.GA7341@Krystal>
References: <y0mabg991c3.fsf@ton.toronto.redhat.com> <488635A7.2030609@qumranet.com> <20080722221204.GA14661@Krystal> <488C49CC.8040800@qumranet.com> <20080728005405.GA7941@Krystal> <20080729161836.GA10751@redhat.com> <20080729170151.GA24851@Krystal> <20080729211543.GB17097@redhat.com> <20080729224115.GA5209@Krystal> <20080729230100.GA27711@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080729230100.GA27711@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:14:20 up 55 days,  3:55,  4 users,  load average: 0.50, 1.21,
	1.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> On Tue, Jul 29, 2008 at 06:41:16PM -0400, Mathieu Desnoyers wrote:
> > > Some locals are wondering -- is there code for (or need for new code
> > > for) incrementing module reference counts while markers and/or
> > > tracepoints resident in modules have active clients?
> > 
> > Probe module unloading is supposed to be done automatically assuming the
> > following module unload behavior [...]
> 
> The question was more that if module-placed markers/tracepoints are
> armed, is there any mechanism to prevent the modules' unloading.  For
> kprobes, there is.
> 
> - FChE

I see, it's the other way around : declaring a marker/tracepoint in a
module.

When you register to a marker/tracepoint, you actually register the
probe in a hash table. It will be connected to every placed
marker/tracepoint with that given name. Upon module load, markers/tp
that match the name are connected, and upon module unload all markers/tp
are simply freed by module.c : unlike kprobes, there is no need for the
marker/tp infrastructures to keep track of every marker/tp. So we don't
need any refcount on the module which has the marker/tp.

However, the probe question is important; I think a synchronize_sched()
is missing to handle unload of marker/tp probes modules.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
