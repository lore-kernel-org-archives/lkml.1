Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYL3IBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYL3IBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYL3IBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:01:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:21104 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYL3IBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oM9EbuCGuzQU507aoPbfHHrAU8m098/s0e1M6vAhev5+wf3vAv/ufOJycVCGWIFw1G
         hPqF8qB30epgKLr6JEyplr9bwspC36BAWAWxY0mz1zKte2fReQr8oqTokPo2HyUoBXpB
         fBF7oNZHpuFBxuvlu7lPTOWf7FscyGEMme+1A=
Date: Tue, 30 Dec 2008 10:01:30 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230080129.GA10635@localhost>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere> <1230623364.6091.9.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230623364.6091.9.camel@penberg-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 09:49:24AM +0200, Pekka Enberg wrote:
> Hi Frederic,
> 
> On Mon, 2008-12-29 at 23:09 +0100, Frederic Weisbecker wrote:
> > Pekka, note that I would be pleased to add statistical tracing on
> > this tracer, but I would need a hashtable, or an array, or a list, or whatever
> > iterable to insert the data into the stat tracing api.
> > 
> > But I don't know your projects about this... whether you wanted to use a section
> > or something else...
> 
> It really depends on what we're tracing. If we're interested in just the
> allocation hotspots, a section will do just fine. However, if we're
> tracing memory footprint, we need to take into store the object pointer
> returned from kmalloc() and kmem_cache_alloc() so we can update
> call-site statistics properly upon kfree().
> 
> So I suppose we need both, a section for per call-site statistics and a
> hash table for the object -> call-site mapping.
> 
> 		Pekka

Hi Frederic,

Thanks for doing this work.

kmemtrace-user currently shows two main views: per call-site and
per-allocation. For the former, it uses a hashtable to accumulate
statistics. There's also a hashtable for individual allocations (by ptr
address), which we use to check for consistency for example ("if this is
going to be freed, has it been allocated?"). Apart from those two views,
it also shows global statistics.


	Thanks again,
	Eduard

