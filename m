Return-Path: <linux-kernel-owner+w=401wt.eu-S932655AbXKOThp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbXKOThp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760281AbXKOThg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:37:36 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48439 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753039AbXKOThf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:37:35 -0500
To: a.p.zijlstra@chello.nl
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <1195154530.22457.16.camel@lappy> (message from Peter Zijlstra on
	Thu, 15 Nov 2007 20:22:10 +0100)
Subject: Re: [RFC] fuse writable mmap design
References: <E1IshIR-0000fE-00@dorka.pomaz.szeredi.hu> <1195154530.22457.16.camel@lappy>
Message-Id: <E1IskWl-0000oJ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 Nov 2007 20:37:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm somewhat confused by the complexity. Currently we can already have a
> lot of dirty pages from FUSE (up to the per BDI dirty limit - so
> basically up to the total dirty limit).
> 
> How is having them dirty from mmap'ed writes different?

Nope, fuse never had dirty pages.  It does normal writes
synchronously, just updating the cache.

The dirty accounting and then the per-bdi throttling basically made it
possible _at_all_ to have a chance at a writepage implementation which
is not deadlocky (so thanks for those ;).

But there's still the throttle_vm_writeout() thing, and the other
places where the kernel is waiting for a write to complete, which just
cannot be done within a constrained time if an unprivileged userspace
process is involved.

Miklos
