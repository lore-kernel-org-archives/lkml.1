Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYL3Htg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYL3Htg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYL3Ht2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:49:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34036 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYL3Ht1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:49:27 -0500
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>, mingo@elte.hu
In-Reply-To: <20081229220937.GC5829@nowhere>
References: <4959443f.09a1660a.44f3.2686@mx.google.com>
	 <20081229220937.GC5829@nowhere>
Date: Tue, 30 Dec 2008 09:49:24 +0200
Message-Id: <1230623364.6091.9.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Mon, 2008-12-29 at 23:09 +0100, Frederic Weisbecker wrote:
> Pekka, note that I would be pleased to add statistical tracing on
> this tracer, but I would need a hashtable, or an array, or a list, or whatever
> iterable to insert the data into the stat tracing api.
> 
> But I don't know your projects about this... whether you wanted to use a section
> or something else...

It really depends on what we're tracing. If we're interested in just the
allocation hotspots, a section will do just fine. However, if we're
tracing memory footprint, we need to take into store the object pointer
returned from kmalloc() and kmem_cache_alloc() so we can update
call-site statistics properly upon kfree().

So I suppose we need both, a section for per call-site statistics and a
hash table for the object -> call-site mapping.

		Pekka

