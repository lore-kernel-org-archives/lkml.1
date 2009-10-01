Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZJAVDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZJAVDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZJAVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:03:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZJAVDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:03:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=drxAm5hxGHBXhrhI626JGIWs0AkA7R6/Sr1QU1cvATcBpgfnRZkUAwCq91xEn3TnI
	jyfNw0T95QY8lBpDwWnmA==
Date: Thu, 1 Oct 2009 14:03:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Suresh Jayaraman <sjayaraman@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 03/31] mm: expose gfp_to_alloc_flags()
In-Reply-To: <1254405903-15760-1-git-send-email-sjayaraman@suse.de>
Message-ID: <alpine.DEB.1.00.0910011355230.32006@chino.kir.corp.google.com>
References: <1254405903-15760-1-git-send-email-sjayaraman@suse.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Suresh Jayaraman wrote:

> From: Peter Zijlstra <a.p.zijlstra@chello.nl> 
> 
> Expose the gfp to alloc_flags mapping, so we can use it in other parts
> of the vm.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Nack, these flags are internal to the page allocator and exporting them to 
generic VM code is unnecessary.

The only bit you actually use in your patchset is ALLOC_NO_WATERMARKS to 
determine whether a particular allocation can use memory reserves.  I'd 
suggest adding a bool function that returns whether the current context is 
given access to reserves including your new __GFP_MEMALLOC flag and 
exporting that instead.
