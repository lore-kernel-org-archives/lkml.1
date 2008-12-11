Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYLKVee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYLKVee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbYLKVeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:34:25 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55965 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbYLKVeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:34:25 -0500
Message-ID: <4941866D.5040005@cs.helsinki.fi>
Date: Thu, 11 Dec 2008 23:30:21 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 05/15] kmemleak: Add the slub memory allocation/freeing
 hooks
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com> <20081210182721.30323.55530.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182721.30323.55530.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> This patch adds the callbacks to memleak_(alloc|free) functions from the
> slub allocator.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>

Hmm, I'm not sure I understand why struct kmem_cache_cpu ->freelist is 
never scanned. For SMP, I suppose kmemleak doesn't scan the per-CPU 
areas? But for UP, struct kmem_cache is allocated with kmalloc() and 
that contains struct kmem_cache_cpu as well.

And I suppose we never scan struct pages either. Otherwise ->freelist 
there would be a problem as well.

		Pekka
