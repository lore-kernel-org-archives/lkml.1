Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZLAPtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZLAPtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZLAPtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:49:00 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:51365 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZLAPtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:49:00 -0500
Date: Tue, 1 Dec 2009 09:48:07 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, michal.simek@petalogix.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: problems in linux-next (Was: Re: linux-next: Tree for December
 1)
In-Reply-To: <4B152D22.9070001@kernel.org>
Message-ID: <alpine.DEB.2.00.0912010946340.8841@router.home>
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au> <4B14D6E2.2040704@petalogix.com> <20091201210343.f0a1d353.sfr@canb.auug.org.au> <4B152D22.9070001@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Tejun Heo wrote:

> The problem is that on UP configurations.  Percpu memory allocator
> becomes a simple wrapper around kmalloc and there's no way to specify
> larger alignment when requesting memory from kmalloc.

There is usually no point in aligning in UP. Alignment is typically done
for smp configurations to limit cache line bouncing and control cache line
use/

> It would be best if there's a clean way to allocate memory with
> alignment larger than SMP_CACHE_BYTES.  If not, I think I'll add a
> separate cache for cwqs on UP so that the alignment requirement can be
> met.  Is there any way to get better aligned memory without creating a
> separate cache or allocating larger memory and aligning by chopping
> off?

Simply drop the alignment for UP?

