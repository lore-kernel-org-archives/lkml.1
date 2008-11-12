Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYKLWB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYKLWB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYKLWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:01:18 -0500
Received: from ozlabs.org ([203.10.76.45]:39863 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbYKLWBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:01:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Allocate module.ref array dynamically
Date: Thu, 13 Nov 2008 08:31:10 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811122029.24482.rusty@rustcorp.com.au> <Pine.LNX.4.64.0811121408290.31606@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811121408290.31606@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811130831.11499.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2008 06:41:32 Christoph Lameter wrote:
> On Wed, 12 Nov 2008, Rusty Russell wrote:
> > You've introduced a third set of per-cpu primitives, yet the second set
> > still has 0 users.
>
> What second set?

percpu_alloc().

> > Your new basic interface is:
> > CPU_ALLOC/CPU_FREE/CPU_PTR/THIS_CPU/__THIS_CPU
> >
> > I don't think the CAPS adds anything.  I'd like to see standard docbook
> > comments.  It's not clear from your documentation whether this allocates
> > for all possible or only all online CPUs, and the difference between
> > THIS_CPU and __THIS_CPU is not immediately obvious.
>
> The allocation is for all allocated percpu areas which is now per possible
> cpu. The difference between THIS_CPU and __THIS_CPU is the context check
> by smp_processor_id()

Thanks, I figured that out, but it's not documented.  I'll happily create a 
patch, but see below.  BTW, did you end up using __THIS_CPU anywhere?

> > How about re-using alloc_percpu/free_percpu/per_cpu_ptr APIs?  Rename
> > THIS_CPU to __get_cpu_ptr and implement get_cpu_ptr and put_cpu_ptr
> > wrappers (a-la get_cpu_var).
>
> The caps functions are macros not functions. Macros are
> capitalized.

Traditionally, yes, but we seem to be more ambivalent in the kernel.  
list_for_each() et. al spring to mind: code would be uglier if we made them 
caps.

> alloc_percpu must stay until the last remains have been
> evicted.

OK, you anticipate replacement of all alloc_percpu users?

> And the API does work differently.

I'm afraid the difference has escaped me so far.  Please explain why you can't 
use the current API.  Is this subtle difference going to make the transition 
difficult?

Thanks,
Rusty.
