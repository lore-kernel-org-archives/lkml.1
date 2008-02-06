Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYBFUOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYBFUOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbYBFUO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:14:28 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:52082 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbYBFUO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:14:27 -0500
Date: Wed, 6 Feb 2008 20:13:04 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       William Lee Irwin III <wli@holomorphy.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH] sys_remap_file_pages: fix ->vm_file accounting
In-Reply-To: <20080203182952.GB5827@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0802061957110.32204@blonde.site>
References: <20080130142014.GA2164@tv-sign.ru> <1201712101.31222.22.camel@tucsk.pomaz.szeredi.hu>
 <20080130172646.GA2355@tv-sign.ru> <20080203182952.GB5827@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ removed stable ]

On Sun, 3 Feb 2008, Oleg Nesterov wrote:
> Off-topic question to all. sys_remap_file_pages() doesn't work with
> shared readonly mappings, why?

Slight correction: it works with shared readonly mappings, doesn't
it, so long as the mmap'ed file was opened for reading and writing?

> IOW, why it checks VM_SHARED but not VM_MAYSHARE?

My guess has always been that it was just a misunderstanding of how
those VM_ flags end up working: assume so unless Ingo corrects me.

By the time I realized that oddity, we'd been driven into several
tiresome corners by the very existence of sys_remap_file_pages.
So whereas my usual instinct would have been to relax the restriction
and generalize, in its case I wanted to hold on to every restriction
we had.

sys_remap_file_pages does serve a useful purpose; but it subverts
vma principles, and has therefore caused us grief repeatedly.

Hugh
