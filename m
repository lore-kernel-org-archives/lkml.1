Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZKMK35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZKMK35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZKMK3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:29:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28695 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbZKMK3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:29:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=umu/uOwno/HT9qHSQ619KvOA/Kvi1pGQxgtOADNO7/FBl7rOlaRTsGiOwLbDeV9gT
	FwSqKPZ0fP0VN1lO+iOIg==
Date: Fri, 13 Nov 2009 02:29:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
In-Reply-To: <20091113101326.GA17451@elte.hu>
Message-ID: <alpine.DEB.2.00.0911130222080.21963@chino.kir.corp.google.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <alpine.DEB.2.00.0911121247420.9544@chino.kir.corp.google.com> <20091113095350.GC1364@elte.hu> <alpine.DEB.2.00.0911130158390.13911@chino.kir.corp.google.com> <20091113101326.GA17451@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009, Ingo Molnar wrote:

> There's two problems outlined in this discussion:
> 
>  A) too verbose bootup that is annoying with 64 CPUs and a show-stopper
>     with 4096 CPUs.
> 
>  B) the ad-hoc nature of our topology enumeration. Some of it is in
>     /sys, some of it is in printk logs. None really works well and 
>     there's no structure in it.
> 
> The simplest solution for (A) is what i suggested a few mails ago: dont 
> print the information by default, but allow (for trouble-shooting) 
> purposes for it to be printed when a boot option is passed.
> 

Sigh, and even if that were done with a subsequent patch, you would still 
want to reduce the debugging output from 1272 lines to 40, just like my 
patch does without losing any information.  It's insane to emit 1272 
lines even if they are emitted only for a certain kernel parameter.  I'm 
sure we agree on that.

> Problem (B), topology info enumeration of a successful bootup is a 
> different matter. It should be exposed to user-space via proper /sys 
> abstractions, not via ad-hoc printks. There's ongoing work in that area, 
> from Andreas Hermann, with patches posted. hpa expressed the view there 
> that topology structure should be expressed via a nice vfs abstraction - 
> i share that opinion.
> 

Ingo, what do you want?

Your first criticism was that it should be limited only to a kernel 
parameter but now it seems like you're insisting that the printk's get 
removed completely and its exported via userspace.  Then what is the 
kernel parameter that you suggested for?

I'll leave the discussion with saying that if we still want to emit this 
information with a parameter, that you'll still need to merge my patch at 
some point to reduce the 1272 lines on Mark's system to 40.  I'm unsure 
why that isn't just merged right now since it's a clear improvement over 
the current behavior, but I'm not going to beat a dead horse.

Thanks.
