Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752482AbYLRRDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbYLRRDg (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbYLRRD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:03:26 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:53906 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbYLRRDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:03:25 -0500
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
	hooks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812181048160.12300@quilx.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
	 <494184AA.8090509@cs.helsinki.fi>
	 <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
	 <1229597162.1047.48.camel@penberg-laptop>
	 <1229618308.16418.50.camel@pc1117.cambridge.arm.com>
	 <Pine.LNX.4.64.0812181048160.12300@quilx.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 18 Dec 2008 17:02:44 +0000
Message-Id: <1229619764.16418.54.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2008 17:02:46.0326 (UTC) FILETIME=[730CFD60:01C96132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 10:49 -0600, Christoph Lameter wrote:
> On Thu, 18 Dec 2008, Catalin Marinas wrote:
> 
> > In the ____cache_alloc() kmemleak clears the
> > cachep->array->entry[ac->avail] pointer but this may not be enough as
> > freed and later re-allocated objects may have pointers in the alien
> > cache (is that correct?). A better approach (haven't tried it yet) would
> > be not to scan objects allocated via alloc_arraycache() at all. However,
> > there is still the initarray_cache/generic which are automatically
> > scanned via the data section (unless I add an attribute to place them in
> > a different, not scanned, section).
> 
> An allocated object is not part of any cache in SLAB. Only freed objects
> are kept in the slab queues. A freed object can only be in one queue at a
> time.

OK, but is there a chance that an stale pointer remains in such caches?
There seems to be the transfer_objects() function that moves pointers
around but doesn't clear the source values.

-- 
Catalin

