Return-Path: <linux-kernel-owner+w=401wt.eu-S937156AbXGTBdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937156AbXGTBdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760856AbXGTBcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:32:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbXGTBcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:32:52 -0400
Date: Thu, 19 Jul 2007 18:32:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
Subject: Re: [PATCH] async_tx: fix kmap_atomic usage in async_memcpy
Message-Id: <20070719183202.f7045ede.akpm@linux-foundation.org>
In-Reply-To: <20070720011252.6443.34295.stgit@dwillia2-linux.ch.intel.com>
References: <20070720011252.6443.34295.stgit@dwillia2-linux.ch.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 18:12:52 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Andrew Morton:
> 	[async_memcpy] is very wrong if both ASYNC_TX_KMAP_DST and
> 	ASYNC_TX_KMAP_SRC can ever be set.  We'll end up using the same kmap
> 	slot for both src add dest and we get either corrupted data or a BUG.
> 
> Evgeniy Polyakov:
> 	Btw, shouldn't it always be kmap_atomic() even if flag is not set.
> 	That pages are usual one returned by alloc_page().
> 
> So fix the usage of kmap_atomic and kill the ASYNC_TX_KMAP_DST and
> ASYNC_TX_KMAP_SRC flags.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  crypto/async_tx/async_memcpy.c |   19 ++++---------------
>  drivers/md/raid5.c             |    4 ++--
>  include/linux/async_tx.h       |    6 ------
>  3 files changed, 6 insertions(+), 23 deletions(-)

Neato.

You (or at least, Shannon) run a git tree.  I always get confused when
git-tree-owners send me patches, because I expect them to put the
patches into their git trees.

So if you, a git-tree-owner, wish me to merge-test-and-forward a patch,
please explicitly tell me.
