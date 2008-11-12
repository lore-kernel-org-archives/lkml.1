Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbYKLJ7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbYKLJ7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 04:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYKLJ7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 04:59:32 -0500
Received: from ozlabs.org ([203.10.76.45]:58222 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbYKLJ7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 04:59:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Allocate module.ref array dynamically
Date: Wed, 12 Nov 2008 20:29:23 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811121214.33150.rusty@rustcorp.com.au> <Pine.LNX.4.64.0811112113001.10592@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811112113001.10592@quilx.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811122029.24482.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008 13:44:51 Christoph Lameter wrote:
> Please use my new email address.... Otherwise I will not see this.

Oops, updated thanks.

> > There's something in linux-next, but I'm not sure of the status.
> > Christoph, is this anticipated to make the next merge window, or am I
> > best off merging a patch like Eric's for the moment?
>
> Yes the patch in -next is for the next merge window. This should
> actually have been in .28.

Perhaps I'm missing the overarching plan here?

You've introduced a third set of per-cpu primitives, yet the second set still 
has 0 users.

Your new basic interface is:
CPU_ALLOC/CPU_FREE/CPU_PTR/THIS_CPU/__THIS_CPU

I don't think the CAPS adds anything.  I'd like to see standard docbook 
comments.  It's not clear from your documentation whether this allocates for 
all possible or only all online CPUs, and the difference between THIS_CPU and 
__THIS_CPU is not immediately obvious.

How about re-using alloc_percpu/free_percpu/per_cpu_ptr APIs?  Rename THIS_CPU 
to __get_cpu_ptr and implement get_cpu_ptr and put_cpu_ptr wrappers (a-la 
get_cpu_var).

I love this work, but I think it stumbles on the final polish.  If that's just 
a "not done yet", I'd be happy to try to put some patches together.

Thanks!
Rusty.
