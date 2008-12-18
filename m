Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752614AbYLRQtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbYLRQtm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 11:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYLRQtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 11:49:31 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:41474 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYLRQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 11:49:31 -0500
Date: Thu, 18 Dec 2008 10:49:07 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
 hooks
In-Reply-To: <1229618308.16418.50.camel@pc1117.cambridge.arm.com>
Message-ID: <Pine.LNX.4.64.0812181048160.12300@quilx.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com> 
 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com> 
 <494184AA.8090509@cs.helsinki.fi>  <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
  <1229597162.1047.48.camel@penberg-laptop> <1229618308.16418.50.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2008, Catalin Marinas wrote:

> In the ____cache_alloc() kmemleak clears the
> cachep->array->entry[ac->avail] pointer but this may not be enough as
> freed and later re-allocated objects may have pointers in the alien
> cache (is that correct?). A better approach (haven't tried it yet) would
> be not to scan objects allocated via alloc_arraycache() at all. However,
> there is still the initarray_cache/generic which are automatically
> scanned via the data section (unless I add an attribute to place them in
> a different, not scanned, section).

An allocated object is not part of any cache in SLAB. Only freed objects
are kept in the slab queues. A freed object can only be in one queue at a
time.

