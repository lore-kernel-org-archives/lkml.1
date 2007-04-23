Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbXDWGlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbXDWGlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXDWGlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:41:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbXDWGlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:41:08 -0400
Date: Sun, 22 Apr 2007 23:39:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: Re: [PATCH 10/10] mm: per device dirty threshold
Message-Id: <20070422233936.97d78677.akpm@linux-foundation.org>
In-Reply-To: <E1Hfs3j-0005sN-00@dorka.pomaz.szeredi.hu>
References: <20070420155154.898600123@chello.nl>
	<20070420155503.608300342@chello.nl>
	<20070421025532.916b1e2e.akpm@linux-foundation.org>
	<E1HfCzN-0002dZ-00@dorka.pomaz.szeredi.hu>
	<20070421035444.f7a42fad.akpm@linux-foundation.org>
	<E1HfM9K-0003OA-00@dorka.pomaz.szeredi.hu>
	<1177308889.26937.1.camel@twins>
	<E1Hfs3j-0005sN-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 08:29:59 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > What about swapout?  That can increase the number of writeback pages,
> > > without decreasing the number of dirty pages, no?
> > 
> > Could we not solve that by enabling cap_account_writeback on
> > swapper_space, and thereby account swap writeback pages. Then the VM
> > knows it has outstanding IO and need not panic.
> 
> Hmm, I'm not sure that would be right, because then those writeback
> pages would be accounted twice: once for swapper_space, and once for
> the real device.
> 
> So there's a condition, when lots of anonymous pages are turned into
> swap-cache writeback pages, and we should somehow throttle this, because
> 
> >>>     This means that all memory is pinned and unreclaimable and the VM gets
> >>>     upset and goes oom.
> 
> although, it's not quite clear in my mind, how the VM gets upset about
> this.

I've been scratching my head on and off for a couple of days over this.

We've traditionally had reclaim problems when there's a huge amount of
dirty MAP_SHARED data, which the VM didn't know was dirty.  It's the old
"map a file which is the same size as physical memory and write to it all"
stresstest.

But we do not have such problems with anonymous memory, and I'm darned if I
can remember why :(

