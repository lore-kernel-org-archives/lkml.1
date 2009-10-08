Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbZJHMWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbZJHMWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbZJHMWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:22:35 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:37030 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597AbZJHMWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:22:34 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v8 PATCH 2/8]: cpuidle: implement a list based approach to
 register a set of idle routines.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20091008120120.GL20595@linux.vnet.ibm.com>
References: <20091008094828.GA20595@linux.vnet.ibm.com>
	 <20091008095027.GC20595@linux.vnet.ibm.com>
	 <1254998162.26976.270.camel@twins>
	 <20091008104249.GJ20595@linux.vnet.ibm.com>
	 <1254999033.26976.272.camel@twins>
	 <20091008110106.GK20595@linux.vnet.ibm.com>
	 <1255001110.26976.292.camel@twins>
	 <20091008120120.GL20595@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 14:25:37 +0200
Message-Id: <1255004737.26976.307.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 17:31 +0530, Arun R Bharadwaj wrote:
> 
> > Uhm, no, it would mean ACPI putting its idle routines on the same level
> > as all others.
> > 
> 
> Putting them all on the same level would mean, we need an
> enable/disable routine to enable only the currently active routines.

What's this enable/disable stuff about?

> Also, the way governor works is that, it assumes that idle routines
> are indexed in the increasing order of power benefit that can be got
> out of the state. So this would get messed up.

Right, which is why I initially had a power-savings field in my
proposal, so it could weight the power savings vs the wakeup latency.

  http://lkml.org/lkml/2009/8/27/159

There it was said that was exactly what these governors were doing,
seems its not.

> > Sounds like something is wrong alright. If you can register an idle
> > routine you should be able to unregister it too.
> >
> 
> Yes, we can register and unregister in a clean way now.
> Consider this. We have a set of routines A, B, C currently registered.
> Now a module comes and registers D and E, and later on at some point
> of time wants to unregister. So how do you keep track of what all idle
> routines the module registered and unregister only those?
> Best way to do that is a stack, which is how I have currently
> implemented.

Right, so destroy that inner set thing, that way we only have one
left ;-)

