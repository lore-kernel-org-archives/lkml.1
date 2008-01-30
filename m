Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbYA3RYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbYA3RYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYA3RX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:23:58 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57248 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYA3RX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:23:57 -0500
Date: Wed, 30 Jan 2008 20:26:46 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
Message-ID: <20080130172646.GA2355@tv-sign.ru>
References: <20080130142014.GA2164@tv-sign.ru> <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Miklos Szeredi wrote:
> 
> On Wed, 2008-01-30 at 17:20 +0300, Oleg Nesterov wrote:
> > Fix ->vm_file accounting, mmap_region() may do do_munmap().
> 
> There's a small problem with the patch: the vma itself is freed at
> unmap, so the fput(vma->vm_file) may crash.  Here's an updated patch.

Ah, indeed, thanks!


Offtopic. I noticed this problem while looking at this patch:

	http://marc.info/?l=linux-mm-commits&m=120141116911711

So this (the old vma could be removed before we create the new mapping)
means that the patch above has another problem: if we are remapping the
whole VM_EXECUTABLE vma, removed_exe_file_vma() can clear ->exe_file
while it shouldn't (Matt Helsley cc'ed).

Oleg.

