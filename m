Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbYL3Ocg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbYL3Ocg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 09:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYL3Oc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 09:32:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:36459 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbYL3Oc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 09:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rGhG+yPyvWuxS758iDOLDoICHC2HyntLatbDfNmDR5YDXtXC4LknaSk2PJ60LmcloJ
         sSwtXWCwbevdydlZMNJJrMiZyHVYT6Ukc5S9pzgX/A0JiqKXipmnDKZHc7z42WaCKbu6
         xp4ZW3/bug45vI57StBEqqFdpgJz6e3RD6vfQ=
Date: Tue, 30 Dec 2008 15:32:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>, mingo@elte.hu
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230143221.GC5722@nowhere>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere> <1230623364.6091.9.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230623364.6091.9.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
> 

BTW. By looking on your needs, the statistical branch tracer and the rcu stat one,
it looks like these tracers often (if not always) need several stat files, not only
one.

Actually what I should do with stat tracing is to build a directory inside
/debugfs/tracing devoted to the several stat output a tracer need.

Which means I have to make trace_stat.c completely reentrant and some other
things....plus the fact that multiple tracers should be enable to run concurrently
for 2.6.30... which means one directory of stat tracing for each running tracer.

