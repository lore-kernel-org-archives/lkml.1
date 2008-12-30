Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbYL3IlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbYL3IlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYL3IlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:41:09 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:62843 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYL3IlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BICUz5MaDTqrFz4XPC6Errjm/F8Og0Qfx+FHZdLP/tTX6qJdDabLIcg/1W6u45Q8SZ
         p1GlBnSNd9vUklVErECGqiIyKBhCHUfPAvt1ymtVh/pdXkGy6mfLKobOa051PEl8sngb
         I3dcFvFJ24F9QKqchaEr2ausYERJULUAiMOn8=
Date: Tue, 30 Dec 2008 10:41:27 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230084127.GE10635@localhost>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere> <1230623364.6091.9.camel@penberg-laptop> <20081230081600.GD2455@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081230081600.GD2455@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 09:16:00AM +0100, Ingo Molnar wrote:
> 3)
> 
> the most lowlevel (and hence most allocation-footprint sensitive) object 
> to track would be the memory object itself. I think the best approach 
> would be to do a static, limited size hash that could track up to N memory 
> objects.
> 
> The advantage of such an approach is that it does not impact allocation 
> patterns at all (besides the one-time allocation cost of the hash itself 
> during tracer startup).

kmemtrace-user handles this by analysing offline :). I presume you could get
around this by discarding every hash collision in a well-sized
hashtable. The hashing algo in kmemtrace-user performs okay, considering
it fills the hashtable almost entirely, but I presume you're doing that
in-kernel and using other available code.

> And this too would be driven from ftrace mainly - the SLAB code would only 
> offer the alloc+free callbacks with the object IDs. [ and this means that 
> we could detect memory leaks by looking at the hash table and print out 
> the age of entries :-) ]

Some time ago I dropped timestamps because they were not providing a
good way to reorder packets in userspace. We're currently relying on a
sequence number to do that. You could take that as 'age', but it's not
temporally-meaningful.


	Eduard

