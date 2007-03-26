Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXCZIfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXCZIfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXCZIfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:35:41 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:38440 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbXCZIfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:35:40 -0400
To: akpm@linux-foundation.org
CC: dgc@sgi.com, linux-kernel@vger.kernel.org
In-reply-to: <20070325154143.54e40200.akpm@linux-foundation.org> (message from
	Andrew Morton on Sun, 25 Mar 2007 15:41:43 -0800)
Subject: Re: [patch 2/3] remove throttle_vm_writeout()
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	<E1HVEEw-0006cP-00@dorka.pomaz.szeredi.hu> <20070325154143.54e40200.akpm@linux-foundation.org>
Message-Id: <E1HVkfj-0000zn-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Mar 2007 10:35:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Remove this function.  It's purpose was to limit the global number of
> > writeback pages from submitted by direct reclaim.  But this is equally
> > well accomplished by limited queue lengths.  When this function was
> > added, the device queues had much larger default lengths (8192
> > requests, now it's 128), causing problems.
> 
> This changelog is wrong.
> 
> Yes, the _default_ depth of CFQ was decreased.  But it is trivial for the
> user to inrcrease the queue depth again, and we'd prefer that the VM not
> shit itself in response.
> 
> Plus, more significantly, the queue is per-disk.  A system with many disks
> will easily be able to cover all memory with under-writeback pages. 
> Which is why the level of under-writeback memory is controlled at a higher
> level.
> 
> These variables are why we must not reply upon per-queue throttling in
> VFS/MM/VM.
> 
> 
> All that being said, the patch (with a new, correct changlog) is OK.  This
> is because we now control the amount of dirty memory in the machine by
> running balance_dirty_pages() at first-write-fault time.  So we can no
> longer get into the situation where all memory is dirty+writeback.

Well, sort of.  I think you are not taking SwapCache pages into
account, which just pop up out of nothing to be turned into writeback
pages.

So I think removing this function still relies on limited queues, or
some other method of limiting writeback.

Miklos
