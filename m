Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZLAQBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZLAQBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZLAQBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:01:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59181 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbZLAQBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:01:41 -0500
Date: Tue, 1 Dec 2009 17:01:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       michal.simek@petalogix.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: problems in linux-next (Was: Re: linux-next: Tree for December 1)
Message-ID: <20091201160119.GA10826@elte.hu>
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
 <4B14D6E2.2040704@petalogix.com>
 <20091201210343.f0a1d353.sfr@canb.auug.org.au>
 <4B152D22.9070001@kernel.org>
 <alpine.DEB.2.00.0912010946340.8841@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912010946340.8841@router.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 1 Dec 2009, Tejun Heo wrote:
> 
> > The problem is that on UP configurations.  Percpu memory allocator 
> > becomes a simple wrapper around kmalloc and there's no way to 
> > specify larger alignment when requesting memory from kmalloc.
> 
> There is usually no point in aligning in UP. Alignment is typically 
> done for smp configurations to limit cache line bouncing and control 
> cache line use/

There is a natural minimum alignment for UP and it's smaller than the 
cache-line size: machine word size. All our allocators (except bootmem) 
align to machine word so there's no need to specify this explicitly.

Larger alignment than that just wastes memory - which waste UP systems 
can afford the least.

	Ingo
