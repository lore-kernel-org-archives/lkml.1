Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYKLUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYKLUMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYKLUMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:12:09 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:56891 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYKLUMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:12:08 -0500
Date: Wed, 12 Nov 2008 14:11:32 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] Allocate module.ref array dynamically
In-Reply-To: <200811122029.24482.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0811121408290.31606@quilx.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811121214.33150.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0811112113001.10592@quilx.com> <200811122029.24482.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008, Rusty Russell wrote:

> You've introduced a third set of per-cpu primitives, yet the second set still
> has 0 users.

What second set?

> Your new basic interface is:
> CPU_ALLOC/CPU_FREE/CPU_PTR/THIS_CPU/__THIS_CPU
>
> I don't think the CAPS adds anything.  I'd like to see standard docbook
> comments.  It's not clear from your documentation whether this allocates for
> all possible or only all online CPUs, and the difference between THIS_CPU and
> __THIS_CPU is not immediately obvious.

The allocation is for all allocated percpu areas which is now per possible
cpu. The difference between THIS_CPU and __THIS_CPU is the context check
by smp_processor_id()

> How about re-using alloc_percpu/free_percpu/per_cpu_ptr APIs?  Rename THIS_CPU
> to __get_cpu_ptr and implement get_cpu_ptr and put_cpu_ptr wrappers (a-la
> get_cpu_var).

The caps functions are macros not functions. Macros are
capitalized. alloc_percpu must stay until the last remains have been
evicted. And the API does work differently.

