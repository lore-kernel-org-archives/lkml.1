Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbXDCD6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbXDCD6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 23:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbXDCD6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 23:58:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59685 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbXDCD6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 23:58:37 -0400
Date: Mon, 2 Apr 2007 20:58:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, xfs-masters@oss.sgi.com, reiserfs-dev@namesys.com
Subject: Re: [PATCH] Cleanup and kernelify shrinker registration (rc5-mm2)
Message-Id: <20070402205825.12190e52.akpm@linux-foundation.org>
In-Reply-To: <1175571885.12230.473.camel@localhost.localdomain>
References: <1175571885.12230.473.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 13:44:45 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> 
> I can never remember what the function to register to receive VM pressure
> is called.  I have to trace down from __alloc_pages() to find it.
> 
> It's called "set_shrinker()", and it needs Your Help.
> 
> New version:
> 1) Don't hide struct shrinker.  It contains no magic.
> 2) Don't allocate "struct shrinker".  It's not helpful.
> 3) Call them "register_shrinker" and "unregister_shrinker".
> 4) Call the function "shrink" not "shrinker".
> 5) Rename "nr_to_scan" argument to "nr_to_free".

No, it is actually the number to scan.  This is >= the number of freed
objects.

This is because, for better of for worse, the VM tries to balance the
scanning rate of the various caches, not the reclaiming rate.

> 6) Reduce the 17 lines of waffly comments to 10, and document the -1 return.
> 
> Comments:
> 1) The comment in reiserfs4 makes me a little queasy.

I'm going to have to split this patch up into mainline-bit and reiser4-bit.

And that's OK (it's a regular occurrence).  But never miss a chance to whine.

> 2) The wrapper code in xfs might no longer be needed.
> 3) The placing in the x86-64 "hot function list" for seems a little
>    unlikely.  Clearly, Andi was testing if anyone was paying attention.


