Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbXDCEpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbXDCEpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 00:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXDCEpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 00:45:49 -0400
Received: from ozlabs.org ([203.10.76.45]:36750 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXDCEps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 00:45:48 -0400
Subject: Re: [PATCH] Cleanup and kernelify shrinker registration (rc5-mm2)
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, xfs-masters@oss.sgi.com, reiserfs-dev@namesys.com
In-Reply-To: <20070402205825.12190e52.akpm@linux-foundation.org>
References: <1175571885.12230.473.camel@localhost.localdomain>
	 <20070402205825.12190e52.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 14:45:02 +1000
Message-Id: <1175575503.12230.484.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 20:58 -0700, Andrew Morton wrote:
> On Tue, 03 Apr 2007 13:44:45 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > 
> > I can never remember what the function to register to receive VM pressure
> > is called.  I have to trace down from __alloc_pages() to find it.
> > 
> > It's called "set_shrinker()", and it needs Your Help.
> > 
> > New version:
> > 1) Don't hide struct shrinker.  It contains no magic.
> > 2) Don't allocate "struct shrinker".  It's not helpful.
> > 3) Call them "register_shrinker" and "unregister_shrinker".
> > 4) Call the function "shrink" not "shrinker".
> > 5) Rename "nr_to_scan" argument to "nr_to_free".
> 
> No, it is actually the number to scan.  This is >= the number of freed
> objects.
> 
> This is because, for better of for worse, the VM tries to balance the
> scanning rate of the various caches, not the reclaiming rate.

Err, ok, I completely missed that distinction.

Does that mean the to function correctly every user needs some internal
cursor so it doesn't end up scanning the first N entries over and over?

Rusty.

