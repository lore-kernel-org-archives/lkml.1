Return-Path: <linux-kernel-owner+w=401wt.eu-S1031789AbXEEPfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031789AbXEEPfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031793AbXEEPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:35:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34266 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031789AbXEEPfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:35:39 -0400
Date: Sat, 5 May 2007 08:35:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Eric Dumazet <dada1@cosmosbay.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 2/3] SLUB: Implement targeted reclaim and partial list
 defragmentation
In-Reply-To: <20070505053211.GZ19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0705050833310.26574@schroedinger.engr.sgi.com>
References: <20070504221555.642061626@sgi.com> <20070504221708.596112123@sgi.com>
 <20070505053211.GZ19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, William Lee Irwin III wrote:

> kick_object() doesn't return an indicator of success, which might be
> helpful for determining whether an object was successfully removed. The
> later-added kick_dentry_object(), for instance, can't remove dentries
> where reference counts are still held.
> 
> I suppose one could check to see if the ->inuse counter decreased, too.

Yes that is exactly what is done. The issue is that concurrent frees may 
occur. So we just kick them all and see if all objects are gone at the 
end.
 
> In either event, it would probably be helpful to abort the operation if
> there was a reclamation failure for an object within the slab.

Hmmm... The failure may be because another process is attempting 
a kmem_cache_free on an object. But we are holding the lock. The free
will succeed when we drop it.

> This is a relatively minor optimization concern. I think this patch
> series is great and a significant foray into the problem of slab
> reclaim vs. fragmentation.

Thanks.

